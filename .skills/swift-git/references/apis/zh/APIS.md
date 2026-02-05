# API 清单总览（中文）

本文件总结仓库的公共 API 范围，供 agent 在生成 API 文档或示例时快速参考。

## 主要类型

### 核心类
- [Git](symbols/Git.md)（类） — Sources/SwiftGit/Custom/Git.swift - Git 操作的顶层入口点
- [Repository](symbols/Repository.md)（结构体） — Sources/SwiftGit/Custom/Repository.swift - 仓库级别的封装
- [GitEnvironment](symbols/GitEnvironment.md)（类） — Sources/SwiftGit/Custom/GitEnvironment.swift - Git 环境配置管理
- [Shell](symbols/Shell.md)（工具） — Sources/SwiftGit/Custom/Shell.swift - 进程执行工具
- [GitTrigger](symbols/GitTrigger.md)（结构体） — Sources/SwiftGit/Custom/GitTrigger.swift - 命令执行触发器
- GitProgress / GitProgressStage / GitProgressAction（结构体/枚举） — Sources/SwiftGit/Custom/GitProgress.swift - 克隆/拉取进度回调类型与可取消动作

### 错误处理
- [GitError](symbols/GitError.md)（枚举） — Sources/SwiftGit/Custom/GitError.swift - 统一的错误类型定义

## 模型与结果类型

### 状态和历史
- [GitStatus](symbols/GitStatus.md)（结构体） — Sources/SwiftGit/Custom/models/GitStatus.swift - 仓库状态信息
- [LogResult](symbols/LogResult.md)（结构体） — Sources/SwiftGit/Custom/results/LogResult.swift - 日志结果解析
- [ShowCommitResult](symbols/ShowCommitResult.md)（结构体） — Sources/SwiftGit/Custom/results/ShowCommitResult.swift - 提交详情结果

### 引用和标识
- [Reference](symbols/Reference.md)（协议/枚举） — Sources/SwiftGit/Custom/models/Reference.swift - Git 引用抽象
- [Branch](symbols/Reference.md#branch-结构体)（结构体） — 分支引用
- [Tag](symbols/Reference.md#tag-结构体)（结构体） — 标签引用
- [Commit](symbols/Commit.md)（枚举） — Sources/SwiftGit/Custom/models/Commit.swift - 提交引用助记符

### 路径和模式
- [Pathspec](symbols/Pathspec.md)（结构体） — Sources/SwiftGit/Custom/models/Pathspec.swift - 路径规范匹配
- [GitCredentials](symbols/GitCredentials.md)（结构体） — Sources/SwiftGit/Custom/models/GitCredentials.swift - Git 凭据管理

### 模式和配置
- [Porcelain](symbols/PorcelainMode.md)（枚举） — Sources/SwiftGit/Custom/models/Porcelain.swift - 陶瓷模式输出格式
- [UntrackedFilesMode](symbols/UntrackedFilesMode.md)（枚举） — Sources/SwiftGit/Custom/models/UntrackedFilesMode.swift - 未跟踪文件处理模式

## 选项类型

### 核心协议
- [GitOptions](symbols/GitOptions.md)（协议） — 所有 Git 选项的统一接口

### 命令选项（30+ 个）
#### 提交相关
- [GitCommitOption](symbols/GitCommitOption.md)（枚举） — Sources/SwiftGit/options/git-commit-options.swift
- [StatusOptions](symbols/StatusOptions.md)（枚举） — Sources/SwiftGit/options/git-status-options.swift
- [GitStatusOption](symbols/GitStatusOption.md)（枚举） — Sources/SwiftGit/options/git-status-options.swift（补充）

#### 克隆和推送
- [GitCloneOption](symbols/GitCloneOption.md)（枚举） — Sources/SwiftGit/options/git-clone-options.swift
- [CloneOptions](symbols/CloneOptions.md)（枚举） — Sources/SwiftGit/options/git-clone-options.swift（补充）
- [PushOptions](symbols/PushOptions.md)（枚举） — Sources/SwiftGit/options/git-push-options.swift
- [GitPushOption](symbols/GitPushOption.md)（枚举） — Sources/SwiftGit/options/git-push-options.swift

#### 日志和历史
- [GitLogOption](symbols/GitLogOption.md)（枚举） — Sources/SwiftGit/options/git-log-options.swift
- [GitSortKey](symbols/GitSortKey.md)（枚举） — Sources/SwiftGit/options/GitSortKey.swift - 排序键选项

#### 其他命令选项
- 位于 Sources/SwiftGit/options/ 目录下的其他 25+ 个选项类型，大多实现了 ExpressibleByStringLiteral，用于组合命令参数。

## Repository 扩展

### 功能扩展
- [Repository+Commit](../Repository.md#repository-扩展) - 提交相关操作
- [Repository+Diff](../Repository.md#repository-扩展) - 差异比较操作

## 测试

### 测试文件
- Tests/SwiftGitTests/ 中包含多个文件用于覆盖公共 API，重要文件：
  - IntegrationTests.swift - 集成测试
  - ParseTests.swift - 解析测试
  - CloneCommandTests.swift - 克隆命令测试
  - ShowCommitResultTests.swift - 提交详情测试

## 使用建议

### 示例生成优先级
1. **优先展示 async/await 版本** - 现代 Swift 并发模式
2. **展示 publisher 变体** - 当演示流式或非阻塞场景时
3. **提供同步版本** - 用于向后兼容
4. **如需精确签名请打开具体命令文件** - 获取最新 API

### 文档结构
- 每个符号都有独立的详细文档文件
- 包含可运行的 Swift 示例
- 提供环境要求和使用注意事项
- 支持快速参考和深入理解

### 文档链接
所有符号文档都在 [symbols/](./symbols/) 目录下，支持交叉引用和快速导航。
