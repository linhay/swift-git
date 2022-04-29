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

    func run(_ command: String) throws -> String {
        let process = Process()
         process.executableURL = Bundle.module.url(forAuxiliaryExecutable: "Contents/Resources/git")
         process.currentDirectoryURL = localURL
         process.arguments = ["log"]

         let pipe = Pipe()
         process.standardOutput = pipe
         try process.run()
         process.waitUntilExit()
         let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }
    
}
