# Pathspec

声明
`public struct Pathspec: ExpressibleByStringLiteral`

位置
Sources/SwiftGit/Custom/models/Pathspec.swift

简介
表达路径匹配表达式（如 "."、"src/**"），并支持字面量初始化以方便在 API 调用中直接使用字符串。

示例
```swift
let p: Pathspec = "."

// 作为参数传递
try await repo.reset(.init("--hard"), paths: [p])
```
