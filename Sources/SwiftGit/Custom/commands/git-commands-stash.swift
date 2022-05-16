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
        public func list(_ options: [LogOptions] = []) throws -> String {
            try repository.run(["list"] + options.map(\.rawValue), executable: .stash)
        }
        
        @discardableResult
        public func show(_ options: [StashOptions.ShowSet] = [], diff: [DiffOptions] = [], stash: String? = nil) throws -> String {
            try repository.run(options.map(\.options.rawValue) + diff.map(\.rawValue) + [stash].compactMap({ $0 }), executable: .stash)
        }
        
        @discardableResult
        public func drop(_ options: [StashOptions.DropSet] = [], stash: String? = nil) throws -> String {
            try repository.run(["drop"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }), executable: .stash)
        }
        
        @discardableResult
        public func pop(_ options: [StashOptions.PopSet] = [], stash: String? = nil) throws -> String {
            try repository.run(["pop"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }), executable: .stash)
        }
        
        @discardableResult
        public func apply(_ options: [StashOptions.PopSet] = [], stash: String? = nil) throws -> String {
            try repository.run(["apply"] + options.map(\.options.rawValue) + [stash].compactMap({ $0 }), executable: .stash)
        }
        
        @discardableResult
        public func branch(_ branchname: String, stash: String? = nil) throws -> String {
            try repository.run(["branch", "branchname"] + [stash].compactMap({ $0 }), executable: .stash)
        }
        
        @discardableResult
        public func push(_ options: [StashOptions.PushSet] = [], pathspec: [Pathspec] = .all) throws -> String {
            try repository.run(options.map(\.options.rawValue) + pathspec.map(\.value), executable: .stash)
        }
        
        @discardableResult
        public func callAsFunction(_ options: [StashOptions.PushSet] = [], pathspec: [Pathspec] = .all) throws -> String {
            try repository.run(options.map(\.options.rawValue) + pathspec.map(\.value), executable: .stash)
        }
        
        @discardableResult
        public func clear() throws -> String {
            try repository.run(["clear"], executable: .stash)
        }
        
        @discardableResult
        public func create(_ message: String) throws -> String {
            try repository.run(["create", message], executable: .stash)
        }
        
        @discardableResult
        public func store(_ options: [StashOptions.StoreSet] = [], commit: String) throws -> String {
            try repository.run(["store"] + options.map(\.options.rawValue) + [commit], executable: .stash)
        }
        
        @discardableResult
        public func save(message: String? = nil) throws -> String {
            try repository.run(["save"] + [message].compactMap({ $0 }), executable: .stash)
        }
                
    }
    
    var stash: Stash { .init(repository: self) }
    
    @discardableResult
    func stash(_ cmd: String) throws -> String {
        try run(cmd.split(separator: " ").map(\.description), executable: .stash)
    }
    
}
