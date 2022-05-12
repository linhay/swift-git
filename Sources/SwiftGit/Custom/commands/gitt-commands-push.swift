//
//  File.swift
//  
//
//  Created by linhey on 2022/5/11.
//

import Foundation

public extension Repository {
    
    private var executableURL: URL? { Git.bundle.url(forAuxiliaryExecutable: "libexec/git-core/git-push") }
    
    /// https://git-scm.com/docs/git-push
    func push(_ options: [PushOptions] = [], refspecs: [Reference] = []) throws {
        try Git.run(options.map(\.rawValue)
                    + refspecs.map(\.name),
                    executableURL: executableURL,
                    currentDirectoryURL: localURL)
    }
    
    @discardableResult
    func push(_ cmd: String) throws -> String {
        try Git.run(cmd.split(separator: " ").map(\.description),
                    executableURL: executableURL,
                    currentDirectoryURL: localURL)
    }
    
}
