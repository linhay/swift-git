//
//  Shell.swift
//
//
//  Created by linhey on 2022/6/24.
//

#if os(macOS)
    import Foundation
    import Combine
    import SKProcessRunner

    @available(macOS 11, *)
    public struct Shell {}

    @available(macOS 11, *)
    extension Shell {

        public enum Error: Swift.Error, LocalizedError {
            case processFailed(message: String, code: Int32)

            public var errorDescription: String? {
                switch self {
                case .processFailed(let message, _):
                    return message
                }
            }
        }
    }

    protocol AnyShellArguments {
        var arguments: Shell.Arguments { get }
    }

    @available(macOS 11, *)
    extension Shell {

        public struct Configuration {
            public var timeoutMs: Int
            public var maxOutputBytes: Int

            public init(timeoutMs: Int = 5 * 60 * 1000, maxOutputBytes: Int = 4 * 1024 * 1024) {
                self.timeoutMs = timeoutMs
                self.maxOutputBytes = maxOutputBytes
            }
        }

        public struct Context {

            public var environment: [String: String] = [:]
            public var currentDirectory: URL?

            public let standardOutput: PassthroughSubject<Data, Never>?
            public var standardError: PassthroughSubject<Data, Never>?

            public init(
                environment: [String: String] = [:],
                at currentDirectory: URL? = nil,
                standardOutput: PassthroughSubject<Data, Never>? = .init(),
                standardError: PassthroughSubject<Data, Never>? = .init()
            ) {
                self.currentDirectory = currentDirectory
                self.standardOutput = standardOutput
                self.standardError = standardError
                var placehoder = ProcessInfo.processInfo.environment
                placehoder["PATH"] = (placehoder["PATH"] ?? "") + ":" + (environment["PATH"] ?? "")
                self.environment = environment.merging(placehoder, uniquingKeysWith: { $1 })
            }
        }

        public class Standard {

            let pipe = Pipe()
            let publisher: PassthroughSubject<Data, Never>?
            let onData: ((Data) -> Void)?

            var availableData: Data? {
                get throws {
                    // If we have already accumulated data in _availableData return it.
                    // If _availableData is nil, fall back to readToEnd() to avoid
                    // racing with the readability handler which may initialize the buffer to empty.
                    if let data = _availableData, !data.isEmpty {
                        return data
                    }
                    return try pipe.fileHandleForReading.readToEnd()
                }
            }

            private var _availableData: Data?

            deinit {
                self.pipe.fileHandleForReading.readabilityHandler = nil
            }

            init(
                publisher: PassthroughSubject<Data, Never>?,
                onData: ((Data) -> Void)? = nil
            ) {
                self.publisher = publisher
                self.onData = onData
            }

            func finalizeData() -> Data? {
                pipe.fileHandleForReading.readabilityHandler = nil
                let remaining = try? pipe.fileHandleForReading.readToEnd()
                if let remaining, !remaining.isEmpty {
                    if _availableData == nil { _availableData = Data() }
                    _availableData?.append(remaining)
                    publisher?.send(remaining)
                    onData?(remaining)
                }
                if let data = _availableData, !data.isEmpty {
                    return data
                }
                return nil
            }

            func append(to standard: inout Any?) -> Self {
                // Initialize the buffer lazily when we first receive data to avoid
                // empty-but-non-nil state racing with readers.
                _availableData = nil
                standard = pipe
                pipe.fileHandleForReading.readabilityHandler = { [weak self] fh in
                    guard let self = self else { return }
                    let data = fh.availableData
                    if data.isEmpty {
                        self.pipe.fileHandleForReading.readabilityHandler = nil
                    } else {
                        if self._availableData == nil { self._availableData = Data() }
                        self._availableData?.append(data)
                        self.publisher?.send(data)
                        self.onData?(data)
                    }
                }
                return self
            }
        }

        public enum ShellKind: String {
            case zsh = "/bin/zsh"
        }

        public struct ShellArguments: AnyShellArguments {

            public var kind: ShellKind?
            public var command: String
            public var context: Context? = nil

            public init(kind: ShellKind? = nil, command: String, context: Context? = nil) {
                self.kind = kind
                self.command = command
                self.context = context
            }

            var arguments: Shell.Arguments {
                let path = kind?.rawValue ?? context?.environment["SHELL"] ?? "/bin/zsh"
                let exec = URL(fileURLWithPath: path)
                return .init(exec: exec, commands: ["-c", command], context: context)
            }

        }

        public struct Arguments: AnyShellArguments {

            public var exec: URL?
            public var commands: [String]
            public var context: Context? = nil

            public init(exec: URL? = nil, commands: [String], context: Context? = nil) {
                self.exec = exec
                self.commands = commands
                self.context = context
            }

            var arguments: Shell.Arguments { self }
        }

        public struct Instance {

            public var changedArgsBeforeRun: ((_ args: inout Arguments) -> Void)?
            public var configuration: Configuration

            public init(configuration: Configuration = .init()) {
                self.configuration = configuration
            }
        }

    }

    @available(macOS 11, *)
    extension Shell.Instance {
        private func makePayload(
            exec: URL,
            commands: [String],
            context: Shell.Context?,
            stdin: Data?
        ) -> SKProcessPayload {
            SKProcessPayload.executableURL(exec)
                .arguments(commands)
                .stdin(stdin)
                .cwd(context?.currentDirectory)
                .environment(SKProcessEnvironment(context?.environment ?? [:]))
                .timeoutMs(configuration.timeoutMs)
                .maxOutputBytes(configuration.maxOutputBytes)
                .throwOnNonZeroExit(true)
        }

        private func mapError(_ error: SKProcessRunError) -> Shell.Error {
            switch error {
            case .nonZeroExit(let exitCode, let stdoutData, let stderrData):
                let out = String(data: stdoutData, encoding: .utf8) ?? ""
                let err = String(data: stderrData, encoding: .utf8) ?? ""
                let message = err.isEmpty ? out : err
                return Shell.Error.processFailed(
                    message: "Process exited with status \(exitCode).\n\(message)",
                    code: Int32(exitCode)
                )
            case .timedOut(let timeoutMs, let stdoutData, let stderrData, _):
                let seconds = Double(timeoutMs) / 1000.0
                let out = String(data: stdoutData, encoding: .utf8) ?? ""
                let err = String(data: stderrData, encoding: .utf8) ?? ""
                let combined = [out, err].filter { !$0.isEmpty }.joined(separator: "\n")
                let message = "Timed out after \(Int(seconds))s.\n\(combined)"
                return Shell.Error.processFailed(message: message, code: -1)
            case .executableNotFound(let name):
                return Shell.Error.processFailed(
                    message: "Executable not found on PATH: \(name)",
                    code: -1
                )
            case .invalidExecutable(let value):
                return Shell.Error.processFailed(
                    message: "Invalid executable: \(value)",
                    code: -1
                )
            case .ptyFailed(let message):
                return Shell.Error.processFailed(
                    message: "PTY setup failed: \(message)",
                    code: -1
                )
            }
        }

        @discardableResult
        public func shell(_ args: Shell.ShellArguments) throws -> Data {
            return try data(args.arguments)
        }

        @discardableResult
        public func shell(string args: Shell.ShellArguments) throws -> String? {
            let data = try shell(args)
            return String.init(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines)
        }

        @discardableResult
        public func string(_ args: Shell.Arguments) throws -> String {
            let data = try data(args)
            return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) ?? ""
        }

        @discardableResult
        public func data(_ args: Shell.Arguments) throws -> Data {
            var args = args
            changedArgsBeforeRun?(&args)
            guard let exec = args.exec else {
                throw Shell.Error.processFailed(message: "Missing executable.", code: -1)
            }

            let stdoutPublisher = args.context?.standardOutput
            let stderrPublisher = args.context?.standardError

            do {
                let payload = makePayload(
                    exec: exec,
                    commands: args.commands,
                    context: args.context,
                    stdin: nil
                )
                let result = try SKProcessRunner.runSync(
                    payload,
                    onStdout: { stdoutPublisher?.send($0) },
                    onStderr: { stderrPublisher?.send($0) }
                )
                return result.stdoutData
            } catch let error as SKProcessRunError {
                throw mapError(error)
            }
        }

        @discardableResult
        public func data(_ args: Shell.Arguments, input: Data?) throws -> Data {
            var args = args
            changedArgsBeforeRun?(&args)
            guard let exec = args.exec else {
                throw Shell.Error.processFailed(message: "Missing executable.", code: -1)
            }

            let stdoutPublisher = args.context?.standardOutput
            let stderrPublisher = args.context?.standardError

            do {
                let payload = makePayload(
                    exec: exec,
                    commands: args.commands,
                    context: args.context,
                    stdin: input
                )
                let result = try SKProcessRunner.runSync(
                    payload,
                    onStdout: { stdoutPublisher?.send($0) },
                    onStderr: { stderrPublisher?.send($0) }
                )
                return result.stdoutData
            } catch let error as SKProcessRunError {
                throw mapError(error)
            }
        }

        @discardableResult
        public func zshPublisher(_ args: Shell.ShellArguments) -> AnyPublisher<Data, Error> {
            dataPublisher(args.arguments)
        }

        @discardableResult
        public func zshPublisher(string args: Shell.ShellArguments) -> AnyPublisher<String?, Error>
        {
            return zshPublisher(args).map { String(data: $0, encoding: .utf8) }
                .eraseToAnyPublisher()
        }

        @discardableResult
        public func stringPublisher(_ args: Shell.Arguments) -> AnyPublisher<String?, Error> {
            return dataPublisher(args).map { String(data: $0, encoding: .utf8) }
                .eraseToAnyPublisher()
        }

        @discardableResult
        public func dataPublisher(_ args: Shell.Arguments) -> AnyPublisher<Data, Error> {
            Future<Data, Error> { promise in
                do {
                    var args = args
                    changedArgsBeforeRun?(&args)
                    let process = setupProcess(args.exec, args.commands, context: args.context)
                    let output = Shell.Standard(publisher: args.context?.standardOutput).append(
                        to: &process.standardOutput)
                    let error = Shell.Standard(publisher: args.context?.standardError).append(
                        to: &process.standardError)
                    try process.run()
                    process.terminationHandler = { process in
                        do {
                            let data = try result(
                                process,
                                output: output.finalizeData(),
                                error: error.finalizeData()
                            ).get()
                            promise(.success(data))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                } catch {
                    promise(.failure(error))
                }
            }.eraseToAnyPublisher()
        }

        public func result(_ process: Process, output: Data?, error: Data?) -> Result<
            Data, Swift.Error
        > {
            if process.terminationStatus != .zero {
                if let data = error, let message = String(data: data, encoding: .utf8) {
                    return .failure(
                        Shell.Error.processFailed(message: message, code: process.terminationStatus)
                    )
                }

                if let data = output, let message = String(data: data, encoding: .utf8) {
                    return .failure(
                        Shell.Error.processFailed(message: message, code: process.terminationStatus)
                    )
                }

                var message = [String]()
                if let currentDirectory = process.currentDirectoryURL?.path {
                    message.append("currentDirectory: \(currentDirectory)")
                }
                message.append("reason: \(process.terminationReason)")
                message.append("code: \(process.terminationStatus)")
                return .failure(
                    Shell.Error.processFailed(
                        message: message.joined(separator: "\n"), code: process.terminationStatus))
            }
            return .success(output ?? Data())
        }

        public func setupProcess(_ exec: URL?, _ commands: [String], context: Shell.Context? = nil)
            -> Process
        {
            let process = Process()
            process.executableURL = exec
            process.arguments = commands
            process.currentDirectoryURL = context?.currentDirectory
            if let environment = context?.environment, !environment.isEmpty {
                process.environment = environment
            }
            return process
        }

    }

    @available(macOS 11, *)
    extension Shell {

        private static var shared: Instance { .init() }

        @discardableResult
        public static func zsh(_ command: String, context: Context? = nil) throws -> Data {
            try shared.shell(.init(kind: .zsh, command: command, context: context))
        }

        @discardableResult
        public static func zsh(string command: String, context: Context? = nil) throws -> String? {
            try shared.shell(string: .init(kind: .zsh, command: command, context: context))
        }

        @discardableResult
        public static func string(_ exec: URL?, _ commands: [String], context: Context? = nil)
            throws -> String
        {
            try shared.string(.init(exec: exec, commands: commands, context: context))
        }

        @discardableResult
        public static func data(_ exec: URL?, _ commands: [String], context: Context? = nil) throws
            -> Data
        {
            try shared.data(.init(exec: exec, commands: commands, context: context))
        }

    }

    // MARK: - Async/Await Support
    private final class CancellationState {
        private let lock = NSLock()
        private var cancelled = false

        func requestCancel() -> Bool {
            lock.lock()
            defer { lock.unlock() }
            if cancelled { return false }
            cancelled = true
            return true
        }

        var isCancelled: Bool {
            lock.lock()
            defer { lock.unlock() }
            return cancelled
        }
    }

    @available(macOS 11, *)
    extension Shell.Instance {

        @discardableResult
        public func data(_ args: Shell.Arguments) async throws -> Data {
            var args = args
            changedArgsBeforeRun?(&args)
            guard let exec = args.exec else {
                throw Shell.Error.processFailed(message: "Missing executable.", code: -1)
            }

            let stdoutPublisher = args.context?.standardOutput
            let stderrPublisher = args.context?.standardError

            do {
                let payload = makePayload(
                    exec: exec,
                    commands: args.commands,
                    context: args.context,
                    stdin: nil
                )
                let result = try await SKProcessRunner.run(
                    payload,
                    onStdout: { stdoutPublisher?.send($0) },
                    onStderr: { stderrPublisher?.send($0) }
                )
                return result.stdoutData
            } catch let error as SKProcessRunError {
                throw mapError(error)
            }
        }

        @discardableResult
        func data(
            _ args: Shell.Arguments,
            onStdout: ((Data) -> Void)? = nil,
            onStderr: ((Data) -> Void)? = nil,
            shouldCancel: @escaping @Sendable () -> Bool = { false }
        ) async throws -> Data {
            try Task.checkCancellation()
            var args = args
            changedArgsBeforeRun?(&args)
            guard let exec = args.exec else {
                throw Shell.Error.processFailed(message: "Missing executable.", code: -1)
            }

            let process = setupProcess(exec, args.commands, context: args.context)
            let cancellation = CancellationState()

            let output = Shell.Standard(
                publisher: args.context?.standardOutput,
                onData: { data in
                    onStdout?(data)
                    if shouldCancel() {
                        if cancellation.requestCancel() {
                            process.interrupt()
                        }
                    }
                }
            ).append(to: &process.standardOutput)

            let error = Shell.Standard(
                publisher: args.context?.standardError,
                onData: { data in
                    onStderr?(data)
                    if shouldCancel() {
                        if cancellation.requestCancel() {
                            process.interrupt()
                        }
                    }
                }
            ).append(to: &process.standardError)

            return try await withTaskCancellationHandler {
                try await withCheckedThrowingContinuation { continuation in
                    process.terminationHandler = { process in
                        do {
                            let data = try result(
                                process,
                                output: output.finalizeData(),
                                error: error.finalizeData()
                            ).get()
                            if cancellation.isCancelled {
                                continuation.resume(throwing: CancellationError())
                            } else {
                                continuation.resume(returning: data)
                            }
                        } catch {
                            if cancellation.isCancelled {
                                continuation.resume(throwing: CancellationError())
                            } else {
                                continuation.resume(throwing: error)
                            }
                        }
                    }
                    do {
                        try process.run()
                    } catch {
                        process.terminationHandler = nil
                        continuation.resume(throwing: error)
                    }
                }
            } onCancel: {
                if cancellation.requestCancel() {
                    process.interrupt()
                }
            }
        }

        @discardableResult
        public func string(_ args: Shell.Arguments) async throws -> String {
            let data = try await data(args)
            return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) ?? ""
        }

    }

#endif
