//
//  File.swift
//  
//
//  Created by linhey on 2022/5/10.
//

import Foundation
import Combine

public extension Repository {
    
    /// https://git-scm.com/docs/git-reset
    func resetPublisher(_ options: [ResetOptions] = [], paths: [Pathspec]) -> AnyPublisher<String, Error> {
        runPublisher(["reset"] + options.map(\.rawValue) + ["--"] + paths.map(\.value))
    }
    
    func resetPublisher(_ options: [ResetOptions] = [], treeIsh: TreeIsh) -> AnyPublisher<String, Error> {
        runPublisher(["reset"] + options.map(\.rawValue) + [treeIsh.value])
    }
    
    func resetPublisher(_ options: [ResetOptions] = [], commit: Commit) -> AnyPublisher<String, Error> {
        runPublisher(["reset"] + options.map(\.rawValue) + [commit.name])
    }
    
    func resetPublisher(_ cmd: String) -> AnyPublisher<String, Error> {
        runPublisher("reset " + cmd)
    }
    
}


public extension Repository {
    
    /// https://git-scm.com/docs/git-reset
    @discardableResult
    func reset(_ options: [ResetOptions] = [], paths: [Pathspec]) async throws -> String {
        try await run(["reset"] + options.map(\.rawValue) + ["--"] + paths.map(\.value))
    }
    
    @discardableResult
    func reset(_ options: [ResetOptions] = [], treeIsh: TreeIsh) async throws -> String {
        try await run(["reset"] + options.map(\.rawValue) + [treeIsh.value])
    }
    
    @discardableResult
    func reset(_ options: [ResetOptions] = [], commit: Commit) async throws -> String {
        try await run(["reset"] + options.map(\.rawValue) + [commit.name])
    }
    
    @discardableResult
    func reset(_ cmd: String) async throws -> String {
        try await run("reset " + cmd)
    }
    
}

public extension Repository {
    
    /// https://git-scm.com/docs/git-reset
    @discardableResult
    func reset(_ options: [ResetOptions] = [], paths: [Pathspec]) throws -> String {
        try run(["reset"] + options.map(\.rawValue) + ["--"] + paths.map(\.value))
    }
    
    @discardableResult
    func reset(_ options: [ResetOptions] = [], treeIsh: TreeIsh) throws -> String {
        try run(["reset"] + options.map(\.rawValue) + [treeIsh.value])
    }
    
    @discardableResult
    func reset(_ options: [ResetOptions] = [], commit: Commit) throws -> String {
        try run(["reset"] + options.map(\.rawValue) + [commit.name])
    }
    
    @discardableResult
    func reset(_ cmd: String) throws -> String {
        try run("reset " + cmd)
    }
    
}

public extension Repository {
    
    struct TreeIsh: ExpressibleByStringLiteral {
        
        public let value: String
        
        public init(stringLiteral value: StringLiteralType) {
            self.value = value
        }
        
        public init(_ value: StringLiteralType) {
            self.value = value
        }
        
    }
    
}
