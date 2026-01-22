# Repository（结构体）

位置: Sources/SwiftGit/Custom/Repository.swift

概述
- Repository 是对仓库目录里的 Git 操作的轻量封装，绑定在一个 Git 实例上，提供方便的方法来执行常见的 git 流程（commit、push、status、tag、stash 等）。

主要公开成员（节选）
- public struct Repository
- public init(git: Git, url: URL)
- public init(git: Git, path: String)


使用要点与高级示例（非运行代码）

  - 获取仓库实例：使用 `let repo = git.repository(at: path)` 获取仓库上下文后，所有仓库级别方法在该实例上调用。
  - 提交（async）: `try await repo.commit(.init("-m", "message"), pathspecs: [.all])`（示例意图展示：使用 CommitOptions 与 Pathspec 组合）。
  - 查询状态：`let status = try await repo.status()` 返回 GitStatus，包含 changed/untracked 等字段供处理。

给 agents 的注意事项
- 在生成示例时优先展示 async/await 版本；如果需要展示事件流或大型任务进度，请给出 publisher 变体作为替代方案。


相关测试
- Tests/SwiftGitTests/CloneCommandTests.swift
- Tests/SwiftGitTests/IntegrationTests.swift
