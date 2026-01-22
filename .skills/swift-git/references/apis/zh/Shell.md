# Shell（执行工具）

位置: Sources/SwiftGit/Custom/Shell.swift

概述
- Shell 提供了集中化的进程执行封装，支持同步/异步以及 Combine 发布者以便流式读取 stdout/stderr，同时包含上下文（当前目录、环境变量）。

主要类型与成员
- public struct Shell {}
- public struct Context { public var environment: [String: String]; public var currentDirectory: URL?; public let standardOutput: PassthroughSubject<Data, Never>? }
- public struct Arguments / ShellArguments
- public struct Instance { public var changedArgsBeforeRun: ((_ args: inout Arguments) -> Void)?; public func data(_ args: Shell.Arguments) async throws -> Data; public func string(_ args: Shell.Arguments) async throws -> String }
- 公共静态辅助：Shell.zsh(...), Shell.data(...), Shell.string(...)


使用要点与高级示例（非运行代码）

  - 同步/异步选择：若希望阻塞直到命令完成以获取完整输出，使用 `try await instance.string(...)` 或 `try await instance.data(...)`。如果希望流式接收输出，请使用 `dataPublisher`/`stringPublisher` 系列方法。
  - 保持上下文：在调用时传入 `Shell.Context` 以指定 `currentDirectory` 或额外 `environment`（例如隔离测试环境时覆盖 PATH）。

Agent 提示
- 使用 Instance 方法和数组命令重载，避免构造单一 shell 字符串以减少转义问题与安全隐患。

相关测试
- RepositoryRunTests 和 IntegrationTests 在内部通过 Shell 执行命令。
