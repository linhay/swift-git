//
//  File.swift
//  
//
//  Created by linhey on 2022/5/10.
//

import Foundation

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
    
    /// https://git-scm.com/docs/git-reset
    @discardableResult
    func reset(_ options: [ResetOptions] = [], paths: [Pathspec]) throws -> String {
        try Git.run(options.map(\.rawValue) + ["--"] + paths.map(\.value), executable: .reset)
    }
    
    @discardableResult
    func reset(_ options: [ResetOptions] = [], treeIsh: TreeIsh) throws -> String {
        try Git.run(options.map(\.rawValue) + [treeIsh.value], executable: .reset)
    }
    
    @discardableResult
    func reset(_ options: [ResetOptions] = [], commit: Commit) throws -> String {
        try Git.run(options.map(\.rawValue) + [commit.name], executable: .reset)
    }
    
    @discardableResult
    func reset(_ cmd: String) throws -> String {
        try run(cmd.split(separator: " ").map(\.description), executable: .reset)
    }
    
}
