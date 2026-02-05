# Models（模型）

本部分涵盖常用的值类型模型，如 GitStatus、Commit、Reference、Pathspec、LogResult、ShowCommitResult 等。

GitStatus
- 位置: Sources/SwiftGit/Custom/models/GitStatus.swift
- 说明: `public struct GitStatus` 包含分支信息、已更改文件、重命名/拷贝、未合并、未跟踪项等。许多嵌套类型用于表示不同的条目。

GitProgress
- 位置: Sources/SwiftGit/Custom/GitProgress.swift
- 说明: 进度快照类型，包含 receivedObjects/totalObjects/indexedObjects/receivedBytes 与 stage；配合 GitProgressStage 与 GitProgressAction 用于 clone/pull 进度回调与取消控制。

Commit
- 位置: Sources/SwiftGit/Custom/models/Commit.swift
- 说明: 包含 Commit enum（如 HEAD、mnemonics 等）用于表示引用定位。

Reference（引用类型）
- 位置: Sources/SwiftGit/Custom/models/Reference.swift
- 说明: 提供 ReferenceType 协议以及 Branch/Tag/Reference 枚举的具体类型，便于强类型引用和解析。

Pathspec
- 位置: Sources/SwiftGit/Custom/models/Pathspec.swift
- 说明: ExpressibleByStringLiteral 的包装类型，用于传递路径匹配参数。

ShowCommitResult / LogResult
- 说明: 解析 `git show` 与 `git log` 输出的结构化结果类型，用于测试与上层调用解析结果。

Agent 指南
- 在示例中优先使用这些模型而非裸字符串，以鼓励类型安全示例和清晰文档。
Agent 指南
- 在示例中优先使用这些模型而非裸字符串，以鼓励类型安全示例和清晰文档。

补充高级示例（非运行代码）

  - 解析并处理状态：
    let status = try await repo.status()
    for changed in status.changed {
      // 使用 changed.path / changed.index 等字段进行业务逻辑
    }

  - 使用 ShowCommitResult 检索文件差异并映射为高层变更对象以供 UI 或日志显示。
