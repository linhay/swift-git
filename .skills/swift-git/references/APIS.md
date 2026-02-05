# SwiftGit public API inventory

This document catalogs the public API surface of the SwiftGit package and provides focused documentation and usage examples for automated agents and human readers. It is intended to be consumed by agents to generate actionable SKILL content for each API area.

Structure
- Classes & types: short descriptions and top-level public members
- Models: commonly used value types and their important properties
- Options: ExpressibleByStringLiteral option types used as argument helpers
- Commands: repository/command helpers exposed as public extensions
- Tests: reference to tests that target the public API

Primary public types

1) Git (class)
- Location: Sources/SwiftGit/Custom/Git.swift
- Summary: High-level entrypoint for running git commands via the package. Holds a GitEnvironment and a Shell.Instance for process execution.
- Important public members (selection):
  - public static var shared: Git { get throws }
  - public init(environment: GitEnvironment)
  - public func data(_ commands: [String], context: Shell.Context? = nil) async throws -> Data
  - public func run(_ commands: [String], context: Shell.Context? = nil) async throws -> String
  - public func run(_ cmd: String, context: Shell.Context? = nil) async throws -> String
  - public func data(_ commands: [String], context: Shell.Context? = nil) throws -> Data
  - public func run(_ commands: [String], context: Shell.Context? = nil) throws -> String
  - public func repository(at url: URL) -> Repository
  - public func repository(at path: String) -> Repository

2) GitEnvironment (class & nested types)
- Location: Sources/SwiftGit/Custom/GitEnvironment.swift
- Summary: Represents a configured git runtime (embedded, system, or custom). Encapsulates resource (executable), environment variables, and triggers.
- Important public members:
  - public enum Style { case embed, system, custom(_ url: URL), auto }
  - public struct Resource { public let executableURL: URL; public let envExecPath: String? }
  - public struct Variable { factory helpers: execPath(_:), home(_:), prefix(_:), configNoSystem(_:), etc. }
  - public init(resource: Resource, variables: [Variable], triggers: [GitTrigger])
  - public static var shared: GitEnvironment { get }

3) Repository (struct)
- Location: Sources/SwiftGit/Custom/Repository.swift
- Summary: Convenience repository-scoped helpers backed by a Git instance. Provides many sub-APIs for common git workflows.
- Important public members (selection):
  - public init(git: Git, url: URL)
  - public init(git: Git, path: String)
  - public extension Repository { many repository helpers live in extensions (clone, commit, push, status, tag, stash, etc.) }

4) Shell (structs & Instance)
- Location: Sources/SwiftGit/Custom/Shell.swift
- Summary: Centralized process execution utilities (sync/async + Combine publishers). Prefer these helpers when invoking git.
- Important public types & members:
  - public struct Context { public var environment: [String: String]; public var currentDirectory: URL?; public let standardOutput: PassthroughSubject<Data, Never>? }
  - public struct Arguments / ShellArguments
  - public struct Instance { public var changedArgsBeforeRun: ((_ args: inout Arguments) -> Void)?; public func data(_ args: Shell.Arguments) async throws -> Data; public func string(_ args: Shell.Arguments) async throws -> String }
  - convenience static helpers: Shell.zsh(...), Shell.data(...), Shell.string(...)

5) GitTrigger (struct)
- Location: Sources/SwiftGit/Custom/GitTrigger.swift
- Summary: Small callback/event primitive used by GitEnvironment to trigger hooks on events.
- Important public members:
  - public enum Event: Int { case beforeRun, afterRun }
  - public struct Content { public let commands: [String]; public let data: Data }
  - public init(on event: Event, action: @escaping (_ result: Result<Content, Error>) -> Void)
  - public static func failure(on:event, action: ...) and success(on:event, action: ...)

6) GitProgress / GitProgressStage / GitProgressAction (struct + enums)
- Location: Sources/SwiftGit/Custom/GitProgress.swift
- Summary: Progress snapshot types for long-running clone/pull operations, plus the action enum for cancellable callbacks.
- Important public members:
  - public struct GitProgress { receivedObjects, totalObjects, indexedObjects, receivedBytes, stage, stagePercent }
  - public enum GitProgressStage { case network, indexing, checkout, done }
  - public enum GitProgressAction { case proceed, cancel }

Models (examples)
- GitStatus (Sources/SwiftGit/Custom/models/GitStatus.swift): public struct GitStatus with properties branch, changed, renamedCopied, unmerged, untracked. Several nested types represent entries and styles.
- Commit / Commit enums: Sources/SwiftGit/Custom/models/Commit.swift
- Reference types: Sources/SwiftGit/Custom/models/Reference.swift (protocol ReferenceType, structs Branch, Tag)
- Pathspec: ExpressibleByStringLiteral helper, value wrapper

Options
- Many option types are defined as small structs conforming to ExpressibleByStringLiteral for convenient API composition. Examples:
  - AddOptions, ResetOptions, CloneOptions, CommitOptions, PushOptions, FetchOptions, StatusOptions, etc. (see Sources/SwiftGit/options/)

Commands & repository extensions
- Most git subcommands are exposed as public extensions on Git or Repository under Sources/SwiftGit/Custom/commands/*. Each file shapes a coherent sub-API (clone, commit, push, fetch, log, status, tag, stash, etc.).
- Clone and pull now have progress callback overloads (see git-commands-clone.swift and git-commands-pull.swift).

Tests that reference public APIs
- Tests live under Tests/SwiftGitTests. Key files that exercise public APIs include:
  - Tests/SwiftGitTests/IntegrationTests.swift
  - Tests/SwiftGitTests/ParseTests.swift
  - Tests/SwiftGitTests/CloneCommandTests.swift
  - Tests/SwiftGitTests/ShowCommitResultTests.swift

How this inventory will be used
- The next step is to generate per-API skill documentation files that include:
  - The declaration/signature
  - Short description
  - Examples of usage (non-executable snippets)
  - Tests referencing the API

Follow-up files to generate (I will create when you approve):
- references/apis/Git.md
- references/apis/GitEnvironment.md
- references/apis/Repository.md
- references/apis/Shell.md
- references/apis/GitTrigger.md
- references/apis/Models.md
- references/apis/Options.md
- references/apis/Commands.md
