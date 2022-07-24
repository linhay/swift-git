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
    
    func tagPublisher(_ cmd: String) -> AnyPublisher<String, GitError> {
        runPublisher("tag " + cmd)
    }
    
}

public extension Repository {
    
    @discardableResult
    func tag(_ cmd: String) async throws -> String {
        try await run("tag " + cmd)
    }
    
}

public extension Repository {
    
    @discardableResult
    func tag(_ cmd: String) throws -> String {
        try run("tag " + cmd)
    }
    
}
