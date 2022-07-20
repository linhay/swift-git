//
//  File.swift
//  
//
//  Created by linhey on 2022/7/11.
//

import Foundation
import Combine

/// https://git-scm.com/docs/git-ls-tree
public extension Repository {
    
    func lsTreePublisher(_ cmd: String) -> AnyPublisher<String, GitError> {
        runPublisher("ls-tree " + cmd)
    }
    
}

public extension Repository {
    
    @discardableResult
    func lsTree(_ cmd: String) async throws -> String {
        try await run("ls-tree " + cmd)
    }
    
}

public extension Repository {
    
    @discardableResult
    func lsTree(_ cmd: String) throws -> String {
        try run("ls-tree " + cmd)
    }
    
}

public struct LsTreeOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension LsTreeOptions {
    
    /// only show trees
    static var d: LsTreeOptions { .init("-d") }
    /// recurse into subtrees
    static var r: LsTreeOptions { .init("-r") }
    /// show trees when recursing
    static var t: LsTreeOptions { .init("-t") }
    /// terminate entries with NUL byte
    static var z: LsTreeOptions { .init("-z") }
    /// include object size
    static var long: LsTreeOptions { .init("--long") }
    /// list only filenames
    static var nameOnly: LsTreeOptions { .init("--name-only") }
    /// list only filenames
    static var nameStatus: LsTreeOptions { .init("--name-status") }
    /// use full path names
    static var fullName: LsTreeOptions { .init("--full-name") }
    /// list entire tree; not just current directory (implies --full-name)
    static var fullTree: LsTreeOptions { .init("--full-tree") }
    /// use <n> digits to display object names
    static func abbrev(_ n: Int) -> LsTreeOptions { .init("--abbrev=\(n)") }
    
}
