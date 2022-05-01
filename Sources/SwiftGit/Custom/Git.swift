//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation

public struct Git {
    
    static func run(_ commands: [String], processBuilder: ((_ process: Process) -> Void)? = nil) throws -> String {
        let process = Process()
        process.executableURL = Bundle.module.url(forAuxiliaryExecutable: "Contents/Resources/git")
        process.arguments = commands
        processBuilder?(process)
        
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }
    
}

public extension Git {
    
    static func create(at url: URL) throws -> Repository {
        try Repository.init(url: url)
    }
    
    static func create(at path: String) throws -> Repository {
        try Repository.init(path: path)
    }
    
}
