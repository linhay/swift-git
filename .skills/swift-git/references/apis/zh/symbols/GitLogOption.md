# GitLogOption 枚举

GitLogOption 提供了 Git log 命令的各种显示格式和过滤选项。

## 声明位置
`Sources/SwiftGit/options/git-log-options.swift`

## 概述
GitLogOption 遵循 GitOptions 协议，用于配置 Git log 命令的输出格式、提交范围、过滤条件等。

## 主要选项类型

### 输出格式选项
- `oneline` - 单行格式显示
- `graph` - 显示提交图形
- `decorate` - 显示分支和标签信息
- `patch` - 显示补丁内容
- `stat` - 显示统计信息

### 提交限制选项
- `maxCount(Int)` - 限制显示提交数
- `since(String)` - 起始时间
- `until(String)` - 结束时间
- `author(String)` - 作者过滤
- `committer(String)` - 提交者过滤

### 内容过滤选项
- `grep(String)` - 搜索提交消息
- `grep(String)` - 搜索提交内容
- `pathspec(String)` - 路径过滤

### 排序选项
- `reverse` - 反向排序
- `dateOrder` - 按日期排序
- `authorDateOrder` - 按作者日期排序
- `topoOrder` - 拓扑排序

## 使用示例

### 基本日志查看
```swift
import SwiftGit

// 单行格式显示最近 10 个提交
let logOptions: [GitLogOption] = [
    .oneline,
    .maxCount(10)
]

let git = try Git.shared
let repo = git.repository(at: ".")
let logOutput = try await repo.run(logOptions)
```

### 图形化显示
```swift
// 带图形的分支历史
let graphOptions = [
    .oneline,
    .graph,
    .decorate,
    .maxCount(20)
]

let graphLog = try await repo.run(graphOptions)
// 输出示例: * a1b2c3d (HEAD -> main) feat: new feature
//          * e4f5g6h (origin/main) fix: bug fix
//          | * i7j8k9l (feature-branch) feat: another feature
//          |/
//          * m0n1o2p docs: update readme
```

### 详细提交信息
```swift
// 显示完整的提交详情
let detailedOptions = [
    .patch,
    .stat,
    .maxCount(3)
]

let detailedLog = try await repo.run(detailedOptions)
```

### 按作者过滤
```swift
// 查看特定作者的提交
let authorOptions = [
    .oneline,
    .author("John Doe <john@example.com>"),
    .since("2023-01-01"),
    .until("2023-12-31")
]

let authorLog = try await repo.run(authorOptions)
```

### 按提交消息搜索
```swift
// 搜索包含特定关键词的提交
let searchOptions = [
    .oneline,
    .grep("fix"),
    .grep("bug"),
    .maxCount(15)
]

let searchLog = try await repo.run(searchOptions)
```

### 路径特定日志
```swift
// 查看特定文件的修改历史
let fileHistoryOptions = [
    .oneline,
    .pathspec("src/main.swift"),
    .patch
]

let fileLog = try await repo.run(fileHistoryOptions)

// 查看目录的修改历史
let dirHistoryOptions = [
    .oneline,
    .pathspec("docs/"),
    .maxCount(10)
]

let dirLog = try await repo.run(dirHistoryOptions)
```

### 时间范围查询
```swift
// 最近一周的提交
let recentOptions = [
    .oneline,
    .since("1 week ago"),
    .authorDateOrder
]

let recentLog = try await repo.run(recentOptions)

// 特定时间范围的提交
let dateRangeOptions = [
    .oneline,
    .since("2023-06-01"),
    .until("2023-06-30"),
    .decorate
]

let rangeLog = try await repo.run(dateRangeOptions)
```

### 合并提交过滤
```swift
// 只显示合并提交
let mergeOptions = [
    .oneline,
    .merges,
    .graph,
    .maxCount(10)
]

let mergeLog = try await repo.run(mergeOptions)

// 不显示合并提交
let noMergeOptions = [
    .oneline,
    .noMerges,
    .maxCount(20)
]

let noMergeLog = try await repo.run(noMergeOptions)
```

### 分支比较
```swift
// 显示两个分支间的差异
let branchDiffOptions = [
    .oneline,
    .leftRight,
    .graph,
    .patch, // 可选：显示具体差异
    .maxCount(10)
]

let branchLog = try await repo.run(["log", "main...feature", "--oneline", "--graph"])
```

### 自定义格式
```swift
// 使用自定义格式显示
let formatOptions = [
    .format("%h - %an, %ar : %s"),
    .maxCount(5)
]

let customLog = try await repo.run([
    "log",
    "--pretty=format:%h - %an, %ar : %s",
    "-5"
])
```

### 日志统计分析
```swift
class GitLogAnalyzer {
    static func getCommitStats(repo: Repository, since: String? = nil) async throws -> CommitStats {
        let options: [GitLogOption] = [
            .format("%h|%an|%ad|%s"),
            .since(since ?? "1 year ago"),
            .dateOrder
        ]
        
        let output = try await repo.run(options)
        let lines = output.split(separator: "\n")
        
        var stats = CommitStats()
        for line in lines {
            let parts = line.split(separator: "|", maxSplits: 3)
            guard parts.count == 4 else { continue }
            
            let author = String(parts[1])
            let message = String(parts[3])
            
            stats.totalCommits += 1
            stats.authors[author, default: 0] += 1
            
            if message.contains("fix") || message.contains("bug") {
                stats.bugFixes += 1
            }
            if message.contains("feat") || message.contains("feature") {
                stats.features += 1
            }
        }
        
        return stats
    }
}

struct CommitStats {
    var totalCommits: Int = 0
    var authors: [String: Int] = [:]
    var bugFixes: Int = 0
    var features: Int = 0
    
    var topAuthor: (name: String, count: Int)? {
        return authors.max { $0.value < $1.value }
    }
}

// 使用
let stats = try await GitLogAnalyzer.getCommitStats(
    repo: repo,
    since: "3 months ago"
)
print("总提交数: \(stats.totalCommits)")
print("最活跃作者: \(stats.topAuthor?.name ?? "无")")
```

### 分支可视化
```swift
// 创建分支历史可视化
let visualOptions = [
    .graph,
    .decorate,
    .oneline,
    .abbrevCommit,
    .maxCount(30)
]

let visualLog = try await repo.run(visualOptions)
```

### 性能优化的日志查询
```swift
enum LogStrategy {
    case quick      // 快速概览
    case detailed   // 详细信息
    analysis      // 分析用途
    presentation // 展示用途
    
    var options: [GitLogOption] {
        switch self {
        case .quick:
            return [.oneline, .maxCount(10)]
        case .detailed:
            return [.patch, .stat, .maxCount(5)]
        case .analysis:
            return [.format("%H|%an|%ad|%f"), .since("1 year ago")]
        case .presentation:
            return [.graph, .decorate, .oneline, .maxCount(50)]
        }
    }
}

// 使用
let strategy = LogStrategy.presentation
let presentationLog = try await repo.run(strategy.options)
```

## 环境要求
- 有效的 Git 仓库
- 仓库中有提交历史

## 特点
- 丰富的显示格式选项
- 灵活的过滤机制
- 支持统计分析
- 适用于不同使用场景

## 最佳实践
1. 快速查看使用 oneline 格式
2. 分支历史使用 graph 选项
3. 分析时使用自定义格式
4. 大型仓库限制显示数量
5. 结合过滤选项提高查询效率

## 注意事项
- 大型仓库的完整日志查询可能很慢
- 某些选项组合可能冲突
- 日期格式需要符合 Git 的规范
- 复杂查询可能影响性能

## 常用选项组合

### 开发日常查看
```swift
let dailyOptions = [
    .oneline,
    .graph,
    .decorate,
    .maxCount(20),
    .since("yesterday")
]
```

### 代码审查
```swift
let reviewOptions = [
    .patch,
    .stat,
    .maxCount(5)
]
```

### 发布准备
```swift
let releaseOptions = [
    .oneline,
    .grep("feat\\|fix\\|docs"),
    .since("last-release-tag"),
    .decorate
]
```