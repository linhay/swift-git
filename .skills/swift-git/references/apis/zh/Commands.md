# Commands（命令帮助）

说明
- Sources/SwiftGit/Custom/commands/ 下的文件每个都封装了一组 git 子命令的 helper。下面列出主要文件及其职责（选取性）：

文件与职责
- git-commands-clone.swift — clone 相关 helper 与 CloneOptions
- git-commands-pull.swift — pull helper 与 PullOptions（包含进度回调）
- git-commands-commit.swift — commit helper 与 CommitOptions
- git-commands-status.swift — status helper 与 StatusOptions
- git-commands-log.swift — log helper 与 LogOptions
- git-commands-push.swift — push helper 与 PushOptions
- git-commands-fetch.swift — fetch helper
- git-commands-tag.swift — tag helper
- git-commands-stash.swift — stash helper（多达 12 个方法）

生成文档提示
- 要获取精确签名，打开对应文件并提取函数签名（publisher / async / sync 三种变体）。
- 在示例中优先展示 async 变体（async/await）与同步变体的使用场景。
