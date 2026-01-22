# GitCloneOption 枚举

GitCloneOption 提供了 Git clone 命令的各种配置选项。

## 声明位置
`Sources/SwiftGit/options/git-clone-options.swift`

## 概述
GitCloneOption 遵循 GitOptions 协议，用于配置 Git clone 命令的行为，包括浅克隆、分支选择、递归克隆等。

## 主要选项类型

### 克隆配置选项
- `depth(Int)` - 浅克隆深度
- `branch(String)` - 指定克隆分支
- `singleBranch` - 只克隆指定分支
- `noCheckout` - 不检出文件
- `bare` - 创建裸仓库

### 网络和传输选项
- `recursive` - 递归克隆子模块
- `recurseSubmodules` - 递归子模块选项
- `shallowSubmodules` - 浅克隆子模块
- `noShallowSubmodules` - 不浅克隆子模块

### 配置和路径选项
- `origin(String)` - 设置远程仓库名称
- `template(String)` - 使用模板目录
- `reference(String)` - 使用参考仓库

## 使用示例

### 基本克隆
```swift
import SwiftGit

// 基本克隆（使用默认选项）
let cloneOptions: [GitCloneOption] = []

let git = try Git.shared
// 注意：通常克隆操作在新的空目录中进行
// let repo = try await git.clone(from: "https://github.com/user/repo.git", to: "/path/to/target")
```

### 浅克隆
```swift
// 只克隆最近 10 个提交
let shallowOptions = [
    GitCloneOption.depth(10),
    GitCloneOption.singleBranch
]

// 克隆指定分支的浅版本
let branchShallowOptions = [
    GitCloneOption.depth(5),
    GitCloneOption.branch("develop")
]
```

### 递归克隆
```swift
// 克隆包含所有子模块的仓库
let recursiveOptions = [
    GitCloneOption.recursive,
    GitCloneOption.branch("main")
]

// 带子模块配置的克隆
let submoduleOptions = [
    GitCloneOption.recurseSubmodules,
    GitCloneOption.shallowSubmodules
]
```

### 裸仓库克隆
```swift
// 创建裸仓库（用于镜像）
let bareOptions = [
    GitCloneOption.bare,
    GitCloneOption.origin("mirror")
]
```

### 不检出克隆
```swift
// 只获取仓库历史，不检出工作文件
let noCheckoutOptions = [
    GitCloneOption.noCheckout,
    GitCloneOption.depth(1)
]
```

### 分支特定克隆
```swift
// 只克隆特定分支
let branchOnlyOptions = [
    GitCloneOption.branch("feature/new-api"),
    GitCloneOption.singleBranch
]

// 克隆多个指定分支需要额外步骤
let multiBranchOptions = [
    GitCloneOption.depth(100) // 先浅克隆
]
```

### 使用参考仓库
```swift
// 使用现有仓库作为参考以节省时间和空间
let referenceOptions = [
    GitCloneOption.reference("/path/to/reference/repo"),
    GitCloneOption.branch("main")
]
```

### 模板克隆
```swift
// 使用自定义模板目录
let templateOptions = [
    GitCloneOption.template("/path/to/template"),
    GitCloneOption.origin("custom-origin")
]
```

### 高级配置克隆
```swift
class CloneConfiguration {
    enum CloneType {
        case full
        case shallow(Int)
        case bare
        case mirror
        case workspace
    }
    
    static func options(for type: CloneType, branch: String? = nil) -> [GitCloneOption] {
        var options: [GitCloneOption] = []
        
        switch type {
        case .full:
            // 完整克隆，无需特殊选项
            break
        case .shallow(let depth):
            options.append(.depth(depth))
            if branch != nil {
                options.append(.singleBranch)
            }
        case .bare:
            options.append(.bare)
            options.append(.origin("origin"))
        case .mirror:
            options.append(.bare)
            options.append(.origin("origin"))
            options.append(.mirror) // 如果支持
        case .workspace:
            options.append(.depth(1))
            options.append(.noCheckout)
        }
        
        if let branch = branch {
            options.append(.branch(branch))
        }
        
        return options
    }
}

// 使用
let featureOptions = CloneConfiguration.options(
    for: .shallow(50),
    branch: "feature/new-api"
)
```

### 克隆策略选择
```swift
enum CloneStrategy {
    case development    // 开发使用，需要完整历史
    case deployment    // 部署使用，只需要最新代码
    case ci           // CI 使用，浅克隆提高速度
    case mirror       // 镜像使用，裸仓库
    
    var options: [GitCloneOption] {
        switch self {
        case .development:
            return [.recursive]
        case .deployment:
            return [.depth(1), .singleBranch, .branch("main")]
        case .ci:
            return [.depth(10), .noCheckout]
        case .mirror:
            return [.bare, .origin("origin")]
        }
    }
}

// 使用
let devOptions = CloneStrategy.development.options
let ciOptions = CloneStrategy.ci.options
```

### 克隆验证和重试
```swift
class GitCloner {
    static func cloneWithRetry(
        from url: String,
        to path: String,
        options: [GitCloneOption],
        maxRetries: Int = 3
    ) async throws {
        var attempts = 0
        
        while attempts < maxRetries {
            do {
                let git = try Git.shared
                // 实际克隆操作需要根据具体实现调整
                // try await git.clone(from: url, to: path, options: options)
                print("克隆成功")
                return
            } catch {
                attempts += 1
                print("克隆失败 (尝试 \(attempts)/\(maxRetries)): \(error)")
                
                if attempts < maxRetries {
                    // 清理可能的部分克隆
                    try? FileManager.default.removeItem(atPath: path)
                    
                    // 指数退避
                    let delay = pow(2.0, Double(attempts))
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
        }
        
        throw CloneError.maxRetriesExceeded
    }
}

enum CloneError: Error {
    case maxRetriesExceeded
}
```

## 环境要求
- 网络连接（除非使用本地路径）
- 目标目录的写入权限
- 足够的磁盘空间

## 特点
- 灵活的克隆配置选项
- 支持浅克隆以节省时间和空间
- 完整的子模块支持
- 适合不同使用场景的策略

## 最佳实践
1. CI/CD 环境使用浅克隆提高速度
2. 开发环境通常需要完整历史
3. 镜像和备份使用裸仓库
4. 大型仓库考虑使用参考仓库
5. 根据网络条件选择合适的深度

## 注意事项
- 浅克隆可能限制某些 Git 操作
- 某些选项可能不兼容
- 子模块克隆可能显著增加时间和空间消耗
- 网络不稳定时考虑实现重试机制

## 常用选项组合

### 快速 CI 克隆
```swift
let ciOptions = [
    GitCloneOption.depth(1),
    GitCloneOption.singleBranch,
    GitCloneOption.branch("main"),
    GitCloneOption.noCheckout
]
```

### 完整开发克隆
```swift
let devOptions = [
    GitCloneOption.recursive,
    GitCloneOption.branch("develop")
]
```

### 生产部署克隆
```swift
let prodOptions = [
    GitCloneOption.depth(5),
    GitCloneOption.singleBranch,
    GitCloneOption.branch("release"),
    GitCloneOption.recurseSubmodules
]
```