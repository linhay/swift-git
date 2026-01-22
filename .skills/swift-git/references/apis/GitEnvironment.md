# GitEnvironment

Location: Sources/SwiftGit/Custom/GitEnvironment.swift

Public declaration highlights
- public class GitEnvironment
- public enum Style { case embed, system, custom(_ url: URL), auto }
- public struct Resource { public let executableURL: URL; public let envExecPath: String? }
- public struct Variable { factory helpers: execPath(_:), home(_:), prefix(_:), configNoSystem(_:), etc. }
- public init(resource: Resource, variables: [Variable], triggers: [GitTrigger])
- public static var shared: GitEnvironment { get }

Summary
Encapsulates how the library locates and configures a git binary, including an embedded git bundle or system git. Variables allow customizing environment variables such as GIT_EXEC_PATH and HOME.

Usage

  let env = try GitEnvironment(resource: .init(executableURL: url), variables: [], triggers: [])
  let git = Git(environment: env)

Notes for agents
- When tests or integration code need predictable behavior, prefer explicitly constructed GitEnvironment instances over .shared.

Tests referencing GitEnvironment
- GitEnvironmentTests.swift and GitEnvironmentInitTests.swift
