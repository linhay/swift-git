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
    func _run(_ commands: [String]) throws -> Data {
        let process = Process()
        process.executableURL = Bundle.module.url(forAuxiliaryExecutable: "Contents/Resources/git")
        process.currentDirectoryURL = localURL
        process.arguments = commands
        
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        return pipe.fileHandleForReading.readDataToEndOfFile()
    }
    
    @discardableResult
    func _run(_ commands: String) throws -> Data {
        return try _run(commands.split(separator: " ").map(String.init))
    }
    
    @discardableResult
    func run(_ commands: [String]) throws -> String {
        let data = try _run(commands)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    @discardableResult
    func run(_ commands: String) throws -> String {
        return try run(commands.split(separator: " ").map(String.init))
    }
    
}
