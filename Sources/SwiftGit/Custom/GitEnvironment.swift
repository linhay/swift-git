//
//  File.swift
//  
//
//  Created by linhey on 2022/6/24.
//

import Foundation

public class GitEnvironment {
    
    public let resource: Resource
    public var variables: [Variable]
    public var triggers: [GitTrigger] {
        didSet {
            var dict: [GitTrigger.Event: [GitTrigger]] = [:]
            triggers.forEach { item in
                if dict[item.event] == nil {
                    dict[item.event] = []
                }
                dict[item.event]?.append(item)
            }
            triggersMap = dict
        }
    }
    
    internal private(set) var triggersMap: [GitTrigger.Event: [GitTrigger]] = [:]
    
    public init(resource: Resource, variables: [Variable], triggers: [GitTrigger]) {
        self.variables = variables
        self.resource = resource
        self.triggers = []
        self.triggers = triggers
    }
    
}

public extension GitEnvironment {
    
    private static var _shared: GitEnvironment?
    
    static var shared: GitEnvironment {
        get throws {
            if let item = _shared {
                return item
            }
            
            let item = try GitEnvironment.embedd(variables: [], triggers: [])
            _shared = item
            return item
        }
    }
    
    enum Style {
        case embedd
        case system
        case custom(_ url: URL)
        case auto
    }
    
    static func embedd(variables: [Variable], triggers: [GitTrigger]) throws -> GitEnvironment {
        guard let url = Bundle.module.url(forAuxiliaryExecutable: "Contents/Resources/git-instance.bundle"),
              let bundle = Bundle(url: url) else {
            throw GitError.unableLoadEmbeddGitInstance
        }
        let resource = Resource(bundle: bundle)
        var variables = variables
        variables.append(contentsOf: [.execPath(resource.envExecPath), .configNoSysyem(true)])
        return .init(resource: resource, variables: variables, triggers: triggers)
    }
    
    static func system(variables: [Variable], triggers: [GitTrigger]) async throws -> GitEnvironment {
        guard let resource = try await GitShell.zsh(string: "where git")?
            .split(separator: "\n")
            .map(String.init)
            .filter({ FileManager.default.isExecutableFile(atPath: $0) })
            .compactMap({ URL(fileURLWithPath:$0) })
            .map({ $0.deletingLastPathComponent().deletingLastPathComponent() })
            .compactMap(Resource.init(folder:))
            .first else {
            throw GitError.noGitInstanceFoundOnSystem
        }
        return .init(resource: resource, variables: variables, triggers: triggers)
    }
    
    static func custom(folder: URL, variables: [Variable], triggers: [GitTrigger]) async throws -> GitEnvironment {
        guard let resource = Resource(folder: folder) else {
            throw GitError.unableLoadCustomGitInstance
        }
        return .init(resource: resource, variables: variables, triggers: triggers)
    }
    
    convenience init(_ item: GitEnvironment) throws {
        self.init(resource: item.resource, variables: item.variables, triggers: item.triggers)
    }
    
    convenience init(type: Style, variables: [Variable], triggers: [GitTrigger]) async throws {
        switch type {
        case .embedd:
            let item = try GitEnvironment.embedd(variables: variables, triggers: triggers)
            try self.init(item)
        case .system:
            let item = try await GitEnvironment.system(variables: variables, triggers: triggers)
            try self.init(item)
        case .custom(let folder):
            let item = try await GitEnvironment.custom(folder: folder, variables: variables, triggers: triggers)
            try self.init(item)
        case .auto:
            if let item = try? GitEnvironment.embedd(variables: variables, triggers: triggers) {
                try self.init(item)
            } else {
                try await self.init(type: .system, variables: variables, triggers: triggers)
            }
        }
    }
    
}

extension GitEnvironment {
    
    public struct Resource {
        
        public let executableURL: URL
        public let envExecPath: String
        
        public init?(folder: URL) {
            let exec = folder.appendingPathComponent("libexec/git-core")
            let git  = folder.appendingPathComponent("bin/git")
            guard FileManager.default.isExecutableFile(atPath: exec.path),
                  FileManager.default.isExecutableFile(atPath: git.path) else {
                return nil
            }
            executableURL = git
            envExecPath = exec.path
        }
        
        public init(bundle: Bundle) {
            self.executableURL = bundle.url(forAuxiliaryExecutable: "bin/git")!
            self.envExecPath = bundle.url(forAuxiliaryExecutable: "libexec/git-core")!.path
        }
        
        public init(executableURL: URL, envExecPath: String) {
            self.executableURL = executableURL
            self.envExecPath = envExecPath
        }
    }
    
}


public extension GitEnvironment {
    
    struct Variable {
        
        let key: String
        let value: String
        
        ///Mark: Global Behavior
        /// determines where Git looks for its sub-programs (like git-commit, git-diff, and others). You can check the current setting by running git --exec-path.
        public static func execPath(_ value: String) -> Variable {
            return .init(key: "GIT_EXEC_PATH", value: value)
        }
        
        /// isn’t usually considered customizable (too many other things depend on it), but it’s where Git looks for the global configuration file. If you want a truly portable Git installation, complete with global configuration, you can override HOME in the portable Git’s shell profile.
        public static func home(_ value: String) -> Variable {
            return .init(key: "HOME", value: value)
        }
        
        /// isn’t usually considered customizable (too many other things depend on it), but it’s where Git looks for the global configuration file. If you want a truly portable Git installation, complete with global configuration, you can override HOME in the portable Git’s shell profile.
        public static func prefix(_ value: String) -> Variable {
            return .init(key: "PREFIX", value: value)
        }
        
        ///  if set, disables the use of the system-wide configuration file. This is useful if your system config is interfering with your commands, but you don’t have access to change or remove it.
        public static func configNoSysyem(_ value: Bool) -> Variable {
            return .init(key: "GIT_CONFIG_NOSYSTEM", value: value ? "true" : "false")
        }
    }
    
}

