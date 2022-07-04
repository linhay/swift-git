//
//  File.swift
//  
//
//  Created by linhey on 2022/5/16.
//

import Foundation

/// https://git-scm.com/docs/git-stash
public extension Repository {
    
    struct Stash {
        
        let repository: Repository
    
    }
    
    var stash: Stash { .init(repository: self) }
    
    @discardableResult
    func stash(_ cmd: String) async throws -> String {
        try await run("stash " + cmd)
    }
    
    @discardableResult
    func stash(_ cmd: String) throws -> String {
        try run("stash " + cmd)
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
