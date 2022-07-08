//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import Foundation
import Combine

public extension Git {
    
    @discardableResult
    func initPublisher(_ options: [InitOptions] = [], directory: String) -> AnyPublisher<String, GitError> {
        runPublisher(["init"] + options.map(\.rawValue) + [directory])
    }
    
}

public extension Git {
    
    @discardableResult
    func `init`(_ options: [InitOptions] = [], directory: String) async throws -> String {
        try await run(["init"] + options.map(\.rawValue) + [directory])
    }
    
}

public extension Git {
    
    @discardableResult
    func `init`(_ options: [InitOptions] = [], directory: String) throws -> String {
        try run(["init"] + options.map(\.rawValue) + [directory])
    }
    
}
