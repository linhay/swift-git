# StatusOptions

声明
`public struct StatusOptions: ExpressibleByStringLiteral`

位置
Sources/SwiftGit/options/git-status-options.swift

简介
用于控制 `git status` 的输出格式与过滤选项，并提供静态 builder 方法。

示例
```swift
let s = try await repo.status()
let raw = try await repo.status(.init("--porcelain=v2"), pathspec: ".")
```
