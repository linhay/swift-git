//
//  File.swift
//  
//
//  Created by linhey on 2022/5/16.
//

import Foundation
import Combine

public extension Repository {
    
    /// https://git-scm.com/docs/git-pull
    func pullPublisher(_ options: [PullOptions] = [], refspecs: [Reference]) -> AnyPublisher<String, Error> {
        runPublisher(["pull"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    func pullPublisher(_ options: [PullOptions] = []) -> AnyPublisher<String, Error> {
        runPublisher(["pull"] + options.map(\.rawValue))
    }
    
    func pullPublisher(_ cmd: String) -> AnyPublisher<String, Error> {
        runPublisher("pull " + cmd)
    }
    
}

public extension Repository {
    
    /// https://git-scm.com/docs/git-pull
    @discardableResult
    func pull(_ options: [PullOptions] = [], refspecs: [Reference]) async throws -> String {
        try await run(["pull"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func pull(_ options: [PullOptions] = []) async throws -> String {
        try await run(["pull"] + options.map(\.rawValue))
    }
    
    @discardableResult
    func pull(_ cmd: String) async throws -> String {
        try await run("pull " + cmd)
    }
    
}

public extension Repository {
    
    /// https://git-scm.com/docs/git-pull
    @discardableResult
    func pull(_ options: [PullOptions] = [], refspecs: [Reference]) throws -> String {
        try run(["pull"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func pull(_ options: [PullOptions] = []) throws -> String {
        try run(["pull"] + options.map(\.rawValue))
    }
    
    @discardableResult
    func pull(_ cmd: String) throws -> String {
        try run("pull " + cmd)
    }
    
}
