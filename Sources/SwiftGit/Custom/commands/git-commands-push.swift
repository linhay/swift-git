//
//  File.swift
//  
//
//  Created by linhey on 2022/5/11.
//

import Foundation

public extension Repository {
        
    /// https://git-scm.com/docs/git-push
    @discardableResult
    func push(_ options: [PushOptions] = [], refspecs: [Reference] = []) throws -> String {
        try run(["push"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func push(_ cmd: String) throws -> String {
        try run(["push"] + cmd.split(separator: " ").map(\.description))
    }
    
}
