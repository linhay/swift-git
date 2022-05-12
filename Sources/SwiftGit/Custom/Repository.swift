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
    
    @discardableResult
    func data(_ commands: [String], executable: Git.Executable = .git) throws -> Data {
       try Git.data(commands, executable: executable, currentDirectoryURL: localURL)
    }
    
    @discardableResult
    func run(_ commands: [String], executable: Git.Executable = .git) throws -> String {
        try Git.run(commands, executable: executable, currentDirectoryURL: localURL)
    }
    
}
