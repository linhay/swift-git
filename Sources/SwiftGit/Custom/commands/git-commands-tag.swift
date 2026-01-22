//
//  File.swift
//  
//
//  Created by linhey on 2022/7/24.
//

import Foundation
import Combine

/// https://git-scm.com/docs/git-tag
public extension Repository {
    
    func tagPublisher(_ options: [TagOptions] = [], tagname: String? = nil) -> AnyPublisher<String, Error> {
        let args = ["tag"] + options.map(\.rawValue) + (tagname.map { [$0] } ?? [])
        return runPublisher(args)
    }
    
    func tagPublisher(_ cmd: String) -> AnyPublisher<String, Error> {
        runPublisher("tag " + cmd)
    }
}

public extension Repository {
    
    @discardableResult
    func tag(_ options: [TagOptions] = [], tagname: String? = nil) async throws -> String {
        let args = ["tag"] + options.map(\.rawValue) + (tagname.map { [$0] } ?? [])
        return try await run(args)
    }
    
    @discardableResult
    func tag(_ cmd: String) async throws -> String {
        try await run("tag " + cmd)
    }
}

public extension Repository {
    
    @discardableResult
    func tag(_ options: [TagOptions] = [], tagname: String? = nil) throws -> String {
        let args = ["tag"] + options.map(\.rawValue) + (tagname.map { [$0] } ?? [])
        return try run(args)
    }
    
    @discardableResult
    func tag(_ cmd: String) throws -> String {
        try run("tag " + cmd)
    }
    
}
