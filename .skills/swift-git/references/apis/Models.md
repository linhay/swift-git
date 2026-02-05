# Models

This page summarizes commonly used models exposed by the package.

GitStatus
- Location: Sources/SwiftGit/Custom/models/GitStatus.swift
- public struct GitStatus: Equatable with properties branch, changed, renamedCopied, unmerged, untracked and nested entry types.

GitProgress
- Location: Sources/SwiftGit/Custom/GitProgress.swift
- public struct GitProgress with progress counters and stage; paired with GitProgressStage and GitProgressAction for clone/pull progress callbacks.

Commit & User models
- Sources/SwiftGit/Custom/models/Commit.swift
- Sources/SwiftGit/Custom/results/LogResult.swift

Reference types
- Sources/SwiftGit/Custom/models/Reference.swift contains ReferenceType protocol and concrete Branch/Tag types for strongly-typed references.

Pathspec
- Sources/SwiftGit/Custom/models/Pathspec.swift — ExpressibleByStringLiteral helper for pathspecs.

Notes for agents
- Models are value types and safe to pass around. Prefer using them in examples rather than raw strings when demonstrating APIs.
