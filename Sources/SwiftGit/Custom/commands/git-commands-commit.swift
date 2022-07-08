//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation
import Combine

public extension Repository {
    
    /// https://git-scm.com/docs/git-commit
    @discardableResult
    func commitPublisher(_ options: [CommitOptions] = [], pathspecs: [Pathspec] = []) -> AnyPublisher<String, GitError> {
        runPublisher(["commit"] + options.map(\.rawValue) + pathspecs.map(\.value))
    }
    
    @discardableResult
    func commitPublisher(_ cmd: String) -> AnyPublisher<String, GitError> {
        runPublisher("commit " + cmd)
    }
    
}

public extension Repository {
    
    /// https://git-scm.com/docs/git-commit
    @discardableResult
    func commit(_ options: [CommitOptions] = [], pathspecs: [Pathspec] = []) async throws -> String {
        try await run(["commit"] + options.map(\.rawValue) + pathspecs.map(\.value))
    }
    
    @discardableResult
    func commit(_ cmd: String) async throws -> String {
        try await run("commit " + cmd)
    }
    
}

public extension Repository {
    
    /// https://git-scm.com/docs/git-commit
    @discardableResult
    func commit(_ options: [CommitOptions] = [], pathspecs: [Pathspec] = []) throws -> String {
        try run(["commit"] + options.map(\.rawValue) + pathspecs.map(\.value))
    }
    
    @discardableResult
    func commit(_ cmd: String) throws -> String {
        try run("commit " + cmd)
    }
    
}
