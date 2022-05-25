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
