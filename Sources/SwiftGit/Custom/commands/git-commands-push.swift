//
//  File.swift
//  
//
//  Created by linhey on 2022/5/11.
//

import Foundation
import Combine

public extension Repository {
    
    /// https://git-scm.com/docs/git-push
    func pushPublisher(_ options: [PushOptions] = [], refspecs: [Reference] = []) -> AnyPublisher<String, Error> {
        runPublisher(["push"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    func pushPublisher(_ cmd: String) -> AnyPublisher<String, Error> {
        runPublisher(["push"] + cmd.split(separator: " ").map(\.description))
    }
    
}

public extension Repository {
    
    /// https://git-scm.com/docs/git-push
    @discardableResult
    func push(_ options: [PushOptions] = [], refspecs: [Reference] = []) async throws -> String {
        try await run(["push"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func push(_ cmd: String) async throws -> String {
        try await run(["push"] + cmd.split(separator: " ").map(\.description))
    }
    
}

public extension Repository {
    
    /// https://git-scm.com/docs/git-push
    @discardableResult
    func push(_ options: [PushOptions] = [], refspecs: [Reference] = []) throws -> String {
        try run(["push"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func push(_ cmd: String) throws -> String {
        try run(["push"] + cmd.split(separator: " ").map(\.description))
    }
    
}

public extension Repository {
    
    var push: Push { .init(repository: self) }
    
    struct Push {
        
        let repository: Repository
        
        public func tag(_ name: String) async throws {
            try await repository.push([.origin], refspecs: [.other(name)])
        }
        
        
        public func delete(_ refs: Reference) async throws {
            try await repository.push([.delete, .origin], refspecs: [refs])
        }
        
    }
    
}

public extension PushOptions {

    static let origin: Self = "origin"

    
}
