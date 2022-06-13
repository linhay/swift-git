//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation
import Logging

let logger = Logger(label: "com.SwiftGit")

public struct Git { }

public extension Git {
    
    struct Resource {
        static let bundle = Bundle(url: Bundle.module.url(forAuxiliaryExecutable: "Contents/Resources/git-instance.bundle")!)!
        
        static let executableURL = Resource.bundle.url(forAuxiliaryExecutable: "bin/git")!
        static let envExecPath = Resource.bundle.url(forAuxiliaryExecutable: "libexec/git-core")!.path
        static let templates = Resource.bundle.url(forAuxiliaryExecutable: "share/git-core/templates")!
    }
    
    @discardableResult
    static func run(_ options: [GitOptions]) throws -> String {
        try run(options.map(\.rawValue))
    }
    
    @discardableResult
    static func data(_ commands: [String],
                     env: [String: String]? = nil,
                     currentDirectoryURL: URL? = nil) throws -> Data {
        
        let process = Process()
        process.executableURL = Resource.executableURL
        process.arguments = commands
        process.currentDirectoryURL = currentDirectoryURL ?? URL(fileURLWithPath: NSHomeDirectory())
        
        var defaultEnv = [
            "GIT_CONFIG_NOSYSTEM": "true",
            "GIT_EXEC_PATH": Resource.envExecPath
        ]

        if let env = env {
            defaultEnv = env.merging(defaultEnv) { $1 }
        }

        process.environment = defaultEnv
        
        let outputPip = Pipe()
        let errorPip = Pipe()
        process.standardOutput = outputPip
        process.standardError = errorPip
        try process.run()
        process.waitUntilExit()
        
        if process.terminationStatus != .zero {
            if let message = String(data: errorPip.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) {
                throw GitError.processFatal(message)
            }
            
            var message = [String]()
            if let currentDirectory = process.currentDirectoryURL?.path {
                message.append("currentDirectory: \(currentDirectory)")
            }
            message.append("reason: \(process.terminationReason)")
            message.append("code: \(process.terminationReason.rawValue)")
            logger.error(.init(stringLiteral: log(commands: commands, result: message.joined(separator: "\n"))))
            throw GitError.processFatal(message.joined(separator: "\n"))
        }
        
        let data = outputPip.fileHandleForReading.readDataToEndOfFile()
        
        if let result = String(data: data, encoding: .utf8) {
            logger.info(.init(stringLiteral: log(commands: commands, result: result)))
        }
        
        return data
    }
    
    @discardableResult
    static func run(_ commands: [String], env: [String: String]? = nil, currentDirectoryURL: URL? = nil) throws -> String {
        let data = try data(commands,
                            env: env,
                            currentDirectoryURL: currentDirectoryURL)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    @discardableResult
    static func run(_ cmd: String, env: [String: String]? = nil, currentDirectoryURL: URL? = nil) throws -> String {
        try run(cmd.split(separator: " ").map(\.description), env: env, currentDirectoryURL: currentDirectoryURL)
    }
    
}

public extension Git {
    
    static func repository(at url: URL) throws -> Repository {
        try Repository(url: url)
    }
    
    static func repository(at path: String) throws -> Repository {
        try Repository(path: path)
    }
    
}

private extension Git {
    
    static func log(commands: [String], result: String) -> String {
        var dict: [String : String] = [:]
        dict["command"] = commands.joined(separator: " ")
        dict["result"] = result
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [.sortedKeys, .withoutEscapingSlashes])
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            debugPrint(error.localizedDescription)
            return ""
        }
    }
}
