# Git

Location: Sources/SwiftGit/Custom/Git.swift

Public declaration highlights
- public class Git
- public static var shared: Git { get throws }
- public init(environment: GitEnvironment)
- public func data(_ commands: [String], context: Shell.Context? = nil) async throws -> Data
- public func run(_ commands: [String], context: Shell.Context? = nil) async throws -> String
- public func run(_ cmd: String, context: Shell.Context? = nil) async throws -> String
- public func data(_ commands: [String], context: Shell.Context? = nil) throws -> Data
- public func run(_ commands: [String], context: Shell.Context? = nil) throws -> String
- public func run(_ cmd: String, context: Shell.Context? = nil) throws -> String
- public func repository(at url: URL) -> Repository
- public func repository(at path: String) -> Repository

Summary
The Git class is the high-level entrypoint for running Git commands. It wraps a GitEnvironment (which selects an embedded or system git) and a Shell.Instance that performs the actual process execution. Use Git for programmatic access to git operations in this package.

Usage examples
- Async run example:

  let git = try Git(environment: .shared)
  let output = try await git.run(["status", "--porcelain=v2"]) // String

- Sync data example (throws):

  let data = try git.data(["rev-parse", "HEAD"]) // Data

Notes for agents
- Prefer the array-based overloads ([String]) to avoid shell-escaping issues.
- Do not modify Git.shared unless explicitly requested by the repository maintainer; creating a new Git(environment:) is preferred for test isolation.

Tests that reference Git
- Tests/SwiftGitTests/* includes integration tests that create Git/GitEnvironment instances and exercise repository workflows. See IntegrationTests.swift and RepositoryRunTests.swift.
