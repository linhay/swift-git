//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation

public extension Repository {
    
    /// https://git-scm.com/docs/git-fetch
    func fetch(_ options: [FetchOptions] = [], refspecs: [Reference] = []) throws {
        try Git.run(["fetch"]
                    + options.map(\.rawValue)
                    + refspecs.map(\.name),
                    executableURL: Git.bundle.url(forAuxiliaryExecutable: "libexec/git-core/git-fetch"),
                    currentDirectoryURL: localURL)
    }
    
}
