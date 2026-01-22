# Git

声明
`public class Git`

位置
Sources/SwiftGit/Custom/Git.swift

简介
Git 是库的高层入口，用于以编程方式执行 Git 命令，封装了 GitEnvironment 和 Shell.Instance。提供 publisher、async/await、和同步（抛出）三类接口变体。

可运行示例（需本地 Swift 工具链，建议在 macOS 环境下运行）
前提：Swift 可用，且工作目录是仓库根或将在本地初始化的测试仓库。

```swift
import SwiftGit

func example() async throws {
    let env = GitEnvironment.shared
    let git = try Git(environment: env)
    // async/await 运行 status
    let status = try await git.run(["status", "--porcelain=v2"]) 
    print(status)
}
```
