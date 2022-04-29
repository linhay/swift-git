//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation

public struct Git {
    

    
}

public extension Git {
    
    static func create(at url: URL) throws -> Repository {
        try Repository.init(url: url)
    }
    
    static func create(at path: String) throws -> Repository {
        try Repository.init(path: path)
    }
    
    /// https://git-scm.com/docs/git-clone
//    static func clone(url: String, options: [CloneOptions] = [], to dir: String? = nil) throws -> Repository {
//
//    }
    
}
