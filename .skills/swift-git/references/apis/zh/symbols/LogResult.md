# LogResult

声明
解析 `git log` 输出的结果类型，包含作者信息、提交消息、日期等字段。

位置
Sources/SwiftGit/Custom/results/LogResult.swift

示例（高层使用）
```swift
let logs = try await repo.log(options: [])
for l in logs { print("commit: \(l.id) by \(l.author.email)") }
```
