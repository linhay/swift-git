# GitTrigger（事件触发）

位置: Sources/SwiftGit/Custom/GitTrigger.swift

概述
- GitTrigger 是一个轻量的事件/回调原语，可注册在 GitEnvironment 中以在特定事件（如 beforeRun/afterRun）触发时执行回调。

主要类型
- public enum Event { case beforeRun, afterRun }
- public struct Content { public let commands: [String]; public let data: Data }
- public init(on event: Event, action: @escaping (_ result: Result<Content, Error>) -> Void)

示例

  let trigger = GitTrigger(on: .beforeRun) { result in
      switch result {
      case .success(let content): print("About to run: \(content.commands)")
      case .failure(let err): print("Trigger error: \(err)")
      }
  }

注意
- 对于测试或监控，传入触发器可以观察命令执行并收集 telemetry。
