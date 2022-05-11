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
    
    /// https://git-scm.com/docs/git-reset/zh_HANS-CN
    func reset(_ options: [ResetOptions], paths: [Pathspec]) throws {
        try Git.run(["reset"]
                    + options.map(\.rawValue)
                    + ["--"]
                    + paths.map(\.value),
                    currentDirectoryURL: localURL)
    }
    
    func reset(_ options: [ResetOptions], treeIsh: TreeIsh) throws {
        try Git.run(["reset"]
                    + options.map(\.rawValue)
                    + [treeIsh.value],
                    currentDirectoryURL: localURL)
    }
    
    func reset(_ options: [ResetOptions], commit: Commit) throws {
        try Git.run(["reset"]
                    + options.map(\.rawValue)
                    + [commit.name],
                    currentDirectoryURL: localURL)
    }
    
}
