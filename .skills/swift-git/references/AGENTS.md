This file is a concise, agent-focused summary of the repository AGENTS.md tailored for automated workers.

Core commands
- Build (debug): swift build
- Build (release): swift build -c release
- Run all tests: swift test
- Run a single test: swift test --filter <TestName>

Agent working rules (must follow)
- NEVER commit or push without explicit user permission.
- NEVER modify the embedded git bundle under Sources/SwiftGit/Resource/git-instance.bundle.
- When creating commits, follow repository commit message style: short 1-2 line message that explains the why.
- If adding linters or formatters, update AGENTS.md and CI configs accordingly.

Test & CI notes
- CI uses GitHub Actions (.github/workflows/ci.yml). Prefer macos-latest runners.
- Integration tests prefer the embedded git instance and fall back to system git.

File locations
- Package manifest: Package.swift
- Main sources: Sources/SwiftGit/
- Tests: Tests/SwiftGitTests/

Helpful patterns
- Use Shell utilities present in Sources/SwiftGit/Custom/Shell.swift for centralized process execution.
- Prefer array-based arguments when invoking Shell helpers (avoid building a single shell string).

Contact
- Open an issue with commands and repository state when blocked.
