//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation
import Combine

/// https://git-scm.com/docs/git-log
public extension Repository {
    
    func logPublisher(options: [LogOptions] = []) -> AnyPublisher<[LogResult], Error> {
        logPublisher(options + [.pretty(.fuller)])
            .map(logResults(from:))
            .eraseToAnyPublisher()
    }
    
    func logPublisher(_ options: [LogOptions] = [], refspecs: [Reference] = []) -> AnyPublisher<String, Error> {
        runPublisher(["log"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    func logPublisher(_ cmd: String) -> AnyPublisher<String, Error> {
        runPublisher("log " + cmd)
    }
    
}

public extension Repository {
    
    func log(options: [LogOptions] = []) async throws -> [LogResult] {
        let str = try await log(options + [.pretty(.fuller)])
        return logResults(from: str)
    }
    
    /// https://git-scm.com/docs/git-log
    func log(_ options: [LogOptions] = [], refspecs: [Reference] = []) async throws -> String {
        try await run(["log"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func log(_ cmd: String) async throws -> String {
        try await run("log " + cmd)
    }
    
}

public extension Repository {
    
    func log(options: [LogOptions] = []) throws -> [LogResult] {
        let str = try log(options + [.pretty(.fuller)])
        return logResults(from: str)
    }
    
    /// https://git-scm.com/docs/git-log
    func log(_ options: [LogOptions] = [], refspecs: [Reference] = []) throws -> String {
        try run(["log"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func log(_ cmd: String) throws -> String {
        try run("log " + cmd)
    }
    
}

public extension LogOptions {
    
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
    
    
    static func pretty(_ format: Format) -> LogOptions { .init("--pretty=\(format)") }
    static func format(_ format: Format) -> LogOptions { .init("--format=\(format)") }
    static func limit(_ number: Int) -> LogOptions { .init("-\(number)") }
    
}
