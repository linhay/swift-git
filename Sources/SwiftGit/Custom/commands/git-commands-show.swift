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
    func show(_ options: [ShowOptions] = [], objects: [String] = []) async throws -> String {
        try await run(["show"] + options.map(\.rawValue) + objects)
    }
    
    @discardableResult
    func show(_ cmd: String) async throws -> String {
        try await run(["show"] + cmd.split(separator: " ").map(\.description))
    }
    
    @discardableResult
    func show(_ options: [ShowOptions] = [], objects: [String] = []) async throws -> Data {
        try await data(["show"] + options.map(\.rawValue) + objects)
    }
    
    @discardableResult
    func show(data cmd: String) async throws -> Data {
        try await data("show " + cmd)
    }
    
}
