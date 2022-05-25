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
        try run(["show"] + options.map(\.rawValue) + objects)
    }
    
    @discardableResult
    func show(_ cmd: String) throws -> String {
        try run(["show"] + cmd.split(separator: " ").map(\.description))
    }
    
    @discardableResult
    func show(_ options: [ShowOptions] = [], objects: [String] = []) throws -> Data {
        try data(["show"] + options.map(\.rawValue) + objects)
    }
    
    @discardableResult
    func show(data cmd: String) throws -> Data {
        try data("show " + cmd)
    }
    
}
