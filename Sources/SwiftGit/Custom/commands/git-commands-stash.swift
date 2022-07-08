//
//  File.swift
//  
//
//  Created by linhey on 2022/5/16.
//

import Foundation
import Combine

/// https://git-scm.com/docs/git-stash
public extension Repository {
    
    func stashPublisher(_ cmd: String) -> AnyPublisher<String, GitError> {
        runPublisher("stash " + cmd)
    }
    
}

public extension Repository {
    
    @discardableResult
    func stash(_ cmd: String) async throws -> String {
        try await run("stash " + cmd)
    }
    
}

public extension Repository {
    
    @discardableResult
    func stash(_ cmd: String) throws -> String {
        try run("stash " + cmd)
    }
    
}

public extension Repository {
    
    struct Stash {
        let repository: Repository
    }
    
    var stash: Stash { .init(repository: self) }
}

public extension Repository.Stash {
    
    func listPublisher(_ options: [LogOptions] = []) -> AnyPublisher<String, GitError> {
        repository.runPublisher(["stash", "list"] + options.map(\.rawValue))
    }
    
    func showPublisher(_ options: [StashOptions.ShowSet] = [], diff: [DiffOptions] = [], stash: String? = nil) -> AnyPublisher<String, GitError> {
        repository.runPublisher(["stash"] + options.map(\.options.rawValue) + diff.map(\.rawValue) + [stash].compactMap({ $0 }))
    }
    
    func dropPublisher(_ options: [StashOptions.DropSet] = [], stash: String? = nil) -> AnyPublisher<String, GitError> {
        repository.runPublisher(["stash", "drop"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }))
    }
    
    func popPublisher(_ options: [StashOptions.PopSet] = [], stash: String? = nil) -> AnyPublisher<String, GitError> {
        repository.runPublisher(["stash", "pop"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }))
    }
    
    func applyPublisher(_ options: [StashOptions.PopSet] = [], stash: String? = nil) -> AnyPublisher<String, GitError> {
        repository.runPublisher(["stash", "apply"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }))
    }
    
    func branchPublisher(_ branchname: String, stash: String? = nil) -> AnyPublisher<String, GitError> {
        repository.runPublisher(["stash", "branch", "branchname"] + [stash].compactMap({ $0 }))
    }
    
    func pushPublisher(_ options: [StashOptions.PushSet] = [], pathspec: [Pathspec] = .all) -> AnyPublisher<String, GitError> {
        repository.runPublisher(["stash"] + options.map(\.options.rawValue) + pathspec.map(\.value))
    }
    
    func callAsFunctionPublisher(_ options: [StashOptions.PushSet] = [], pathspec: [Pathspec] = .all) -> AnyPublisher<String, GitError> {
        repository.runPublisher(["stash"] + options.map(\.options.rawValue) + pathspec.map(\.value))
    }
    
    func clearPublisher() -> AnyPublisher<String, GitError> {
        repository.runPublisher(["stash", "clear"])
    }
    
    func createPublisher(_ message: String) -> AnyPublisher<String, GitError> {
        repository.runPublisher(["stash", "create", message])
    }
    
    func storePublisher(_ options: [StashOptions.StoreSet] = [], commit: String) -> AnyPublisher<String, GitError> {
        repository.runPublisher(["stash", "store"] + options.map(\.options.rawValue) + [commit])
    }
    
    func savePublisher(message: String? = nil) -> AnyPublisher<String, GitError> {
        repository.runPublisher(["stash", "save"] + [message].compactMap({ $0 }))
    }
    
}


public extension Repository.Stash {
    
    @discardableResult
    func list(_ options: [LogOptions] = []) async throws -> String {
        try await repository.run(["stash", "list"] + options.map(\.rawValue))
    }
    
    @discardableResult
    func show(_ options: [StashOptions.ShowSet] = [], diff: [DiffOptions] = [], stash: String? = nil) async throws -> String {
        try await repository.run(["stash"] + options.map(\.options.rawValue) + diff.map(\.rawValue) + [stash].compactMap({ $0 }))
    }
    
    @discardableResult
    func drop(_ options: [StashOptions.DropSet] = [], stash: String? = nil) async throws -> String {
        try await repository.run(["stash", "drop"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }))
    }
    
    @discardableResult
    func pop(_ options: [StashOptions.PopSet] = [], stash: String? = nil) async throws -> String {
        try await repository.run(["stash", "pop"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }))
    }
    
    @discardableResult
    func apply(_ options: [StashOptions.PopSet] = [], stash: String? = nil) async throws -> String {
        try await repository.run(["stash", "apply"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }))
    }
    
    @discardableResult
    func branch(_ branchname: String, stash: String? = nil) async throws -> String {
        try await repository.run(["stash", "branch", "branchname"] + [stash].compactMap({ $0 }))
    }
    
    @discardableResult
    func push(_ options: [StashOptions.PushSet] = [], pathspec: [Pathspec] = .all) async throws -> String {
        try await repository.run(["stash"] + options.map(\.options.rawValue) + pathspec.map(\.value))
    }
    
    @discardableResult
    func callAsFunction(_ options: [StashOptions.PushSet] = [], pathspec: [Pathspec] = .all) async throws -> String {
        try await repository.run(["stash"] + options.map(\.options.rawValue) + pathspec.map(\.value))
    }
    
    @discardableResult
    func clear() async throws -> String {
        try await repository.run(["stash", "clear"])
    }
    
    @discardableResult
    func create(_ message: String) async throws -> String {
        try await repository.run(["stash", "create", message])
    }
    
    @discardableResult
    func store(_ options: [StashOptions.StoreSet] = [], commit: String) async throws -> String {
        try await repository.run(["stash", "store"] + options.map(\.options.rawValue) + [commit])
    }
    
    @discardableResult
    func save(message: String? = nil) async throws -> String {
        try await repository.run(["stash", "save"] + [message].compactMap({ $0 }))
    }
    
}

public extension Repository.Stash {
    
    @discardableResult
    func list(_ options: [LogOptions] = []) throws -> String {
        try repository.run(["stash", "list"] + options.map(\.rawValue))
    }
    
    @discardableResult
    func show(_ options: [StashOptions.ShowSet] = [], diff: [DiffOptions] = [], stash: String? = nil) throws -> String {
        try repository.run(["stash"] + options.map(\.options.rawValue) + diff.map(\.rawValue) + [stash].compactMap({ $0 }))
    }
    
    @discardableResult
    func drop(_ options: [StashOptions.DropSet] = [], stash: String? = nil) throws -> String {
        try repository.run(["stash", "drop"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }))
    }
    
    @discardableResult
    func pop(_ options: [StashOptions.PopSet] = [], stash: String? = nil) throws -> String {
        try repository.run(["stash", "pop"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }))
    }
    
    @discardableResult
    func apply(_ options: [StashOptions.PopSet] = [], stash: String? = nil) throws -> String {
        try repository.run(["stash", "apply"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }))
    }
    
    @discardableResult
    func branch(_ branchname: String, stash: String? = nil) throws -> String {
        try repository.run(["stash", "branch", "branchname"] + [stash].compactMap({ $0 }))
    }
    
    @discardableResult
    func push(_ options: [StashOptions.PushSet] = [], pathspec: [Pathspec] = .all) throws -> String {
        try repository.run(["stash"] + options.map(\.options.rawValue) + pathspec.map(\.value))
    }
    
    @discardableResult
    func callAsFunction(_ options: [StashOptions.PushSet] = [], pathspec: [Pathspec] = .all) throws -> String {
        try repository.run(["stash"] + options.map(\.options.rawValue) + pathspec.map(\.value))
    }
    
    @discardableResult
    func clear() throws -> String {
        try repository.run(["stash", "clear"])
    }
    
    @discardableResult
    func create(_ message: String) throws -> String {
        try repository.run(["stash", "create", message])
    }
    
    @discardableResult
    func store(_ options: [StashOptions.StoreSet] = [], commit: String) throws -> String {
        try repository.run(["stash", "store"] + options.map(\.options.rawValue) + [commit])
    }
    
    @discardableResult
    func save(message: String? = nil) throws -> String {
        try repository.run(["stash", "save"] + [message].compactMap({ $0 }))
    }
    
}
