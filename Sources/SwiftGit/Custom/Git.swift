//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation

public struct Git { }

public extension Git {
    
    struct Resource {
        static let bundle = Bundle(url: Bundle.module.url(forAuxiliaryExecutable: "Contents/Resources/git-instance.bundle")!)!
        
        public let url: URL
        
        public init(_ pathInBundle: String) {
            self.url = Resource.bundle.url(forAuxiliaryExecutable: pathInBundle)!
        }
    }
    
    @discardableResult
    static func run(_ options: [GitOptions]) throws -> String {
        try run(options.map(\.rawValue))
    }
    
    @discardableResult
    static func data(_ commands: [String],
                     executable: Resource = .git,
                     currentDirectoryURL: URL? = nil) throws -> Data {
        
        let process = Process()
        process.executableURL = executable.url
        process.arguments = commands
        process.currentDirectoryURL = currentDirectoryURL ?? URL(fileURLWithPath: NSHomeDirectory())
        
        let outputPip = Pipe()
        let errorPip = Pipe()
        process.standardOutput = outputPip
        process.standardError = errorPip
        try process.run()
        process.waitUntilExit()
        
        if process.terminationStatus != .zero {
            if let message = String(data: errorPip.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) {
                throw GitError(message: message)
            }
            throw GitError(message: "code: \(process.terminationReason.rawValue)")
        }
        
        return outputPip.fileHandleForReading.readDataToEndOfFile()
    }
    
    @discardableResult
    static func run(_ commands: [String],
                    executable: Resource = .git,
                    currentDirectoryURL: URL? = nil) throws -> String {
        let data = try data(commands,
                            executable: executable,
                            currentDirectoryURL: currentDirectoryURL)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
}

public extension Git.Resource {
    
    static let git    = Git.Resource("libexec/git-core/git")
    static let show   = Git.Resource("libexec/git-core/git-show")
    static let fetch  = Git.Resource("libexec/git-core/git-fetch")
    static let commit = Git.Resource("libexec/git-core/git-commit")
    static let status = Git.Resource("libexec/git-core/git-status")
    static let push   = Git.Resource("libexec/git-core/git-push")
    static let reset  = Git.Resource("libexec/git-core/git-reset")
    static let clone  = Git.Resource("libexec/git-core/git-clone")
    static let log    = Git.Resource("libexec/git-core/git-log")
    static let add    = Git.Resource("libexec/git-core/git-add")
    static let `init` = Git.Resource("libexec/git-core/git-init")
    
    static let templates = Git.Resource("share/git-core/templates")
    
}

public extension Git {
    
    static func repository(at url: URL) throws -> Repository {
        try Repository(url: url)
    }
    
    static func repository(at path: String) throws -> Repository {
        try Repository(path: path)
    }
    
}
