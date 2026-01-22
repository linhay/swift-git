# GitStatusOption 枚举

GitStatusOption 提供了 Git status 命令的各种输出格式和选项配置。

## 声明位置
`Sources/SwiftGit/options/git-status-options.swift`

## 概述
GitStatusOption 遵循 GitOptions 协议，用于配置 Git status 命令的输出格式、文件过滤和行为。

## 主要选项类型

### 输出格式选项
- `porcelain` - 机器可读的简化格式
- `short` - 短格式输出
- `long` - 长格式输出（默认）
- `branch` - 显示分支和跟踪信息

### 文件过滤选项
- `untrackedFiles(String)` - 未跟踪文件显示模式
- `ignored(String)` - 忽略文件显示模式
- `ignoredMode(String)` - 忽略文件处理模式

### 信息控制选项
- `showStash` - 显示 stash 信息
- `noAheadBehind` - 不显示领先/落后信息
- `renames` - 检测重命名
- `noRenames` - 不检测重命名

## 使用示例

### 基本状态检查
```swift
import SwiftGit

// 简化格式输出（推荐用于脚本）
let statusOptions: [GitStatusOption] = [
    .porcelain,
    .untrackedFiles("normal") // 显示未跟踪文件
]

let git = try Git.shared
let repo = git.repository(at: ".")
let status = try await repo.run(statusOptions)
```

### 详细状态信息
```swift
let detailedOptions = [
    .long,           // 长格式
    .branch,         // 显示分支信息
    .showStash       // 显示 stash 状态
]

let detailedStatus = try await repo.run(detailedOptions)
```

### 脚本友好的输出
```swift
let scriptOptions = [
    .porcelain,              // 稳定的机器可读格式
    .untrackedFiles("no"),   // 不显示未跟踪文件
    .ignored("matching")     // 显示匹配的忽略文件
]

let scriptStatus = try await repo.run(scriptOptions)
// 输出格式: M  file1.swift
//            ?? new_file.swift
//            !! ignored_file.txt
```

### 检查特定文件状态
```swift
// 只关心已修改的文件
let modifiedOptions = [
    .porcelain,
    .untrackedFiles("no"),
    .ignored("no")
]

let modifiedStatus = try await repo.run(modifiedOptions)
```

### 显示分支跟踪信息
```swift
let branchOptions = [
    .branch,
    .porcelain
]

let branchStatus = try await repo.run(branchOptions)
// 输出可能包含: ## main...origin/main [ahead 2, behind 1]
```

### 重命名检测控制
```swift
let renameOptions = [
    .porcelain,
    .renames  // 启用重命名检测（通常默认启用）
]

let renameStatus = try await repo.run(renameOptions)
```

### 过滤未跟踪文件
```swift
// 不显示任何未跟踪文件
let noUntrackedOptions = [
    .porcelain,
    .untrackedFiles("no")
]

// 只显示目录中的未跟踪文件
let dirUntrackedOptions = [
    .porcelain,
    .untrackedFiles("dir")
]

// 显示所有未跟踪文件
let allUntrackedOptions = [
    .porcelain,
    .untrackedFiles("all")
]
```

### 忽略文件处理
```swift
// 显示匹配 .gitignore 的文件
let ignoredOptions = [
    .porcelain,
    .ignored("matching")
]

// 显示传统的忽略文件
let traditionalIgnoredOptions = [
    .porcelain,
    .ignored("traditional")
]

// 不显示忽略文件
let noIgnoredOptions = [
    .porcelain,
    .ignored("no")
]
```

### 组合选项使用
```swift
class StatusChecker {
    enum CheckMode {
        case quick      // 快速检查
        case detailed   // 详细信息
        case script     // 脚本使用
        case clean      // 检查是否干净
    }
    
    static func options(for mode: CheckMode) -> [GitStatusOption] {
        switch mode {
        case .quick:
            return [.porcelain, .untrackedFiles("no")]
        case .detailed:
            return [.long, .branch, .showStash]
        case .script:
            return [.porcelain, .untrackedFiles("normal")]
        case .clean:
            return [.porcelain, .untrackedFiles("no"), .ignored("no")]
        }
    }
}

// 使用
let options = StatusChecker.options(for: .script)
let status = try await repo.run(options)
```

### 状态解析辅助
```swift
extension String {
    var isCleanStatus: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var hasUntrackedFiles: Bool {
        return self.contains("??")
    }
    
    var hasModifiedFiles: Bool {
        return self.contains(" M") || self.contains(" M")
    }
}

// 使用
let porcelainOutput = try await repo.run([
    GitStatusOption.porcelain,
    GitStatusOption.untrackedFiles("normal")
])

if porcelainOutput.isCleanStatus {
    print("工作目录干净")
} else {
    print("有待处理的变更")
    if porcelainOutput.hasUntrackedFiles {
        print("包含未跟踪文件")
    }
    if porcelainOutput.hasModifiedFiles {
        print("包含已修改文件")
    }
}
```

## 环境要求
- 有效的 Git 仓库
- Git 版本支持所选的输出格式

## 特点
- 多种输出格式适应不同使用场景
- 灵活的文件过滤选项
- 支持脚本友好的机器可读格式

## 最佳实践
1. 脚本使用时优先选择 porcelain 格式
2. 交互式显示时可使用 long 格式
3. 根据需要控制未跟踪文件显示以减少输出
4. CI/CD 中建议使用稳定的格式组合

## 注意事项
- porcelain 格式是专门为脚本设计的，版本间兼容性较好
- long 格式在 Git 版本间可能有变化
- untrackedFiles 选项影响性能，大型仓库中建议限制显示
- 某些选项组合可能产生冗余信息

## 输出格式说明

### Porcelain 格式
```
XY file1
XY file2
?? untracked
!! ignored
```
- X: 索引状态
- Y: 工作目录状态
- ??: 未跟踪文件
- !!: 忽略文件

### 状态字符
- ` `: 未修改
- `M`: 已修改
- `A`: 已添加
- `D`: 已删除
- `R`: 已重命名
- `C`: 已复制
- `U`: 未合并
- `?`: 未跟踪
- `!`: 忽略