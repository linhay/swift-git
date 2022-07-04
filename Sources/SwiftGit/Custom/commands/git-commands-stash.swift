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
        
        @discardableResult
        public func list(_ options: [LogOptions] = []) async throws -> String {
            try await repository.run(["stash", "list"] + options.map(\.rawValue))
        }
        
        @discardableResult
        public func show(_ options: [StashOptions.ShowSet] = [], diff: [DiffOptions] = [], stash: String? = nil) async throws -> String {
            try await repository.run(["stash"] + options.map(\.options.rawValue) + diff.map(\.rawValue) + [stash].compactMap({ $0 }))
        }
        
        @discardableResult
        public func drop(_ options: [StashOptions.DropSet] = [], stash: String? = nil) async throws -> String {
            try await repository.run(["stash", "drop"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }))
        }
        
        @discardableResult
        public func pop(_ options: [StashOptions.PopSet] = [], stash: String? = nil) async throws -> String {
            try await repository.run(["stash", "pop"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }))
        }
        
        @discardableResult
        public func apply(_ options: [StashOptions.PopSet] = [], stash: String? = nil) async throws -> String {
            try await repository.run(["stash", "apply"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }))
        }
        
        @discardableResult
        public func branch(_ branchname: String, stash: String? = nil) async throws -> String {
            try await repository.run(["stash", "branch", "branchname"] + [stash].compactMap({ $0 }))
        }
        
        @discardableResult
        public func push(_ options: [StashOptions.PushSet] = [], pathspec: [Pathspec] = .all) async throws -> String {
            try await repository.run(["stash"] + options.map(\.options.rawValue) + pathspec.map(\.value))
        }
        
        @discardableResult
        public func callAsFunction(_ options: [StashOptions.PushSet] = [], pathspec: [Pathspec] = .all) async throws -> String {
            try await repository.run(["stash"] + options.map(\.options.rawValue) + pathspec.map(\.value))
        }
        
        @discardableResult
        public func clear() async throws -> String {
            try await repository.run(["stash", "clear"])
        }
        
        @discardableResult
        public func create(_ message: String) async throws -> String {
            try await repository.run(["stash", "create", message])
        }
        
        @discardableResult
        public func store(_ options: [StashOptions.StoreSet] = [], commit: String) async throws -> String {
            try await repository.run(["stash", "store"] + options.map(\.options.rawValue) + [commit])
        }
        
        @discardableResult
        public func save(message: String? = nil) async throws -> String {
            try await repository.run(["stash", "save"] + [message].compactMap({ $0 }))
        }
                
    }
    
    var stash: Stash { .init(repository: self) }
    
    @discardableResult
    func stash(_ cmd: String) async throws -> String {
        try await run("stash " + cmd)
    }
    
}
