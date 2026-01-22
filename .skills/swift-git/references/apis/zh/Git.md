# Git（类）

位置: Sources/SwiftGit/Custom/Git.swift

概述
- Git 是包的高层入口，用于以编程方式执行 git 命令。它封装了一个 GitEnvironment（决定使用嵌入或系统 git）和一个 Shell.Instance（负责进程执行）。

- 主要公开成员（较完整签名列表）
- public class Git
- public static var _shared: Git?
- public static var shared: Git { get throws }
- public let environment: GitEnvironment
- public var shell: Shell.Instance
- public init(environment: GitEnvironment)

- Publishers / Combine 变体：
  - public func dataPublisher(_ commands: [String], context: Shell.Context? = nil) -> AnyPublisher<Data, Error>
  - public func runPublisher(_ options: [GitOptions]) -> AnyPublisher<String, Error>
  - public func runPublisher(_ commands: [String], context: Shell.Context? = nil) -> AnyPublisher<String, Error>
  - public func runPublisher(_ cmd: String, context: Shell.Context? = nil) -> AnyPublisher<String, Error>

- Async/await 变体：
  - public func data(_ commands: [String], context: Shell.Context? = nil) async throws -> Data
  - public func run(_ options: [GitOptions]) async throws -> String
  - public func run(_ commands: [String], context: Shell.Context? = nil) async throws -> String
  - public func run(_ cmd: String, context: Shell.Context? = nil) async throws -> String

- 同步（抛出）变体：
  - public func data(_ commands: [String], context: Shell.Context? = nil) throws -> Data
  - public func run(_ options: [GitOptions]) throws -> String
  - public func run(_ commands: [String], context: Shell.Context? = nil) throws -> String
  - public func run(_ cmd: String, context: Shell.Context? = nil) throws -> String

- Repository 访问器：
  - public func repository(at url: URL) -> Repository
  - public func repository(at path: String) -> Repository

- 使用要点（给 agents）
- 优先使用数组形式的命令重载（[String]）以避免 shell 转义问题。
- 尽量不要修改 Git.shared；若需隔离测试环境，请显式创建新的 Git(environment:).
- 高级示例（非运行代码，仅说明参数选择）

  - 运行简单命令（async）: 调用 `try await git.run(["status"])` 并处理字符串输出。
  - 获取原始字节（async）: 当需要二进制结果时使用 `try await git.data(["rev-parse", "HEAD"])` 返回 Data。
  - 使用 publisher 进行流式处理：当需要订阅实时输出（例如大型操作进度）时，使用 `runPublisher` 或 `dataPublisher` 并订阅 AnyPublisher。


示例（非可执行，仅示范）

  let git = try Git(environment: .shared)
  let status = try await git.run(["status", "--porcelain=v2"]) // 返回 String

相关测试
- Tests/SwiftGitTests/IntegrationTests.swift
- Tests/SwiftGitTests/RepositoryRunTests.swift
