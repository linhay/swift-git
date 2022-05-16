//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation

public extension Repository {
    
    /// https://git-scm.com/docs/git-commit
    func commit(_ options: [CommitOptions] = [], pathspecs: [Pathspec] = []) throws  -> String {
        try run(options.map(\.rawValue) + pathspecs.map(\.value), executable: .commit)
    }
    
    @discardableResult
    func commit(_ cmd: String) throws -> String {
        try run(cmd, executable: .commit)
    }
    
}
