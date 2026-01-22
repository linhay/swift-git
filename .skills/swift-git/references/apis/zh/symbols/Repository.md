# Repository

声明
`public struct Repository`

位置
Sources/SwiftGit/Custom/Repository.swift

简介
Repository 是仓库级别的封装，绑定到一个 Git 实例上，提供仓库范围的便捷方法（commit、push、status、tag、stash 等）。

可运行示例（假设 system git 在 PATH）
```swift
import SwiftGit

func repoExample() async throws {
    let env = GitEnvironment.shared
    let git = try Git(environment: env)
    let repo = git.repository(at: ".")
    let status = try await repo.status()
    print("changed files: \(status.changed.count)")
}
```

前提
- Swift toolchain installed and `git` available on PATH.
