//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation
import Combine

public extension Repository {
    
    /// https://git-scm.com/docs/git-fetch
    @discardableResult
    func fetchPublisher(_ options: [FetchOptions] = [], refspecs: [Reference] = []) -> AnyPublisher<String, Error> {
        runPublisher(["fetch"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func fetchPublisher(_ cmd: String) -> AnyPublisher<String, Error> {
        runPublisher("fetch " + cmd)
    }
    
}

public extension Repository {
    
    /// https://git-scm.com/docs/git-fetch
    @discardableResult
    func fetch(_ options: [FetchOptions] = [], refspecs: [Reference] = []) async throws -> String {
        try await run(["fetch"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func fetch(_ cmd: String) async throws -> String {
        try await run("fetch " + cmd)
    }
    
}

public extension Repository {
    
    /// https://git-scm.com/docs/git-fetch
    @discardableResult
    func fetch(_ options: [FetchOptions] = [], refspecs: [Reference] = []) throws -> String {
        try run(["fetch"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func fetch(_ cmd: String) throws -> String {
        try run("fetch " + cmd)
    }
    
}
