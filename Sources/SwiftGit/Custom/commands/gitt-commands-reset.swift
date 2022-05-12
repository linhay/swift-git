//
//  File.swift
//  
//
//  Created by linhey on 2022/5/10.
//

import Foundation

public extension Repository {
    
    private var executableURL: URL? { Git.bundle.url(forAuxiliaryExecutable: "libexec/git-core/git-reset") }
    
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
    func reset(_ options: [ResetOptions], paths: [Pathspec]) throws -> String {
        try Git.run(options.map(\.rawValue)
                    + ["--"]
                    + paths.map(\.value),
                    executableURL: executableURL,
                    currentDirectoryURL: localURL)
    }
    
    @discardableResult
    func reset(_ options: [ResetOptions], treeIsh: TreeIsh) throws -> String {
        try Git.run(options.map(\.rawValue)
                    + [treeIsh.value],
                    executableURL: executableURL,
                    currentDirectoryURL: localURL)
    }
    
    @discardableResult
    func reset(_ options: [ResetOptions], commit: Commit) throws -> String {
        try Git.run(options.map(\.rawValue)
                    + [commit.name],
                    executableURL: executableURL,
                    currentDirectoryURL: localURL)
    }
    
    @discardableResult
    func reset(_ cmd: String) throws -> String {
        try Git.run(cmd.split(separator: " ").map(\.description),
                    executableURL: executableURL,
                    currentDirectoryURL: localURL)
    }
    
}
