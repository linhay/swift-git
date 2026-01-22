# Commit

声明
`public enum Commit`

位置
Sources/SwiftGit/Custom/models/Commit.swift

简介
表示对提交引用的抽象（例如 HEAD、~n、^n 等 mnemonics），便于在 API 中传递引用而非裸字符串。

可运行示例
```swift
import SwiftGit

func commitExample() {
    let c = Commit.head([.tilde(1)])
    print(c.name) // "HEAD~1"
}
```
