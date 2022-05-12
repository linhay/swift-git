//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation

public extension Repository {
    
    private var executableURL: URL? { Git.bundle.url(forAuxiliaryExecutable: "libexec/git-core/git-commit") }
    
    /// https://git-scm.com/docs/git-commit
    func commit(_ options: [CommitOptions] = [], pathspecs: [Pathspec] = []) throws  -> String {
        try Git.run(options.map(\.rawValue)
                    + pathspecs.map(\.value),
                    executableURL: executableURL,
                    currentDirectoryURL: localURL)
    }
    
    @discardableResult
    func commit(_ cmd: String) throws -> String {
        try Git.run(cmd.split(separator: " ").map(\.description),
                    executableURL: executableURL,
                    currentDirectoryURL: localURL)
    }
    
}
