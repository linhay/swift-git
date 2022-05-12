//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation

public extension Repository {
        
    /// https://git-scm.com/docs/git-fetch
    func fetch(_ options: [FetchOptions] = [], refspecs: [Reference] = []) throws  -> String {
        try run(options.map(\.rawValue) + refspecs.map(\.name), executable: .fetch)
    }
    
    @discardableResult
    func fetch(_ cmd: String) throws -> String {
        try run(cmd.split(separator: " ").map(\.description), executable: .fetch)
    }
    
}
