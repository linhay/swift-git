# Commands

This section maps the command helper files in Sources/SwiftGit/Custom/commands/ to high-level responsibilities. Each file typically exposes public extensions on Git or Repository and associated option types.

Files & purpose (selection)
- git-commands-clone.swift — clone helpers and CloneOptions
- git-commands-pull.swift — pull helpers and PullOptions (includes progress callbacks)
- git-commands-commit.swift — commit helpers and CommitOptions
- git-commands-status.swift — status helpers and StatusOptions
- git-commands-log.swift — log helpers and LogOptions
- git-commands-push.swift — push helpers and PushOptions
- git-commands-fetch.swift — fetch helpers
- git-commands-tag.swift — tag helpers
- git-commands-stash.swift — stash helpers

Notes for agents
- For each command helper, open the corresponding file to extract exact function signatures and examples. When in doubt, prefer the explicit functions that accept typed option structs.
