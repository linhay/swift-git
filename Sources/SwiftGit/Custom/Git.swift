//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation

public struct Git {

   public static let bundle = Bundle(url: Bundle.module.url(forAuxiliaryExecutable: "Contents/Resources/git-instance.bundle")!)!
                   
    @discardableResult
    static func run(_ options: [GitOptions]) throws -> String {
        try run(options.map(\.rawValue))
    }
    
    @discardableResult
    static func run(_ commands: [String],
                    executableURL: URL? = bundle.url(forAuxiliaryExecutable: "bin/git"),
                    currentDirectoryURL: URL? = nil,
                    processBuilder: ((_ process: Process) -> Void)? = nil) throws -> String {
        let process = Process()        
        process.executableURL = executableURL
        process.arguments = commands
        process.currentDirectoryURL = currentDirectoryURL
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
