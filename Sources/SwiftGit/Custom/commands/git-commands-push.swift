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
    func pushPublisher(_ options: [PushOptions] = [], refspecs: [Reference] = []) -> AnyPublisher<String, GitError> {
        runPublisher(["push"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    func pushPublisher(_ cmd: String) -> AnyPublisher<String, GitError> {
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
