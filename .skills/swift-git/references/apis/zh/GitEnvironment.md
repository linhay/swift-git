# GitEnvironment（类）

位置: Sources/SwiftGit/Custom/GitEnvironment.swift

概述
- GitEnvironment 封装如何定位和配置 git 可执行程序（嵌入式或系统提供），并暴露 environment 变量与触发器（GitTrigger）用于运行时钩子。

主要公开成员（节选）
- public class GitEnvironment
- public enum Style { case embed, system, custom(_ url: URL), auto }
- public struct Resource { public let executableURL: URL; public let envExecPath: String? }
- public struct Variable { factory helpers: execPath(_:), home(_:), prefix(_:), configNoSystem(_:), etc. }
- public init(resource: Resource, variables: [Variable], triggers: [GitTrigger])
- public static var shared: GitEnvironment { get }

使用示例

  if let resource = GitEnvironment.Resource(bundle: Bundle.main) {
      let env = GitEnvironment(resource: resource, variables: [], triggers: [])
      let git = Git(environment: env)
  }

Agent 注意事项
- 为测试或隔离目的，优先显式构造 GitEnvironment 而不是依赖 .shared。
- 不要修改 Sources/SwiftGit/Resource/git-instance.bundle 中的嵌入式 bundle。

相关测试
- Tests/SwiftGitTests/GitEnvironmentTests.swift
- Tests/SwiftGitTests/GitEnvironmentInitTests.swift
