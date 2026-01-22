# Shell

声明
`public struct Shell`（包含 Context / Arguments / Instance 等）

位置
Sources/SwiftGit/Custom/Shell.swift

简介
Shell 提供集中化的进程执行接口，支持同步/异步与发布者模型，便于在指定目录或指定环境下运行命令并捕获输出。

可运行示例（假设 system git 在 PATH）
```swift
import SwiftGit

func shellExample() async throws {
    let instance = Shell.Instance()
    let output = try await instance.string(.init(exec: nil, commands: ["git", "--version"]))
    print(output)
}
```

前提
- system git 在 PATH
