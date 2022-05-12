//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation

public extension Repository {
    
    private var executableURL: URL? { Git.bundle.url(forAuxiliaryExecutable: "libexec/git-core/git-fetch") }
    
    /// https://git-scm.com/docs/git-fetch
    func fetch(_ options: [FetchOptions] = [], refspecs: [Reference] = []) throws  -> String {
        try Git.run(options.map(\.rawValue)
                    + refspecs.map(\.name),
                    executableURL: executableURL,
                    currentDirectoryURL: localURL)
    }
    
    @discardableResult
    func fetch(_ cmd: String) throws -> String {
        try Git.run(cmd.split(separator: " ").map(\.description),
                    executableURL: executableURL,
                    currentDirectoryURL: localURL)
    }
    
}
