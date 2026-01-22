# Options（选项类型）

仓库中定义了大量轻量的选项类型，用于组合 git 命令参数。大多数位于 Sources/SwiftGit/options/ 并实现了 ExpressibleByStringLiteral。

示例
- CloneOptions、CommitOptions、PushOptions、FetchOptions、StatusOptions、ResetOptions、AddOptions 等。

使用示例

  try await repo.log(options: .init("--oneline"))

Agent 建议
- 示例中同时展示字面量构造（.init("--oneline")）和静态构造方法（如 .message("msg")）可以帮助使用者理解构造选项的两种常见方式。
