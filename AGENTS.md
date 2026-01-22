**Agents**

- This repository is a Swift Package (see `Package.swift`). The file `AGENTS.md` documents how automated agents should build, test, lint, and follow repository style conventions.
- Location: `/Users/linhey/Desktop/swift-git/AGENTS.md`

- **Primary commands**
  - Build (debug):

```bash
swift build
```

  - Build (release):

```bash
swift build -c release
```

  - Run tests (all):

```bash
swift test
```

  - Run a single test by name (recommended):

```bash
# Filter matches test case and/or function name. Examples:
swift test --filter Test.test_format_date
swift test --filter test_format_date
```

  - Run a single test target (if multiple test targets exist):

```bash
swift test --package-path . --filter <TestName>
```

  - Run a single test file under Xcode (if you open the package in Xcode): select the test method and press the test button or run `Product → Test` for the scheme.

- **Formatting / Linting**
  - This repository does not commit a linter or formatter configuration (no `.swiftlint.yml` or `.swift-format` file found at the repository root). Recommended tools (optional):
    - SwiftLint: `brew install swiftlint` then `swiftlint lint` (or `swiftlint autocorrect`).
    - swift-format: follow Apple or community formatter and add a `.swift-format` config if you want automated formatting.

- If you add a formatter/linter, update this document and add its config to the repo root.
  - This repository now includes minimal configuration examples:
    - `.swiftformat` — basic formatting rules used by `swiftformat`/community tools.
    - `.swiftlint.yml` — basic SwiftLint configuration. These are small defaults; adjust rules to taste.

- **Common CI commands**
  - Build + test (fast): `swift test --enable-test-discovery`
  - Build for release in CI: `swift build -c release --disable-sandbox` (use sandbox flags per your CI environment)

- **How to run tests with verbose output**
  - Use `swift test --show-test-coverage` (when supported) or run tests in Xcode for detailed logs.

- **Files to know**
  - `Package.swift` — Swift Package manifest
  - `Sources/SwiftGit` — main library source
  - `Tests/SwiftGitTests/Test.swift` — example test

- **Cursor / Copilot rules**
  - No `.cursor` or `.cursorrules` directory found in repository root.
  - No Copilot instructions file found at `.github/copilot-instructions.md`.
  - If you add Cursor/Copilot rules, place them in `.cursor/rules/` and reference them here.

- **Code style guidelines**

- Imports
  - Group imports into three sections (top to bottom): system (Foundation, Dispatch), third-party (e.g., `STFilePath`), and internal modules. Leave a single blank line between groups.
  - Use only the modules you need; avoid `import Foundation` unless required by APIs used in the file.

- File headers and structure
  - Keep files small and focused: one top-level type or tightly related small types per file.
  - Preserve the existing brief file header comments used in this repository (single-line with creation metadata is acceptable but not required).

- Formatting
  - Follow Swift API Design Guidelines for spacing and naming.
  - Use 4-space indentation for braces-based blocks. Keep line length under ~120 columns when practical.
  - Place opening brace on same line as declaration: `func foo() {`.

- Naming conventions
  - Types (struct/enum/class/protocol): UpperCamelCase (e.g., `Repository`, `GitError`).
  - Functions and variables: lowerCamelCase (e.g., `setupProcess`, `terminationHandler`).
  - Constants: `let` with lowerCamelCase; use descriptive names.
  - Errors: define `enum ...: Error` with cases in lowerCamelCase. If exposing public errors, conform to `LocalizedError` and provide `errorDescription` and a numeric `code` if helpful (see `Sources/SwiftGit/Custom/GitError.swift`).

- Types & API design
  - Prefer value types (struct/enum) for small, thread-safe types. Use `class` only when reference semantics are required.
  - Keep public API surface minimal and documented with doc comments (`///`).
  - Use `@available` attributes consistently when providing platform‑specific APIs (see `#if os(macOS)` and `@available(macOS 11, *)` blocks in `Shell.swift`).

- Concurrency
  - Prefer async/await for new asynchronous code on supported platforms. Provide Combine publishers only when the codebase already uses Combine (as in `Shell` for backwards compatibility).
  - Keep Task cancellation propagation explicit; check `Task.checkCancellation()` or `Task.isCancelled` where long-running work occurs.

- Error handling
  - Use typed Error enums rather than opaque strings when possible (see `GitError` in `Sources/SwiftGit/Custom/GitError.swift`).
  - When wrapping underlying errors, preserve the underlying `Error` value (e.g., `.other(Error)`) and propagate useful contextual information using `LocalizedError` conformance.
  - Avoid `.forceTry` or `try!` in production code; if a `try!` is used in tests or initialization with an invariant, add a comment explaining why it is safe.

- Optionals
  - Minimize force-unwrapping (`!`). Prefer `guard let` or `if let` to safely unwrap.
  - When returning optional values from APIs, document why `nil` may be returned.

- Logging & prints
  - Avoid `print()` in library-level code. Use `os_log` or a configurable logger for library clients. Tests may use `print` for debugging but remove debug prints before committing.

- Process & Shell usage
  - Centralize process execution code (the repository already has `Shell` utilities). Keep behavior consistent: capture both stdout and stderr, include `currentDirectory` in error messages, and return typed errors (see `Shell.result`).
  - Do not duplicate process setup logic — add new functionality to `Shell.Instance` or small helpers.

- Combine & Publishers
  - When exposing Combine publishers, ensure they are erased with `.eraseToAnyPublisher()` at the boundary.
  - Use `PassthroughSubject` for ephemeral streams and `CurrentValueSubject` for stateful values.

- Tests
  - Tests live in `Tests/SwiftGitTests`. Use the `Testing` package conventions already present (see `Tests/SwiftGitTests/Test.swift`).
  - Prefer `async` test methods for async code. Use `@Test` / `XCTest`-style attributes according to your test dependency.
  - Keep tests deterministic: avoid network I/O and environment-specific dependencies. Use fixtures or mock file system/state.

- Documentation
  - Document public APIs with `///` comments. Include short examples when it helps explain usage.

- PR / Commit notes for agents
  - When creating changes, keep commits small and focused; commit messages should be 1–2 lines explaining the "why" (not a line-by-line description).
  - Do not run destructive git commands. Avoid force pushes to protected branches.

- When you are blocked
  - If a change is ambiguous or may affect users (public API, version bump, or security), add a short issue or ask a human reviewer.

- Adding linters / rules
  - If you add `.swift-format` or `.swiftlint.yml`, update `AGENTS.md` immediately with the command to run them and recommended pre-commit hooks.

- Contact & context
  - Primary language: Swift. Platform: macOS (Package.swift declares macOS v12 minimum).
  - The repo bundles a git instance at `Sources/SwiftGit/Resource/git-instance.bundle` — agents should not modify the bundle contents unless explicitly intended.

---

If you want, I can also:
1) Add a basic `.swift-format` config and a `swiftformat` command in CI.
2) Add a minimal `.swiftlint.yml` with cores rules and an example pre-commit hook.
