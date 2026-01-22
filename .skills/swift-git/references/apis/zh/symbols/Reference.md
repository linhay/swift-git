# Reference（协议与引用类型）

声明
`public protocol ReferenceType` / `public enum Reference` / `public struct Branch` / `public struct Tag`

位置
Sources/SwiftGit/Custom/models/Reference.swift

简介
强类型表示 Git 引用（分支、标签等），并提供解析与字符串字面量初始化的便利。

可运行示例（假设 system git 在 PATH）
```swift
import SwiftGit

func refExample() {
    let branch = Branch(longName: "refs/heads/main")
    print(branch.name)
}
```
