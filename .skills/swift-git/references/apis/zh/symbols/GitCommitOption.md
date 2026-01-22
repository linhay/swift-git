# GitCommitOption 枚举

GitCommitOption 提供了 Git commit 命令的各种选项配置。

## 声明位置
`Sources/SwiftGit/options/git-commit-options.swift`

## 概述
GitCommitOption 遵循 GitOptions 协议，提供类型安全的 Git commit 命令选项构建。

## 主要选项类型

### 基本提交选项
- 各种提交相关的配置选项
- 消息、作者、签名等设置

## 使用示例

### 基本提交
```swift
import SwiftGit

let options: [GitCommitOption] = [
    .message("Initial commit"),
    .allowEmpty
]

let git = try Git.shared
let repo = git.repository(at: ".")
try await repo.run(options)
```

### 带作者信息的提交
```swift
let commitOptions = [
    GitCommitOption.message("Feature implementation"),
    GitCommitOption.author("John Doe <john@example.com>"),
    GitCommitOption.date("2023-01-01T12:00:00Z")
]

try await repo.run(commitOptions)
```

### 修改提交
```swift
let amendOptions = [
    GitCommitOption.amend,
    GitCommitOption.noEdit, // 不修改提交消息
    GitCommitOption.allowEmpty
]

try await repo.run(amendOptions)
```

### 签名提交
```swift
let signedOptions = [
    GitCommitOption.message("Signed commit"),
    GitCommitOption.gpgSign,
    GitCommitOption.signoff
]

try await repo.run(signedOptions)
```

## 环境要求
- 有效的 Git 仓库
- 已暂存的文件（或使用 --allow-empty）
- 对于 GPG 签名需要配置 GPG 密钥

## 注意事项
- 提交消息长度限制
- 签名需要额外配置
- 某些选项可能不兼容