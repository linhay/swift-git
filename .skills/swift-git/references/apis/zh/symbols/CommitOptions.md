# CommitOptions

声明
`public struct CommitOptions: ExpressibleByStringLiteral`

位置
Sources/SwiftGit/options/git-commit-options.swift

简介
封装 commit 相关选项，如 message、cleanup 策略等，支持字面量与静态构造函数。

示例
```swift
try await repo.commit(.init("-m"), pathspecs: [.all])
```
