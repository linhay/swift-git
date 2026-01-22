# GitStatus

声明
`public struct GitStatus: Equatable`

位置
Sources/SwiftGit/Custom/models/GitStatus.swift

简介
封装 `git status` 的结构化表示，包含分支信息、已更改条目、重命名/拷贝、未合并及未跟踪项。

可运行示例（假设 system git 在 PATH）
```swift
import SwiftGit

func statusExample() async throws {
    let git = try Git(environment: .shared)
    let repo = git.repository(at: ".")
    let status = try await repo.status()
    print("untracked: \(status.untracked.count)")
}
```
