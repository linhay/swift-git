# CloneOptions

声明
`public struct CloneOptions: ExpressibleByStringLiteral`

位置
Sources/SwiftGit/options/git-clone-options.swift

简介
用于构造 clone 命令参数的轻量封装，支持字面量构造与静态 helper。

示例
```swift
try await git.clone(.init("--depth=1"), repository: URL(string: "https://github.com/foo/bar.git")!, credentials: .default, directory: ".")
```
