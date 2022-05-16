//
//  File.swift
//  
//
//  Created by linhey on 2022/5/16.
//

import Foundation


public extension Repository {
        
    /// https://git-scm.com/docs/git-pull
    @discardableResult
    func pull(_ options: [PullOptions] = [], refspecs: [Reference]) throws -> String {
        try run(options.map(\.rawValue) + refspecs.map(\.name), executable: .pull)
    }
    
    @discardableResult
    func pull(_ options: [PullOptions] = []) throws -> String {
        try run(options.map(\.rawValue), executable: .pull)
    }
    
    @discardableResult
    func pull(_ cmd: String) throws -> String {
        try run(cmd, executable: .pull)
    }
    
}
