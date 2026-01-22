# GitError

声明
`public enum GitError: Error, LocalizedError`

位置
Sources/SwiftGit/Custom/GitError.swift

简介
定义库级别的错误类型，并实现 LocalizedError 以提供友好的错误描述与错误代码。

示例（错误处理）
```swift
do {
    let git = try Git(environment: .shared)
    _ = try await git.run(["nonexistent-command"])
} catch let err as GitError {
    print("GitError: \(err.localizedDescription)")
} catch {
    print("Other error: \(error)")
}
```
