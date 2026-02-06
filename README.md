# SwiftGit

SwiftGit is a Swift Package that wraps and orchestrates Git command-line functionality
so you can drive Git operations programmatically from Swift. It includes a small
shell abstraction, typed models for common git results, command builders for many
git subcommands, and an embedded portable git distribution for environments that
don't provide `git` on PATH.

This README gives a focused code-oriented overview of the implementation in
`Sources/` and practical instructions for building, testing, and contributing.

Key features
- Thin, testable wrappers around `git` commands (clone, commit, push, tag, stash, etc.)
- Centralized process execution utilities in `Shell` supporting Combine and async/await
- Typed models for common git outputs (`GitStatus`, `Commit`, `ShowCommitResult`)
- Embedded portable git at `Sources/SwiftGit/Resource/git-instance.bundle` for hermetic runs
- Extensive unit and integration tests that exercise parsing and real git workflows

Table of contents
- Project layout
- Build & test
- Important modules (quick code map)
- Embedded git bundle
- Tests and integration tests
- Contribution notes
 - Contribution notes
  - See `CONTRIBUTING.md` for contribution workflow, pre-commit hook instructions, and lint/format guidance.

Project layout (sources)
- `Sources/SwiftGit/` — main package sources
  - `Custom/` — hand-written implementation
    - `commands/` — high-level command helpers, e.g. `git-commands-clone.swift`, `git-commands-tag.swift`
    - `models/` — typed models like `GitStatus.swift`, `Commit.swift`, `Reference.swift`
    - `results/` — parsing results and helpers (e.g. `ShowCommitResult.swift`)
    - `Shell.swift` — centralized Process wrapper with Combine + async/await support
    - `GitEnvironment.swift` — locate and configure embedded or system git
    - `Git.swift` — top-level `Git` class, wiring environment, shell, and triggers
    - `Repository.swift` (+ extensions) — repository-level helpers
  - `Resource/git-instance.bundle/` — portable git binaries and extras included in the package
  - `options/` — typed option values used to compose command arguments

Build & test
- Build the package (debug):

```bash
swift build
```

- Build for release:

```bash
swift build -c release
```

- Run the full test suite:

```bash
swift test
```

- Run a single test by name (recommended):

```bash
# filter matches test case and/or function name
swift test --filter ParseTests.testChangedEntryIndex_valid
swift test --filter test_format_date
```

- Run tests in parallel (CI friendly):

```bash
swift test --parallel
```

Important modules (quick code map)
- `Shell` (`Sources/SwiftGit/Custom/Shell.swift`)
  - Centralizes process creation, captures stdout/stderr, provides publishers and async helpers.
  - Use `Git.data(...)` or `Git.run(...)` which delegate to `Shell.Instance`.

- `GitEnvironment` (`Sources/SwiftGit/Custom/GitEnvironment.swift`)
  - Selects between embedded git (`.embed`), system git (`.system`), or custom folder.
  - Exposes environment variables used to run git (e.g. `GIT_EXEC_PATH`).

- `Git` (`Sources/SwiftGit/Custom/Git.swift`)
  - High-level entrypoint. Use `Git(environment:)` or `try Git.shared` (throws if environment fails).
  - Methods: `run`, `runPublisher`, `data` with variants for arrays of args and string commands.

- `Repository` (`Sources/SwiftGit/Custom/Repository.swift` + `Repository+*.swift`)
  - Convenience methods that operate in a repository directory (run, clone, status, tag, etc.).

- `GitStatus` and parsing models (`Sources/SwiftGit/Custom/models/GitStatus.swift`)
  - Strongly-typed representations of `git status` output. Parsing code is defensive to avoid crashes on malformed input.

Embedded git bundle
- Embedded bundles are now split into dedicated resource targets so consumers can opt in by architecture.
- Products:
  - `SwiftGitArm64` → `Sources/SwiftGitResourcesArm64/Resource/git-instance.bundle`
  - `SwiftGitX86_64` → `Sources/SwiftGitResourcesX86_64/Resource/git-instance.bundle`
  - `SwiftGitUniversal` → `Sources/SwiftGitResourcesUniversal/Resource/git-instance.bundle`
- `SwiftGit` (base product) no longer embeds a bundle; `GitEnvironment.Style.embed` will only succeed if one of the resource products is linked.
- Agents and tests should not modify files under the bundles. Use `GitEnvironment.Style.custom(URL)` to point to an alternate git distribution.
- To generate updated bundles, run `tools/update-git-bundle.sh` with the desired `--archs` and copy the result into the corresponding `Sources/SwiftGitResources*/Resource/` directory.
- If a bundle looks unusually large, run `tools/fix-git-bundle-links.sh` to relink duplicate `git-*` binaries and shrink the footprint.
- The default build trims optional GUI/web/perl tooling and shell completions. Use `--include-extras` to keep them.
- The update script defaults to the host arch (`uname -m`). Use `--archs arm64,x86_64` for a universal bundle, or `tools/thin-git-bundle.sh` to slim an existing one.

Tests and integration tests
- Tests live under `Tests/SwiftGitTests/`.
  - Unit tests: parsing and helpers (safe parsing of `git` output, command splitting).
  - Integration tests: initialize temporary repos and run real git workflows (init, add, commit, tag, branch, stash, rebase, plumbing commands like `write-tree`).
- Integration tests try to use the embedded git first and fall back to system git. If neither is available they skip.
- Helper examples: `Tests/SwiftGitTests/IntegrationTests.swift`, `PlumbingTests.swift`, `ShowCommitResultTests.swift`.

Design & safety notes
- Parsing: code attempts to be defensive; `GitStatus` uses failable/parsing helpers and falls back to safe defaults for malformed input.
- Process execution: `Shell` captures stdout/stderr and surfaces a typed error when a process exits non‑zero (includes exit code and working directory where possible).
- Command string handling: the library provides a `splitCommandLine` helper to handle quoted/escaped arguments for string-based overloads. Prefer array-based overloads when possible to avoid shell-escaping issues.

CI
- A GitHub Actions workflow is included at `.github/workflows/ci.yml` and runs the build + tests on `macos-latest`.

Contributing and agents
- There is an `AGENTS.md` file with rules and commands for automated agents and contributors. Agents should follow its guidelines when editing, testing, and committing.
- Skill guidance for agent-enabled environments is also noted in `AGENTS.md`.

Example usage
- Simple programmatic example (conceptual):

```swift
import SwiftGit

// create environment and git
let env = try GitEnvironment(type: .auto)
let git = try Git(environment: env)

// run git --version
let version = try git.run(["--version"])
print("git version: \(version)")
```

Where to look next
- If you want to understand parsing code, start with `Sources/SwiftGit/Custom/results/ShowCommitResult.swift` and
  `Sources/SwiftGit/Custom/models/GitStatus.swift`.
- To add a new command helper, follow existing patterns under `Sources/SwiftGit/Custom/commands/`.

Questions or issues
- Open an issue describing what you tried, including commands and repository state. If you want me to extend tests to cover more commands from the official Git docs, say which areas to prioritize (plumbing, submodule flows, network edge cases, etc.).
