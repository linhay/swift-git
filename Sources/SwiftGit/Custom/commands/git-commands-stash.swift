//
//  File.swift
//  
//
//  Created by linhey on 2022/5/16.
//

import Foundation

/// https://git-scm.com/docs/git-stash
public extension Repository {
        
    @discardableResult
    func stash(list options: [LogOptions]) throws -> String {
        try Git.run(["list"] + options.map(\.rawValue), executable: .stash)
    }
    
    @discardableResult
    func stash(show options: [StashOptions.ShowSet], diff: [DiffOptions], stash: String) throws -> String {
        try Git.run(options.map(\.options.rawValue) + diff.map(\.rawValue) + [stash], executable: .stash)
    }
    
    @discardableResult
    func stash(drop options: [StashOptions.DropSet], stash: String) throws -> String {
        try Git.run(["drop"] + options.map(\.options.rawValue) + [stash], executable: .stash)
    }
    
    @discardableResult
    func stash(pop options: [StashOptions.PopSet], stash: String) throws -> String {
        try Git.run(["pop"] + options.map(\.options.rawValue) + [stash], executable: .stash)
    }
    
    @discardableResult
    func stash(apply options: [StashOptions.PopSet], stash: String) throws -> String {
        try Git.run(["apply"] + options.map(\.options.rawValue) + [stash], executable: .stash)
    }
    
    @discardableResult
    func stash(branch branchname: String, stash: String) throws -> String {
        try Git.run(["branch", "branchname"] + [stash], executable: .stash)
    }
    
    @discardableResult
    func stash(_ options: [StashOptions.PushSet] = [], pathspec: [Pathspec] = .all) throws -> String {
        try Git.run(options.map(\.options.rawValue) + pathspec.map(\.value), executable: .stash)
    }
    
    @discardableResult
    func clear() throws -> String {
        try Git.run(["clear"], executable: .stash)
    }
    
    @discardableResult
    func create(_ message: String) throws -> String {
        try Git.run(["create", message], executable: .stash)
    }
    
    @discardableResult
    func store(_ options: [StashOptions.StoreSet], commit: String) throws -> String {
        try Git.run(["store"] + options.map(\.options.rawValue) + [commit], executable: .stash)
    }
    
    @discardableResult
    func stash(_ cmd: String) throws -> String {
        try Git.run(cmd.split(separator: " ").map(\.description), executable: .stash)
    }
    
}
