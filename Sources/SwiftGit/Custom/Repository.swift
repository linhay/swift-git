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
    func data(_ commands: [String],
              executable: Git.Executable = .git,
              processBuilder: ((_ process: Process) -> Void)? = nil) throws -> Data {
        let process = Process()
        process.executableURL = executable.url
        process.arguments = commands
        process.currentDirectoryURL = localURL
        processBuilder?(process)
        
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        return pipe.fileHandleForReading.readDataToEndOfFile()
    }
    
    @discardableResult
    func run(_ commands: [String],
             executable: Git.Executable = .git,
             processBuilder: ((_ process: Process) -> Void)? = nil) throws -> String {
        let data = try data(commands,
                            executable: executable,
                            processBuilder: processBuilder)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
}
