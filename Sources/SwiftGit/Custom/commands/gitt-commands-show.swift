//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation

public extension Repository {
        
    /// https://git-scm.com/docs/git-show
    @discardableResult
    func show(_ options: [ShowOptions] = [], objects: [String] = []) throws -> String {
        try run(options.map(\.rawValue) + objects, executable: .show)
    }
    
    @discardableResult
    func show(_ cmd: String) throws -> String {
        try run(cmd.split(separator: " ").map(\.description), executable: .show)
    }
    
    @discardableResult
    func show(_ options: [ShowOptions] = [], objects: [String] = []) throws -> Data {
        try data(options.map(\.rawValue) + objects, executable: .show)
    }
    
    @discardableResult
    func show(data cmd: String) throws -> Data {
        try data(cmd.split(separator: " ").map(\.description), executable: .show)
    }
    
}
