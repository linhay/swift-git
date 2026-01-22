# GitOptions 协议

GitOptions 协议定义了 Git 命令选项的通用接口，所有具体的 Git 选项类型都遵循此协议。

## 声明位置
遍布 `Sources/SwiftGit/options/` 目录下的各个文件

## 概述
GitOptions 协议为所有 Git 命令选项提供统一的接口，允许类型安全的命令构建和执行。

## 协议要求

### 主要属性
- `var rawValue: String { get }` - 选项的原始命令行表示

## 使用示例

### 基本使用
```swift
import SwiftGit

// 假设有具体的选项类型
let options: [GitOptions] = [
    SomeGitOption.value1,
    SomeGitOption.value2
]

// 通过 Git 实例执行
let git = try Git.shared
let result = try await git.run(options)
```

### 命令构建
```swift
// 组合多个选项
let commitOptions: [GitOptions] = [
    GitCommitOption.message("Initial commit"),
    GitCommitOption.allowEmpty,
    GitCommitOption.author("John Doe <john@example.com>")
]

let git = try Git.shared
let repo = git.repository(at: ".")
try await repo.run(commitOptions)
```

## 常见 GitOptions 实现

### Commit 选项
- `GitCommitOption` - 提交相关选项
- `message(String)` - 提交消息
- `allowEmpty` - 允许空提交
- `amend` - 修正最后一次提交

### Status 选项
- `GitStatusOption` - 状态相关选项
- `porcelain` - 简化输出格式
- `short` - 短格式输出
- `long` - 长格式输出

### Clone 选项
- `GitCloneOption` - 克隆相关选项
- `depth(Int)` - 浅克隆深度
- `branch(String)` - 指定分支
- `recursive` - 递归克隆子模块

### Log 选项
- `GitLogOption` - 日志相关选项
- `oneline` - 单行格式
- `graph` - 图形化显示
- `maxCount(Int)` - 最大提交数

## 扩展自定义选项

### 创建自定义选项
```swift
struct CustomGitOption: GitOptions {
    let rawValue: String
    
    init(flag: String) {
        self.rawValue = flag
    }
    
    static func customFlag(_ flag: String) -> CustomGitOption {
        return CustomGitOption(flag: "--\(flag)")
    }
}

// 使用
let customOptions = [
    CustomGitOption.customFlag("force"),
    CustomGitOption.customFlag("verbose")
]
```

### 选项组合
```swift
extension Array where Element == GitOptions {
    func toStringArray() -> [String] {
        return self.map(\.rawValue)
    }
    
    func joined() -> String {
        return toStringArray().joined(separator: " ")
    }
}
```

## 实际应用场景

### 批量操作
```swift
// 为多个仓库应用相同选项
let baseOptions: [GitOptions] = [
    GitStatusOption.porcelain,
    GitStatusOption.untrackedFiles("all")
]

let repositories = [repo1, repo2, repo3]

for repo in repositories {
    let status = try await repo.run(baseOptions)
    print("仓库 \(repo.localURL): \(status)")
}
```

### 条件选项构建
```swift
func buildStatusOptions(includeUntracked: Bool, format: StatusFormat) -> [GitOptions] {
    var options: [GitOptions] = []
    
    switch format {
    case .porcelain:
        options.append(GitStatusOption.porcelain)
    case .short:
        options.append(GitStatusOption.short)
    case .long:
        options.append(GitStatusOption.long)
    }
    
    if includeUntracked {
        options.append(GitStatusOption.untrackedFiles("all"))
    }
    
    return options
}
```

### 动态选项组合
```swift
class GitCommandBuilder {
    private var options: [GitOptions] = []
    
    func add(_ option: GitOptions) -> Self {
        options.append(option)
        return self
    }
    
    func addIf(_ condition: Bool, _ option: GitOptions) -> Self {
        if condition {
            options.append(option)
        }
        return self
    }
    
    func build() -> [GitOptions] {
        return options
    }
}

// 使用
let commandOptions = GitCommandBuilder()
    .add(GitCommitOption.message("Auto commit"))
    .addIf(isVerbose, GitLogOption.verbose)
    .addIf(forcePush, GitPushOption.force)
    .build()
```

## 环境要求
- 无特殊要求，协议定义是纯接口

## 特点
- 类型安全的选项构建
- 统一的接口设计
- 易于扩展和维护
- 支持选项的动态组合

## 最佳实践
1. 为每种 Git 命令创建专门的选项类型
2. 使用工厂方法创建常用选项组合
3. 考虑选项的顺序和兼容性
4. 为复杂选项提供文档和使用示例
5. 验证选项组合的有效性

## 注意事项
- 不同选项之间可能存在冲突，需要特别注意
- 选项的 rawValue 应该符合 Git 命令行规范
- 某些选项可能需要特定的参数格式
- 考虑 Git 版本兼容性问题