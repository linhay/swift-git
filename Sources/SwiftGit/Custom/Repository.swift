//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation

public struct Repository {
    
    public let localURL: URL
    public let environment: GitEnvironment
    public let git: Git
    
    public init(url: URL, environment: GitEnvironment) throws {
        self.localURL = url
        self.environment = environment
        self.git = .init(environment: environment)
    }
    
    public init(path: String, environment: GitEnvironment) throws {
        try self.init(url: .init(fileURLWithPath: path), environment: environment)
    }
    
}

public extension Repository {
    
    @discardableResult
    func data(_ commands: [String]) async throws -> Data {
        try await git.data(commands, context: .init(at: localURL))
    }
    
    @discardableResult
    func run(_ commands: [String]) async throws -> String {
        try await git.run(commands, context: .init(at: localURL))
    }
    
    @discardableResult
    func data(_ cmd: String) async throws -> Data {
        try await data(cmd.split(separator: " ").map(\.description))
    }
    
    @discardableResult
    func run(_ cmd: String) async throws -> String {
        try await run(cmd.split(separator: " ").map(\.description))
    }
    
}

public extension Repository {
    
    @discardableResult
    func data(_ commands: [String]) throws -> Data {
        try git.data(commands, context: .init(at: localURL))
    }
    
    @discardableResult
    func run(_ commands: [String]) throws -> String {
        try git.run(commands, context: .init(at: localURL))
    }
    
    @discardableResult
    func data(_ cmd: String) throws -> Data {
        try data(cmd.split(separator: " ").map(\.description))
    }
    
    @discardableResult
    func run(_ cmd: String) throws -> String {
        try run(cmd.split(separator: " ").map(\.description))
    }
    
}
