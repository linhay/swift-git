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
    
    func tagPublisher(_ options: [TagOptions] = [], tagname: String? = nil) -> AnyPublisher<String, GitError> {
        runPublisher(["tag"] + options.map(\.rawValue) + (tagname == nil ? [] : [tagname!]))
    }
    
    func tagPublisher(_ cmd: String) -> AnyPublisher<String, GitError> {
        runPublisher("tag " + cmd)
    }
}

public extension Repository {
    
    @discardableResult
    func tag(_ options: [TagOptions] = [], tagname: String? = nil) async throws -> String {
        try await run(["tag"] + options.map(\.rawValue) + (tagname == nil ? [] : [tagname!]))
    }
    
    @discardableResult
    func tag(_ cmd: String) async throws -> String {
        try await run("tag " + cmd)
    }
}

public extension Repository {
    
    @discardableResult
    func tag(_ options: [TagOptions] = [], tagname: String? = nil) throws -> String {
        try run(["tag"] + options.map(\.rawValue) + (tagname == nil ? [] : [tagname!]))
    }
    
    @discardableResult
    func tag(_ cmd: String) throws -> String {
        try run("tag " + cmd)
    }
    
}
