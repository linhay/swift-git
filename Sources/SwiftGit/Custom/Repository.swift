//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation
import Combine

public struct Repository {
    
    public let localURL: URL
    public let git: Git
    
    public init(git: Git, url: URL) {
        self.localURL = url
        self.git = git
    }
    
    public init(git: Git, path: String) {
        self.init(git: git, url: .init(fileURLWithPath: path))
    }
    
}

public extension Repository {
    
    func dataPublisher(_ commands: [String]) -> AnyPublisher<Data, Error> {
        git.dataPublisher(commands, context: .init(at: localURL))
    }
    
    func dataPublisher(_ cmd: String) -> AnyPublisher<Data, Error> {
        dataPublisher(cmd.split(separator: " ").map(\.description))
    }
    
    func runPublisher(_ commands: [String]) -> AnyPublisher<String, Error> {
        git.runPublisher(commands, context: .init(at: localURL))
    }
    
    func runPublisher(_ cmd: String) -> AnyPublisher<String, Error> {
        runPublisher(cmd.split(separator: " ").map(\.description))
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
