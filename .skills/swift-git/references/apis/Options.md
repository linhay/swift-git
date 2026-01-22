# Options

The repository defines many small option types used to compose git command arguments. All are in Sources/SwiftGit/options/ and most conform to ExpressibleByStringLiteral for convenient construction.

Examples
- CloneOptions, CommitOptions, PushOptions, FetchOptions, StatusOptions, ResetOptions, AddOptions, etc.

Usage example

  try await repo.log(options: .init("--oneline"))

Notes for agents
- These option types are lightweight wrappers. When generating examples, prefer to show both literal string usage and typed usage (e.g., .message("msg")).
