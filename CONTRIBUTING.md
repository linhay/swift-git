Thank you for contributing to SwiftGit — this document explains the recommended workflow, tests, and PR guidance used by automated agents and maintainers.

Quick start
- Build: `swift build`
- Run tests (all): `swift test`
- Run a single test: `swift test --filter <TestName>`

Branching & commits
- Create a short-lived feature branch: `git checkout -b feat/short-description` or `fix/description`.
- Keep commits small and focused. Commit messages should explain *why* (1–2 lines).
- Do not amend pushed commits unless explicitly requested.

Tests
- Prefer adding unit tests under `Tests/SwiftGitTests/` using existing helpers.
- Integration tests use an embedded or system `git` and will `XCTSkip` when none is available. Use `envOrSkip()` helpers where appropriate.
- Run a specific test case by name with `swift test --filter Test.testName`.

Style & lint
- Follow the conventions in `AGENTS.md` (imports ordering, 4-space indentation, minimal force-unwrapping).
- This repo includes minimal config files for format/lint: `.swiftformat` and `.swiftlint.yml`.
- A simple pre-commit example is available at `tools/pre-commit.sh`. To enable it locally, run:

```
mkdir -p .git/hooks
cp tools/pre-commit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

  This hook runs `swiftformat` and `swiftlint autocorrect` if those tools are installed. It is optional and not enforced by CI by default.

PR checklist
- Include a short summary and why the change is needed.
- Add or update tests for behavior changes.
- Ensure `swift test` passes locally.
- Mention any CI requirements or special environment needs (e.g., credential helpers).

CI
- This repo includes a GitHub Actions workflow at `.github/workflows/ci.yml`.
- CI runs on macOS and uses the embedded git bundle when appropriate.

Large changes
- For changes to public APIs, document migration notes and consider a changelog entry.
- Avoid modifying the embedded git bundle at `Sources/SwiftGit/Resource/git-instance.bundle` unless intentional.

Need help?
- Open an issue using the templates in `.github/ISSUE_TEMPLATE/`.
