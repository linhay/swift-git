//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation

public struct Git {
    
    static let bundle = Bundle(url: Bundle.module.url(forAuxiliaryExecutable: "Contents/Resources/git-instance.bundle")!)!

    
    enum Executable: String {
        
        case git = ""
        case show
        case fetch
        case commit
        case status
        case push
        case reset
        case clone
        case log
        case add
        case `init`
        
        var url: URL {
            return bundle.url(forAuxiliaryExecutable: "libexec/git-core/git\(rawValue.isEmpty ? "" : "-\(rawValue)")")!
        }
    }
    
    @discardableResult
    static func run(_ options: [GitOptions]) throws -> String {
        try run(options.map(\.rawValue))
    }
    
    @discardableResult
    static func data(_ commands: [String],
                     executable: Executable = .git,
                     currentDirectoryURL: URL? = nil,
                     processBuilder: ((_ process: Process) -> Void)? = nil) throws -> Data {
        let process = Process()
        process.executableURL = executable.url
        process.arguments = commands
        process.currentDirectoryURL = currentDirectoryURL
        processBuilder?(process)
        
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        return pipe.fileHandleForReading.readDataToEndOfFile()
    }
    
    @discardableResult
    static func run(_ commands: [String],
                    executable: Executable = .git,
                    currentDirectoryURL: URL? = nil,
                    processBuilder: ((_ process: Process) -> Void)? = nil) throws -> String {
        let data = try data(commands,
                            executable: executable,
                            currentDirectoryURL: currentDirectoryURL,
                            processBuilder: processBuilder)
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
