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

    public let environment: GitEnvironment
    public var shell = Shell.Instance()

    public init(environment: GitEnvironment) {
        self.environment = environment
    }

    private var cancellables = Set<AnyCancellable>()
}

extension Git {

    public func dataPublisher(_ commands: [String], context: Shell.Context? = nil)
        -> AnyPublisher<Data, Error>
    {
        self.triggerOfBeforeRun(commands)
        return
            shell
            .dataPublisher(
                Shell.Arguments(
                    exec: self.environment.resource.executableURL,
                    commands: commands,
                    context: self.deal(context: context))
            )
            .map({ [weak self] data in
                guard let self = self else { return data }
                self.triggerOfAfterRun(commands, data: data)
                return data
            })
            .mapError({ [weak self] error in
                guard let self = self else { return error }
                _ = self.triggerOfAfterRun(commands, message: error.localizedDescription)
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
            triggerOfBeforeRun(commands)
            let data = try await shell.data(
                .init(
                    exec: environment.resource.executableURL,
                    commands: commands,
                    context: deal(context: context)))
            triggerOfAfterRun(commands, data: data)
            return data
        } catch GitError.processFatal(let message) {
            throw triggerOfAfterRun(commands, message: message)
        } catch {
            throw triggerOfAfterRun(commands, message: error.localizedDescription)
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
    public func data(_ commands: [String], context: Shell.Context? = nil) throws -> Data {
        do {
            triggerOfBeforeRun(commands)
            let data = try shell.data(
                .init(
                    exec: environment.resource.executableURL,
                    commands: commands,
                    context: deal(context: context)))
            triggerOfAfterRun(commands, data: data)
            return data
        } catch GitError.processFatal(let message) {
            throw triggerOfAfterRun(commands, message: message)
        } catch {
            throw triggerOfAfterRun(commands, message: error.localizedDescription)
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

    fileprivate func deal(context: Shell.Context?) -> Shell.Context {
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

    fileprivate func triggerOfAfterRun(_ commands: [String], data: Data) {
        if let triggers = environment.triggersMap[.afterRun] {
            let content = GitTrigger.Content(commands: commands, data: data)
            triggers.forEach({ item in
                item.action(.success(content))
            })
        }
    }

    fileprivate func triggerOfAfterRun(_ commands: [String], message: String) -> GitError {
        let error = GitTrigger.Error(commands: commands, message: message)
        environment.triggersMap[.afterRun]?.forEach({ item in
            item.action(.failure(error))
        })
        return GitError.processFatal(error.message)
    }

    fileprivate func triggerOfBeforeRun(_ commands: [String]) {
        if let triggers = environment.triggersMap[.beforeRun] {
            let content = GitTrigger.Content(commands: commands, data: Data())
            triggers.forEach({ item in
                item.action(.success(content))
            })
        }
    }

}
