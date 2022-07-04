//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation

public struct Git {
    
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
    
}

public extension Git {
    
    @discardableResult
    func run(_ options: [GitOptions]) async throws -> String {
        try await run(options.map(\.rawValue))
    }
    
    @discardableResult
    func data(_ commands: [String], env: [String: String]? = nil, currentDirectoryURL: URL? = nil) async throws -> Data {
        do {
            var environmentDict = [String: String]()
            environment.variables.forEach { item in
                environmentDict[item.key] = item.value
            }
            
            if let triggers = environment.triggersMap[.beforeRun] {
                let content = GitTrigger.Content(commands: commands, data: Data())
                triggers.forEach({ item in
                    item.action(.success(content))
                })
            }
            
            let data = try await GitShell.data(environment.resource.executableURL,
                                               commands,
                                               context: .init(environment: environmentDict,
                                                              at: currentDirectoryURL,
                                                              standardOutput: nil,
                                                              standardError: nil))
            if let triggers = environment.triggersMap[.afterRun] {
                let content = GitTrigger.Content(commands: commands, data: data)
                triggers.forEach({ item in
                    item.action(.success(content))
                })
            }
            return data
        } catch GitError.processFatal(let message) {
            let error = GitTrigger.Error(commands: commands, message: message)
            environment.triggersMap[.afterRun]?.forEach({ item in
                item.action(.failure(error))
            })
            throw GitError.processFatal(error.message)
        } catch {
            let error = GitTrigger.Error(commands: commands, message: error.localizedDescription)
            environment.triggersMap[.afterRun]?.forEach({ item in
                item.action(.failure(error))
            })
            throw error
        }
    }
    
    @discardableResult
    func run(_ commands: [String], env: [String: String]? = nil, currentDirectoryURL: URL? = nil) async throws -> String {
        let data = try await data(commands, env: env, currentDirectoryURL: currentDirectoryURL)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    @discardableResult
    func run(_ cmd: String, env: [String: String]? = nil, currentDirectoryURL: URL? = nil) async throws -> String {
        try await run(cmd.split(separator: " ").map(\.description), env: env, currentDirectoryURL: currentDirectoryURL)
    }
    
}

public extension Git {
    
    @discardableResult
    func run(_ options: [GitOptions]) throws -> String {
        try run(options.map(\.rawValue))
    }
    
    @discardableResult
    func data(_ commands: [String], env: [String: String]? = nil, currentDirectoryURL: URL? = nil) throws -> Data {
        do {
            var environmentDict = [String: String]()
            environment.variables.forEach { item in
                environmentDict[item.key] = item.value
            }
            
            if let triggers = environment.triggersMap[.beforeRun] {
                let content = GitTrigger.Content(commands: commands, data: Data())
                triggers.forEach({ item in
                    item.action(.success(content))
                })
            }
            
            let data = try GitShell.data(environment.resource.executableURL,
                                         commands,
                                         context: .init(environment: environmentDict,
                                                        at: currentDirectoryURL,
                                                        standardOutput: nil,
                                                        standardError: nil))
            if let triggers = environment.triggersMap[.afterRun] {
                let content = GitTrigger.Content(commands: commands, data: data)
                triggers.forEach({ item in
                    item.action(.success(content))
                })
            }
            return data
        } catch GitError.processFatal(let message) {
            let error = GitTrigger.Error(commands: commands, message: message)
            environment.triggersMap[.afterRun]?.forEach({ item in
                item.action(.failure(error))
            })
            throw GitError.processFatal(error.message)
        } catch {
            let error = GitTrigger.Error(commands: commands, message: error.localizedDescription)
            environment.triggersMap[.afterRun]?.forEach({ item in
                item.action(.failure(error))
            })
            throw error
        }
    }
    
    @discardableResult
    func run(_ commands: [String], env: [String: String]? = nil, currentDirectoryURL: URL? = nil) throws -> String {
        let data = try data(commands, env: env, currentDirectoryURL: currentDirectoryURL)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    @discardableResult
    func run(_ cmd: String, env: [String: String]? = nil, currentDirectoryURL: URL? = nil) throws -> String {
        try run(cmd.split(separator: " ").map(\.description), env: env, currentDirectoryURL: currentDirectoryURL)
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
