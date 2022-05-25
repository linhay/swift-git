//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation

public struct Repository {
    
    public let localURL: URL
    
    public init(url: URL) throws {
        self.localURL = url
    }
    
    public init(path: String) throws {
        self.localURL = .init(fileURLWithPath: path)
    }
}

public extension Repository {
    
    @discardableResult
    func data(_ commands: [String]) throws -> Data {
       try Git.data(commands, currentDirectoryURL: localURL)
    }
    
    @discardableResult
    func run(_ commands: [String]) throws -> String {
        try Git.run(commands, currentDirectoryURL: localURL)
    }
    
    @discardableResult
    func data(_ cmd: String) throws -> Data {
       try data(cmd.split(separator: " ").map(\.description))
    }
    
    @discardableResult
    func run(_ cmd: String) throws -> String {
        try run(cmd.split(separator: " ").map(\.description))
    }
    
}
