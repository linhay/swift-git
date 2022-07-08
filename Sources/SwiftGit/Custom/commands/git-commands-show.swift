//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation
import Combine

public extension Repository {
        
    /// https://git-scm.com/docs/git-show
    func showPublisher(_ options: [ShowOptions] = [], objects: [String] = []) -> AnyPublisher<String, GitError> {
        runPublisher(["show"] + options.map(\.rawValue) + objects)
    }
    
    func showPublisher(_ cmd: String) -> AnyPublisher<String, GitError> {
        runPublisher(["show"] + cmd.split(separator: " ").map(\.description))
    }
    
    func showPublisher(_ options: [ShowOptions] = [], objects: [String] = []) -> AnyPublisher<Data, GitError> {
        dataPublisher(["show"] + options.map(\.rawValue) + objects)
    }
    
    func showPublisher(data cmd: String) -> AnyPublisher<Data, GitError> {
        dataPublisher("show " + cmd)
    }
    
}

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
