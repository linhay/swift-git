# PushOptions

声明
`public struct PushOptions: ExpressibleByStringLiteral`

位置
Sources/SwiftGit/options/git-push-options.swift

简介
封装 push 相关的参数（例如远端、标志等），方便以类型化或字面量的方式构造。

示例
```swift
try await repo.push(.init("origin"), refspecs: ["refs/heads/main"]) 
```
