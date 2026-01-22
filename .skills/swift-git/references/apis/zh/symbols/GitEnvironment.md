# GitEnvironment

声明
`public class GitEnvironment`

位置
Sources/SwiftGit/Custom/GitEnvironment.swift

简介
管理 Git 可执行程序定位与环境变量配置。支持资源（Resource）与变量（Variable）等嵌套类型。

可运行示例（假设 system git 在 PATH）
```swift
import SwiftGit

func envExample() throws {
    // Use shared environment
    let env = GitEnvironment.shared
    let git = try Git(environment: env)
    print("git environment ready")
}
```

前提
- system git 在 PATH
