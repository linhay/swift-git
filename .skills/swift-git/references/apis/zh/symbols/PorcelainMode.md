# PorcelainMode

声明
`public enum PorcelainMode: String`

位置
Sources/SwiftGit/Custom/models/Porcelain.swift

简介
用于描述 `git status` 等命令的 porcelain 输出格式，例如 v1、v2 等，可用于解析不同格式的输出。

示例
```swift
let mode: PorcelainMode = .v2
```
