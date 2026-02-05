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

            init(publisher: PassthroughSubject<Data, Never>?) {
                self.publisher = publisher
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

            public init() {}
        }

    }

    @available(macOS 11, *)
    extension Shell.Instance {

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
                let result = try SKProcessRunner.runSync(
                    executableURL: exec,
                    arguments: args.commands,
                    configuration: .init(
                        cwd: args.context?.currentDirectory,
                        environment: args.context?.environment ?? [:],
                        timeoutMs: 5 * 60 * 1000,
                        maxOutputBytes: 4 * 1024 * 1024
                    ),
                    onStdout: { stdoutPublisher?.send($0) },
                    onStderr: { stderrPublisher?.send($0) },
                    throwOnNonZeroExit: true
                )
                return result.stdoutData
            } catch let error as SKProcessRunner.RunError {
                throw Shell.Error.processFailed(message: error.localizedDescription, code: -1)
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
                let result = try SKProcessRunner.runSync(
                    executableURL: exec,
                    arguments: args.commands,
                    stdinData: input,
                    configuration: .init(
                        cwd: args.context?.currentDirectory,
                        environment: args.context?.environment ?? [:],
                        timeoutMs: 5 * 60 * 1000,
                        maxOutputBytes: 4 * 1024 * 1024
                    ),
                    onStdout: { stdoutPublisher?.send($0) },
                    onStderr: { stderrPublisher?.send($0) },
                    throwOnNonZeroExit: true
                )
                return result.stdoutData
            } catch let error as SKProcessRunner.RunError {
                throw Shell.Error.processFailed(message: error.localizedDescription, code: -1)
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
                                process, output: output.availableData, error: error.availableData
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
                let result = try await SKProcessRunner.run(
                    executableURL: exec,
                    arguments: args.commands,
                    stdinData: nil,
                    configuration: .init(
                        cwd: args.context?.currentDirectory,
                        environment: args.context?.environment ?? [:],
                        timeoutMs: 5 * 60 * 1000,
                        maxOutputBytes: 4 * 1024 * 1024
                    ),
                    onStdout: { stdoutPublisher?.send($0) },
                    onStderr: { stderrPublisher?.send($0) },
                    throwOnNonZeroExit: true
                )
                return result.stdoutData
            } catch let error as SKProcessRunner.RunError {
                throw Shell.Error.processFailed(message: error.localizedDescription, code: -1)
            }
        }

        @discardableResult
        public func string(_ args: Shell.Arguments) async throws -> String {
            let data = try await data(args)
            return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) ?? ""
        }

    }

#endif
