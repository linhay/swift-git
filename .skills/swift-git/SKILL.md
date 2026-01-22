---
name: "swift-git"
description: "Repository-focused skill for building, testing, and agent-safe operations in the SwiftGit repository. Use when performing build/test tasks, running single tests, or when an automated agent needs to follow repository agent rules and safe commands."
---

# swift-git skill

Purpose
- Provide concise, actionable instructions and examples for automated agents and humans working with this repository.
- Expose the small set of repository-specific commands and agent rules an automated worker needs so the runtime can make safe decisions without loading large docs.

When to use this skill (trigger examples)
- "Build the package"
- "Run tests"
- "Run a single test"
- "Where are the build/test commands"
- "What agent rules should I follow for commits and CI"

Quick commands (do not execute without user approval)
- Build (debug):
  - swift build
- Build (release):
  - swift build -c release
- Run full tests:
  - swift test
- Run a single test (filter by name):
  - swift test --filter ParseTests.testChangedEntryIndex_valid
  - swift test --filter test_format_date

Repository constraints (MUST follow)
- Do NOT create commits or push to remote on behalf of a user unless explicitly authorized.
- Do NOT modify the embedded git bundle at Sources/SwiftGit/Resource/git-instance.bundle.
- Avoid adding or enforcing new lint/format rules without updating AGENTS.md and CI configuration.

Agent safety rules (short)
- Prefer array-based process invocations in code over shell-escaped string commands to avoid escaping bugs.
- Prefer existing libraries and small focused changes vs large refactors.
- When making multi-step changes, create an explicit TODO plan and surface it before editing.

References
- See references/AGENTS.md for a concise, agent-focused summary of AGENTS.md and repository tooling.

Examples (do not auto-run)
- "I want to run the test suite locally": use `swift test` from repository root.
- "Run a single test": use `swift test --filter <TestName>` as shown above.
- "Check package manifest": open Package.swift at repository root.

Packaging the skill
- To package this skill (manual step), follow your environment's packaging script. Example: `scripts/package_skill.py swift-git.skill` (if package exists in your environment).

FAQ
- Q: Should an agent commit changes it makes?
  - A: No. Only stage files locally and present a diff; commit only if the user explicitly asks.
