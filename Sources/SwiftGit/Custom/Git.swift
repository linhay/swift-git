//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation
import Combine

public class Git {
    
    private static var _shared: Git?
    public static var shared: Git {
        get throws {
            if let git = _shared { return git }
            let git = try Git(environment: .shared)
            _shared = git
            return git
        }
    }
    
    public let environment: GitEnvironment
    
    public init(environment: GitEnvironment) {
        self.environment = environment
    }
    
    private var cancellables = Set<AnyCancellable>()
}

public extension Git {
    
    func dataPublisher(_ commands: [String], context: GitShell.Context? = nil) -> AnyPublisher<Data, GitError> {
        self.triggerOfBeforeRun(commands)
        return GitShell
            .dataPublisher(self.environment.resource.executableURL, commands, context: self.deal(context: context))
            .map({ [weak self] data in
                guard let self = self else { return data }
                self.triggerOfAfterRun(commands, data: data)
                return data
            })
            .mapError({ [weak self] error in
                guard let self = self else { return error }
                _ = self.triggerOfAfterRun(commands, message: error.errorDescription ?? GitError.other(error).localizedDescription)
                return error
            })
            .eraseToAnyPublisher()
    }
    
    func runPublisher(_ options: [GitOptions]) -> AnyPublisher<String, GitError> {
        runPublisher(options.map(\.rawValue))
    }
    
    func runPublisher(_ commands: [String], context: GitShell.Context? = nil) -> AnyPublisher<String, GitError> {
        dataPublisher(commands, context: context)
            .map { data in
                String(data: data, encoding: .utf8) ?? ""
            }
            .eraseToAnyPublisher()
    }
    
    func runPublisher(_ cmd: String, context: GitShell.Context? = nil) -> AnyPublisher<String, GitError> {
        runPublisher(cmd.split(separator: " ").map(\.description), context: context)
    }
    
}

public extension Git {
    
    @discardableResult
    func data(_ commands: [String], context: GitShell.Context? = nil) async throws -> Data {
        do {
            triggerOfBeforeRun(commands)
            let data = try await GitShell.data(environment.resource.executableURL, commands, context: deal(context: context))
            triggerOfAfterRun(commands, data: data)
            return data
        } catch GitError.processFatal(let message) {
            throw triggerOfAfterRun(commands, message: message)
        } catch {
            throw triggerOfAfterRun(commands, message: error.localizedDescription)
        }
    }
    
    @discardableResult
    func run(_ options: [GitOptions]) async throws -> String {
        try await run(options.map(\.rawValue))
    }
    
    @discardableResult
    func run(_ commands: [String], context: GitShell.Context? = nil) async throws -> String {
        let data = try await data(commands, context: context)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    @discardableResult
    func run(_ cmd: String, context: GitShell.Context? = nil) async throws -> String {
        try await run(cmd.split(separator: " ").map(\.description), context: context)
    }
    
}

public extension Git {
    
    @discardableResult
    func data(_ commands: [String], context: GitShell.Context? = nil) throws -> Data {
        do {
            triggerOfBeforeRun(commands)
            let data = try GitShell.data(environment.resource.executableURL, commands, context: deal(context: context))
            triggerOfAfterRun(commands, data: data)
            return data
        } catch GitError.processFatal(let message) {
            throw triggerOfAfterRun(commands, message: message)
        } catch {
            throw triggerOfAfterRun(commands, message: error.localizedDescription)
        }
    }
    
    @discardableResult
    func run(_ options: [GitOptions]) throws -> String {
        try run(options.map(\.rawValue))
    }
    
    @discardableResult
    func run(_ commands: [String], context: GitShell.Context? = nil) throws -> String {
        let data = try data(commands, context: context)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    @discardableResult
    func run(_ cmd: String, context: GitShell.Context? = nil) throws -> String {
        try run(cmd.split(separator: " ").map(\.description), context: context)
    }
    
}

public extension Git {
    
    func repository(at url: URL) throws -> Repository {
        try Repository(url: url, environment: environment)
    }
    
    func repository(at path: String) throws -> Repository {
        try Repository(path: path, environment: environment)
    }
    
}

private extension Git {
    
    func deal(context: GitShell.Context?) -> GitShell.Context {
        var environmentDict = context?.environment ?? [:]
        environment.variables.forEach { item in
            environmentDict[item.key] = item.value
        }
        return GitShell.Context(environment: environmentDict,
                                at: context?.currentDirectory,
                                standardOutput: context?.standardOutput,
                                standardError: context?.standardError)
    }
    
    func triggerOfAfterRun(_ commands: [String], data: Data) {
        if let triggers = environment.triggersMap[.afterRun] {
            let content = GitTrigger.Content(commands: commands, data: data)
            triggers.forEach({ item in
                item.action(.success(content))
            })
        }
    }
    
    func triggerOfAfterRun(_ commands: [String], message: String) -> GitError {
        let error = GitTrigger.Error(commands: commands, message: message)
        environment.triggersMap[.afterRun]?.forEach({ item in
            item.action(.failure(error))
        })
        return GitError.processFatal(error.message)
    }
    
    func triggerOfBeforeRun(_ commands: [String]) {
        if let triggers = environment.triggersMap[.beforeRun] {
            let content = GitTrigger.Content(commands: commands, data: Data())
            triggers.forEach({ item in
                item.action(.success(content))
            })
        }
    }
    
}
