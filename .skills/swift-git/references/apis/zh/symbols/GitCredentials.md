# GitCredentials

声明
`public enum GitCredentials`

位置
Sources/SwiftGit/Custom/models/GitCredentials.swift

简介
表示凭据的不同形式，例如默认机制或明文用户名/密码组合，供克隆等网络操作使用。

示例
```swift
let creds = GitCredentials.plaintext(username: "me", password: "secret")
```
