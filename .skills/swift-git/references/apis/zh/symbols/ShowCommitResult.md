# ShowCommitResult

声明
用于解析 `git show` 输出，包含文件 diff、作者和提交消息等详细信息。

位置
Sources/SwiftGit/Custom/results/ShowCommitResult.swift

示例（高层使用）
```swift
let result = try await repo.show(commitID)
for item in result.items { print(item.diff) }
```
