# UntrackedFilesMode

声明
`public enum UntrackedFilesMode: String`

位置
Sources/SwiftGit/Custom/models/UntrackedFilesMode.swift

简介
用于控制未跟踪文件显示行为（例如 all、normal、no），作为 `git status` 选项的封装。

示例
```swift
let mode: UntrackedFilesMode = .all
```
