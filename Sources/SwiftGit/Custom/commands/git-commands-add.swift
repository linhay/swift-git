//
//  File.swift
//  
//
//  Created by linhey on 2022/5/10.
//

import Foundation
import Combine

public extension Repository {
    
    func addPublisher(_ options: [AddOptions], paths: [String]) -> AnyPublisher<String, GitError> {
        runPublisher(["add"] + options.map(\.rawValue) + ["--"] + paths)
    }
    
}

public extension Repository {
    
    @discardableResult
    func add(_ options: [AddOptions], paths: [String]) async throws -> String {
        try await run(["add"] + options.map(\.rawValue) + ["--"] + paths)
    }
    
}

public extension Repository {
    
    @discardableResult
    func add(_ options: [AddOptions], paths: [String]) throws -> String {
        try run(["add"] + options.map(\.rawValue) + ["--"] + paths)
    }
    
}
