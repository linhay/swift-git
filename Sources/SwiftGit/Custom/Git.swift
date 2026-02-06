//
//  File.swift
//
//
//  Created by linhey on 2022/1/23.
//

import Combine
import Foundation

public class Git {

    public static var _shared: Git?
    public static var shared: Git {
        get throws {
            if let git = _shared { return git }
            let git = try Git(environment: .shared)
            _shared = git
            return git
        }
    }

    public private(set) var environment: GitEnvironment
    private let environments: [GitEnvironment]
    private var activeEnvironment: GitEnvironment?
    public var shell = Shell.Instance()

    public init(environment: GitEnvironment) {
        self.environment = environment
        self.environments = [environment]
    }

    public init(environments: [GitEnvironment]) {
        precondition(!environments.isEmpty, "Git requires at least one GitEnvironment")
        self.environments = environments
        self.environment = environments[0]
    }

    private var cancellables = Set<AnyCancellable>()
}

extension Git {

    public func dataPublisher(_ commands: [String], context: Shell.Context? = nil)
        -> AnyPublisher<Data, Error>
    {
        let env: GitEnvironment
        do {
            env = try resolveEnvironment()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        self.triggerOfBeforeRun(commands, environment: env)
        return
            shell
            .dataPublisher(
                Shell.Arguments(
                    exec: env.resource.executableURL,
                    commands: commands,
                    context: self.deal(context: context, environment: env))
            )
            .map({ [weak self] data in
                guard let self = self else { return data }
                self.triggerOfAfterRun(commands, data: data, environment: env)
                return data
            })
            .mapError({ [weak self] error in
                guard let self = self else { return error }
                _ = self.triggerOfAfterRun(
                    commands,
                    message: error.localizedDescription,
                    environment: env)
                return error
            })
            .eraseToAnyPublisher()
    }

    public func runPublisher(_ options: [GitOptions]) -> AnyPublisher<String, Error> {
        runPublisher(options.map(\.rawValue))
    }

    public func runPublisher(_ commands: [String], context: Shell.Context? = nil)
        -> AnyPublisher<String, Error>
    {
        dataPublisher(commands, context: context)
            .map { data in
                String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) ?? ""
            }
            .eraseToAnyPublisher()
    }

    public func runPublisher(_ cmd: String, context: Shell.Context? = nil) -> AnyPublisher<
        String, Error
    > {
        runPublisher(splitCommandLine(cmd), context: context)
    }

}

// Helper: split a shell-like command string into arguments.
// This is a lightweight splitter and does not cover all shell quoting rules,
// but improves upon simple `split(separator:" ")` by handling quoted substrings.
func splitCommandLine(_ cmd: String) -> [String] {
    var args: [String] = []
    var current = ""
    var inSingle = false
    var inDouble = false
    var escape = false
    for ch in cmd {
        if escape {
            current.append(ch)
            escape = false
            continue
        }
        if ch == "\\" {
            escape = true
            continue
        }
        if ch == "'" && !inDouble {
            inSingle.toggle()
            continue
        }
        if ch == "\"" && !inSingle {
            inDouble.toggle()
            continue
        }
        if ch == " " && !inSingle && !inDouble {
            if !current.isEmpty {
                args.append(current)
                current = ""
            }
            continue
        }
        current.append(ch)
    }
    if !current.isEmpty { args.append(current) }
    return args
}

extension Git {

    @discardableResult
    public func data(_ commands: [String], context: Shell.Context? = nil) async throws -> Data {
        do {
            let env = try resolveEnvironment()
            triggerOfBeforeRun(commands, environment: env)
            let data = try await shell.data(
                .init(
                    exec: env.resource.executableURL,
                    commands: commands,
                    context: deal(context: context, environment: env)))
            triggerOfAfterRun(commands, data: data, environment: env)
            return data
        } catch GitError.processFatal(let message) {
            let env = try resolveEnvironment()
            throw triggerOfAfterRun(commands, message: message, environment: env)
        } catch {
            let env = try resolveEnvironment()
            throw triggerOfAfterRun(commands, message: error.localizedDescription, environment: env)
        }
    }

    @discardableResult
    public func run(_ options: [GitOptions]) async throws -> String {
        try await run(options.map(\.rawValue))
    }

    @discardableResult
    public func run(_ commands: [String], context: Shell.Context? = nil) async throws -> String {
        let data = try await data(commands, context: context)
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) ?? ""
    }

    @discardableResult
    public func run(_ cmd: String, context: Shell.Context? = nil) async throws -> String {
        try await run(splitCommandLine(cmd), context: context)
    }

}

extension Git {

    @discardableResult
    func runWithProgress(
        _ commands: [String],
        context: Shell.Context? = nil,
        progress: @escaping @Sendable (GitProgress) -> GitProgressAction
    ) async throws -> String {
        try Task.checkCancellation()
        let env = try resolveEnvironment()
        triggerOfBeforeRun(commands, environment: env)
        let parser = GitProgressParser(progress: progress)
        do {
            let data = try await shell.data(
                .init(
                    exec: env.resource.executableURL,
                    commands: commands,
                    context: deal(context: context, environment: env)
                ),
                onStdout: { parser.handle($0) },
                onStderr: { parser.handle($0) },
                shouldCancel: { parser.isCancelRequested || Task.isCancelled }
            )
            parser.finish()
            triggerOfAfterRun(commands, data: data, environment: env)
            return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) ?? ""
        } catch is CancellationError {
            throw CancellationError()
        } catch GitError.processFatal(let message) {
            throw triggerOfAfterRun(commands, message: message, environment: env)
        } catch {
            throw triggerOfAfterRun(commands, message: error.localizedDescription, environment: env)
        }
    }

}

extension Git {

    @discardableResult
    public func data(_ commands: [String], context: Shell.Context? = nil) throws -> Data {
        do {
            let env = try resolveEnvironment()
            triggerOfBeforeRun(commands, environment: env)
            let data = try shell.data(
                .init(
                    exec: env.resource.executableURL,
                    commands: commands,
                    context: deal(context: context, environment: env)))
            triggerOfAfterRun(commands, data: data, environment: env)
            return data
        } catch GitError.processFatal(let message) {
            let env = try resolveEnvironment()
            throw triggerOfAfterRun(commands, message: message, environment: env)
        } catch {
            let env = try resolveEnvironment()
            throw triggerOfAfterRun(commands, message: error.localizedDescription, environment: env)
        }
    }

    @discardableResult
    public func run(_ options: [GitOptions]) throws -> String {
        try run(options.map(\.rawValue))
    }

    @discardableResult
    public func run(_ commands: [String], context: Shell.Context? = nil) throws -> String {
        let data = try data(commands, context: context)
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) ?? ""
    }

    @discardableResult
    public func run(_ cmd: String, context: Shell.Context? = nil) throws -> String {
        try run(splitCommandLine(cmd), context: context)
    }

}

extension Git {

    public func repository(at url: URL) -> Repository {
        Repository(git: self, url: url)
    }

    public func repository(at path: String) -> Repository {
        Repository(git: self, path: path)
    }

}

extension Git {

    fileprivate func deal(context: Shell.Context?, environment: GitEnvironment) -> Shell.Context {
        var environmentDict = context?.environment ?? [:]
        environment.variables.forEach { item in
            environmentDict[item.key] = item.value
        }
        let ctx = Shell.Context(
            environment: environmentDict,
            at: context?.currentDirectory,
            standardOutput: context?.standardOutput,
            standardError: context?.standardError)
        return ctx
    }

    fileprivate func triggerOfAfterRun(
        _ commands: [String],
        data: Data,
        environment: GitEnvironment
    ) {
        if let triggers = environment.triggersMap[.afterRun] {
            let content = GitTrigger.Content(commands: commands, data: data)
            triggers.forEach({ item in
                item.action(.success(content))
            })
        }
    }

    fileprivate func triggerOfAfterRun(
        _ commands: [String],
        message: String,
        environment: GitEnvironment
    ) -> GitError {
        let error = GitTrigger.Error(commands: commands, message: message)
        environment.triggersMap[.afterRun]?.forEach({ item in
            item.action(.failure(error))
        })
        return GitError.processFatal(error.message)
    }

    fileprivate func triggerOfBeforeRun(_ commands: [String], environment: GitEnvironment) {
        if let triggers = environment.triggersMap[.beforeRun] {
            let content = GitTrigger.Content(commands: commands, data: Data())
            triggers.forEach({ item in
                item.action(.success(content))
            })
        }
    }

}

extension Git {

    private func resolveEnvironment() throws -> GitEnvironment {
        if let active = activeEnvironment {
            return active
        }
        for env in environments {
            if isUsable(env) {
                activeEnvironment = env
                environment = env
                return env
            }
        }
        throw GitError.noGitInstanceFoundOnSystem
    }

    private func isUsable(_ env: GitEnvironment) -> Bool {
        let execPath = env.resource.executableURL.path
        guard FileManager.default.isExecutableFile(atPath: execPath) else {
            return false
        }
        if let execPath = env.resource.envExecPath {
            return FileManager.default.fileExists(atPath: execPath)
        }
        return true
    }

}
