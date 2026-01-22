# GitPushOption 枚举

GitPushOption 提供了 Git push 命令的各种配置选项。

## 声明位置
`Sources/SwiftGit/options/git-push-options.swift`

## 概述
GitPushOption 遵循 GitOptions 协议，用于配置 Git push 命令的行为，包括强制推送、分支设置、删除操作等。

## 主要选项类型

### 基本推送选项
- 各种推送相关的配置选项
- 远程仓库和分支设置

### 安全和强制选项
- `force` - 强制推送
- `forceWithLease` - 使用租约强制推送
- `delete` - 删除远程分支
- `mirror` - 镜像推送

### 配置选项
- `setUpstream` - 设置上游分支
- `noVerify` - 跳过推送前检查
- `dryRun` - 预演推送

## 使用示例

### 基本推送
```swift
import SwiftGit

// 推送到默认远程仓库
let pushOptions: [GitPushOption] = [
    .setUpstream  // 设置上游分支跟踪
]

let git = try Git.shared
let repo = git.repository(at: ".")
try await repo.run(pushOptions)
```

### 强制推送
```swift
// 安全的强制推送
let forceWithLeaseOptions = [
    GitPushOption.forceWithLease
]

// 危险的强制推送
let forceOptions = [
    GitPushOption.force
]
```

### 删除远程分支
```swift
// 删除远程分支
let deleteOptions = [
    GitPushOption.delete
]

try await repo.run(["push", "origin", "--delete", "feature-branch"])
```

### 镜像推送
```swift
// 推送所有引用
let mirrorOptions = [
    GitPushOption.mirror,
    GitPushOption.force
]

try await repo.run(["push", "origin", "--mirror"])
```

### 预演推送
```swift
// 查看将要推送的内容
let dryRunOptions = [
    GitPushOption.dryRun,
    GitPushOption.verbose
]

let preview = try await repo.run(dryRunOptions)
```

### 设置上游分支
```swift
// 首次推送并设置跟踪
let setUpstreamOptions = [
    GitPushOption.setUpstream
]

try await repo.run(["push", "-u", "origin", "new-branch"])
```

### 推送标签
```swift
// 推送标签
let tagOptions = [
    GitPushOption.tags
]

try await repo.run(["push", "origin", "--tags"])
```

### 推送策略选择
```swift
enum PushStrategy {
    case safe          // 安全推送
    case forceIfNeeded // 必要时强制
    case mirror        // 镜像推送
    case dryRun        // 预演推送
    
    var options: [GitPushOption] {
        switch self {
        case .safe:
            return [.setUpstream]
        case .forceIfNeeded:
            return [.forceWithLease]
        case .mirror:
            return [.mirror, .force]
        case .dryRun:
            return [.dryRun, .verbose]
        }
    }
}

// 使用
let strategy = PushStrategy.safe
let options = strategy.options
```

### 推送验证和检查
```swift
class PushValidator {
    static func canPushSafely(
        to remote: String,
        branch: String,
        repo: Repository
    ) async throws -> Bool {
        // 检查远程分支是否存在
        do {
            let remoteBranch = "\(remote)/\(branch)"
            _ = try await repo.run(["rev-parse", "--verify", remoteBranch])
            
            // 远程分支存在，检查是否可以快进
            let local = try await repo.run(["rev-parse", branch])
            let remote = try await repo.run(["rev-parse", remoteBranch])
            
            let mergeBase = try await repo.run([
                "merge-base", local, remote
            ])
            
            return mergeBase.trimmingCharacters(in: .whitespacesAndNewlines) == remote.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            // 远程分支不存在，可以安全推送
            return true
        }
    }
    
    static func pushWithValidation(
        to remote: String,
        branch: String,
        repo: Repository,
        forceIfAllowed: Bool = false
    ) async throws {
        let canPush = try await canPushSafely(to: remote, branch: branch, repo: repo)
        
        if !canPush && !forceIfAllowed {
            throw PushError.nonFastForward
        }
        
        let options = canPush ? 
            [GitPushOption.setUpstream] : 
            [GitPushOption.forceWithLease]
        
        try await repo.run(["push", remote, branch])
    }
}

enum PushError: Error {
    case nonFastForward
}
```

### 推送进度监控
```swift
class PushProgress {
    var totalObjects: Int = 0
    var indexedObjects: Int = 0
    var receivedObjects: Int = 0
    
    func parseProgressLine(_ line: String) {
        if line.contains("Counting objects") {
            // 解析对象计数
        } else if line.contains("Writing objects") {
            // 解析写入进度
        }
        print("进度: \(line)")
    }
}
```

### 多远程推送
```swift
class MultiRemotePusher {
    static func pushToAllRemotes(
        branch: String,
        repo: Repository,
        except excludedRemotes: [String] = []
    ) async throws -> [String: Error?] {
        // 获取所有远程仓库
        let remotesOutput = try await repo.run(["remote"])
        let remotes = remotesOutput
            .split(separator: "\n")
            .map(String.init)
            .filter { !$0.isEmpty && !excludedRemotes.contains($0) }
        
        var results: [String: Error?] = [:]
        
        for remote in remotes {
            do {
                try await repo.run(["push", remote, branch])
                results[remote] = nil
            } catch {
                results[remote] = error
            }
        }
        
        return results
    }
}

// 使用
let results = try await MultiRemotePusher.pushToAllRemotes(
    branch: "main",
    repo: repo,
    except: ["backup-remote"]
)

for (remote, error) in results {
    if let error = error {
        print("推送到 \(remote) 失败: \(error)")
    } else {
        print("推送到 \(remote) 成功")
    }
}
```

### 推送前检查
```swift
class PrePushChecks {
    static func runAllChecks(repo: Repository) async throws {
        // 检查是否有未提交的更改
        let status = try await repo.run(["status", "--porcelain"])
        if !status.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw PrePushError.uncommittedChanges
        }
        
        // 检查 CI 状态
        try await checkCIStatus(repo: repo)
        
        // 检查分支保护
        try await checkBranchProtection(repo: repo)
    }
    
    private static func checkCIStatus(repo: Repository) async throws {
        // CI 检查逻辑
    }
    
    private static func checkBranchProtection(repo: Repository) async throws {
        // 分支保护检查逻辑
    }
}

enum PrePushError: Error {
    case uncommittedChanges
    case ciFailure
    case branchProtection
}
```

## 环境要求
- 远程仓库的访问权限
- 网络连接
- 适当的认证配置

## 特点
- 多种推送策略
- 安全检查选项
- 支持强制推送和删除操作
- 适用于不同推送场景

## 最佳实践
1. 优先使用 `forceWithLease` 而非 `force`
2. 首次推送时使用 `setUpstream`
3. 大型推送前使用 `dryRun` 预演
4. 实施推送前检查避免问题
5. 备份重要分支再强制推送

## 注意事项
- 强制推送可能覆盖远程历史
- 删除操作不可逆
- 需要适当的远程仓库权限
- 网络问题可能导致推送失败

## 常用选项组合

### 安全首次推送
```swift
let firstPushOptions = [
    GitPushOption.setUpstream,
    GitPushOption.dryRun  // 可选：先预演
]
```

### 常规更新推送
```swift
let updateOptions = [
    GitPushOption.setUpstream  // 如果需要设置跟踪
]
```

### 紧急修复推送
```swift
let hotfixOptions = [
    GitPushOption.forceWithLease,
    GitPushOption.noVerify      // 跳过某些检查
]
```