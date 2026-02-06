//
//  File.swift
//
//
//  Created by linhey on 2022/6/24.
//

import Foundation
import STFilePath

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

extension GitEnvironment {

    private static var _shared: GitEnvironment?
    public static var shared: GitEnvironment {
        get throws {
            if let item = _shared {
                return item
            }
            let item = try GitEnvironment(type: .auto, variables: [], triggers: [])
            _shared = item
            return item
        }
    }

    public enum Style {
        case embed
        case system
        case custom(_ url: URL)
        case auto
    }

    public convenience init(
        type: Style,
        shell: Shell.Instance = .init(),
        variables: [Variable] = [],
        triggers: [GitTrigger] = []
    ) throws {
        switch type {
        case .embed:
            guard
                let resourceBundle = Self.findEmbeddedResourceBundle(),
                let embeddedURL = resourceBundle.url(forResource: "git-instance", withExtension: "bundle"),
                let bundle = Bundle(url: embeddedURL),
                let resource = Resource(bundle: bundle)
            else {
                throw GitError.unableLoadEmbeddGitInstance
            }
            var variables = variables
            if let execPath = resource.envExecPath {
                variables.append(contentsOf: [.execPath(execPath), .configNoSystem(true)])
            } else {
                variables.append(.configNoSystem(true))
            }
            self.init(resource: resource, variables: variables, triggers: triggers)
        case .system:
            guard
                let path = try shell.shell(string: .init(command: "which git"))?
                    .split(separator: "\n")
                    .first?
                    .trimmingCharacters(in: .whitespacesAndNewlines),
                STFile(path).permission.contains(.executable)
            else {
                throw GitError.noGitInstanceFoundOnSystem
            }
            let resource = Resource(executableURL: STFile(path).url)
            self.init(resource: resource, variables: variables, triggers: triggers)
        case .custom(let folder):
            guard let resource = Resource(folder: folder) else {
                throw GitError.unableLoadCustomGitInstance
            }
            var variables = variables
            if let execPath = resource.envExecPath {
                variables.append(contentsOf: [.execPath(execPath), .configNoSystem(true)])
            } else {
                variables.append(.configNoSystem(true))
            }
            self.init(resource: resource, variables: variables, triggers: triggers)
        case .auto:
            if let item = try? GitEnvironment(
                type: .embed, variables: variables, triggers: triggers)
            {
                self.init(
                    resource: item.resource, variables: item.variables, triggers: item.triggers)
            } else {
                try self.init(type: .system, variables: variables, triggers: triggers)
            }
        }
    }

}

extension GitEnvironment {

    private static func findEmbeddedResourceBundle() -> Bundle? {
        let candidates: [String]
#if arch(arm64)
        candidates = [
            "SwiftGitResourcesArm64",
            "SwiftGitResourcesUniversal",
            "SwiftGitResourcesX86_64",
            "SwiftGit"
        ]
#elseif arch(x86_64)
        candidates = [
            "SwiftGitResourcesX86_64",
            "SwiftGitResourcesUniversal",
            "SwiftGitResourcesArm64",
            "SwiftGit"
        ]
#else
        candidates = [
            "SwiftGitResourcesUniversal",
            "SwiftGitResourcesArm64",
            "SwiftGitResourcesX86_64",
            "SwiftGit"
        ]
#endif

        let bundles = Bundle.allBundles + Bundle.allFrameworks
        for name in candidates {
            if let url = Bundle.main.url(forResource: name, withExtension: "bundle"),
               let bundle = Bundle(url: url) {
                return bundle
            }
            if let bundle = bundles.first(where: { $0.bundleURL.lastPathComponent == "\(name).bundle" }) {
                return bundle
            }
        }
        return nil
    }

    public struct Resource {

        public let executableURL: URL
        public let envExecPath: String?

        public init?(folder: URL) {
            let exec = folder.appendingPathComponent("libexec/git-core")
            let git = folder.appendingPathComponent("bin/git")
            guard FileManager.default.isExecutableFile(atPath: exec.path),
                FileManager.default.isExecutableFile(atPath: git.path)
            else {
                return nil
            }
            executableURL = git
            envExecPath = exec.path
        }

        public init?(bundle: Bundle) {
            guard let gitURL = bundle.url(forAuxiliaryExecutable: "bin/git"),
                  let execPathURL = bundle.url(forAuxiliaryExecutable: "libexec/git-core")
            else { return nil }
            self.executableURL = gitURL
            self.envExecPath = execPathURL.path
        }

        public init(executableURL: URL, envExecPath: String? = nil) {
            self.executableURL = executableURL
            self.envExecPath = envExecPath
        }
    }

}

extension GitEnvironment {

    public struct Variable {

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
        @available(*, deprecated, message: "Typo: use configNoSystem(_:) instead")
        public static func configNoSysyem(_ value: Bool) -> Variable {
            return .init(key: "GIT_CONFIG_NOSYSTEM", value: value ? "true" : "false")
        }

        /// Correct spelling for disabling the system config file lookup.
        public static func configNoSystem(_ value: Bool) -> Variable {
            return .init(key: "GIT_CONFIG_NOSYSTEM", value: value ? "true" : "false")
        }
    }

}
