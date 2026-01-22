# Repository

Location: Sources/SwiftGit/Custom/Repository.swift

Public declaration highlights
- public struct Repository
- public init(git: Git, url: URL)
- public init(git: Git, path: String)
- Many repository-scoped command helpers are defined as public extensions across Sources/SwiftGit/Custom/commands/*. These include clone, commit, push, status, tag, stash, fetch, pull, merge, etc.

Summary
Repository is a lightweight wrapper that provides convenience methods executing git commands within a repository directory using an associated Git instance.

Usage example

  let git = try Git(environment: .shared)
  let repo = git.repository(at: "/path/to/repo")
  try await repo.commit("message", options: .init())

Notes for agents
- Look for specific helper files under Sources/SwiftGit/Custom/commands/ to find detailed signatures and option types for each command.

Tests
- CloneCommandTests, IntegrationTests, and RepositoryRunTests contain examples that exercise Repository helpers.
