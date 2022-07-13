//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation
import Combine

/// https://git-scm.com/docs/git-show
public extension Repository {
    
    func showPublisher(commit ID: String) -> AnyPublisher<ShowCommitResult, GitError> {
        showPublisher([.pretty(.fuller)], objects: [ID])
            .map(showCommitResult(from:))
            .eraseToAnyPublisher()
    }
    
    func showPublisher(_ options: [ShowOptions] = [], objects: [String] = []) -> AnyPublisher<String, GitError> {
        runPublisher(["show"] + options.map(\.rawValue) + objects)
    }
    
    func showPublisher(_ options: [ShowOptions] = [], objects: [String] = []) -> AnyPublisher<Data, GitError> {
        dataPublisher(["show"] + options.map(\.rawValue) + objects)
    }
    
    func showPublisher(_ cmd: String) -> AnyPublisher<String, GitError> {
        runPublisher(["show"] + cmd.split(separator: " ").map(\.description))
    }
    
    func showPublisher(data cmd: String) -> AnyPublisher<Data, GitError> {
        dataPublisher("show " + cmd)
    }
    
}

/// https://git-scm.com/docs/git-show
public extension Repository {
    
    @discardableResult
    func show(commit ID: String) async throws -> ShowCommitResult {
        showCommitResult(from: try await self.show([.pretty(.fuller)], objects: [ID]))
    }
    
    @discardableResult
    func show(_ options: [ShowOptions] = [], objects: [String] = []) async throws -> String {
        try await run(["show"] + options.map(\.rawValue) + objects)
    }
    
    @discardableResult
    func show(data options: [ShowOptions] = [], objects: [String] = []) async throws -> Data {
        try await data(["show"] + options.map(\.rawValue) + objects)
    }
    
    @discardableResult
    func show(_ cmd: String) async throws -> String {
        try await run(["show"] + cmd.split(separator: " ").map(\.description))
    }
    
    @discardableResult
    func show(data cmd: String) async throws -> Data {
        try await data("show " + cmd)
    }
    
}

/// https://git-scm.com/docs/git-show
public extension Repository {
    
    @discardableResult
    func show(commit ID: String) throws -> ShowCommitResult {
        showCommitResult(from: try self.show([.pretty(.fuller)], objects: [ID]))
    }
    
    @discardableResult
    func show(_ options: [ShowOptions] = [], objects: [String] = []) throws -> String {
        try run(["show"] + options.map(\.rawValue) + objects)
    }
    
    @discardableResult
    func show(data options: [ShowOptions] = [], objects: [String] = []) throws -> Data {
        try data(["show"] + options.map(\.rawValue) + objects)
    }
    
    @discardableResult
    func show(_ cmd: String) throws -> String {
        try run(["show"] + cmd.split(separator: " ").map(\.description))
    }
    
    @discardableResult
    func show(data cmd: String) throws -> Data {
        try data("show " + cmd)
    }
    
}

public extension ShowOptions {
    
    enum Format {
        case oneline
        case short
        case medium
        case full
        case fuller
        case reference
        case email
        case raw
        case format(String)
        case tformat(String)
        
        var name: String {
            switch self {
            case .oneline:
                return "oneline"
            case .short:
                return "short"
            case .medium:
                return "medium"
            case .full:
                return "full"
            case .fuller:
                return "fuller"
            case .reference:
                return "reference"
            case .email:
                return "email"
            case .raw:
                return "raw"
            case .format(let string):
                return "format:\(string)"
            case .tformat(let string):
                return "tformat:\(string)"
            }
        }
    }
    
    
    static func pretty(_ format: Format) -> ShowOptions { .init("--pretty=\(format)") }
    static func format(_ format: Format) -> ShowOptions { .init("--format=\(format)") }
    static func limit(_ number: Int) -> ShowOptions { .init("-\(number)") }
    
}
