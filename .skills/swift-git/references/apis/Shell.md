# Shell

Location: Sources/SwiftGit/Custom/Shell.swift

Public declaration highlights
- public struct Shell (namespace)
- public struct Context { public var environment: [String: String]; public var currentDirectory: URL?; public let standardOutput: PassthroughSubject<Data, Never>? }
- public struct Arguments / ShellArguments
- public struct Instance { public var changedArgsBeforeRun: ((_ args: inout Arguments) -> Void)?; public func data(_ args: Shell.Arguments) async throws -> Data; public func string(_ args: Shell.Arguments) async throws -> String }
- public static helpers: Shell.zsh(...), Shell.data(...), Shell.string(...)

Summary
Centralized process execution helpers. They provide sync and async helpers and Combine publishers for streaming output. Use these to ensure consistent handling of stdout/stderr and to preserve working-directory context.

Usage examples

  let instance = Shell.Instance()
  let output = try await instance.string(.init(exec: gitURL, commands: ["--version"]))

Notes for agents
- Prefer using Instance methods and array-of-commands overloads to avoid shell-escaping and to ensure workingDirectory and environment propagation.

Tests
- RepositoryRunTests and IntegrationTests use Shell helpers under the hood when invoking Git commands.
