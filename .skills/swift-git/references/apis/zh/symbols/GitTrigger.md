# GitTrigger

声明
`public struct GitTrigger`

位置
Sources/SwiftGit/Custom/GitTrigger.swift

简介
事件触发原语，可用于在命令执行前后注入回调以获取命令或其输出数据。

可运行示例（假设 system git 在 PATH）
```swift
import SwiftGit

func triggerExample() {
    let trigger = GitTrigger(on: .beforeRun) { result in
        switch result {
        case .success(let content): print("about to run: \(content.commands)")
        case .failure(let err): print("trigger error: \(err)")
        }
    }
}
```

前提
- 无外部前提（纯内存回调）
