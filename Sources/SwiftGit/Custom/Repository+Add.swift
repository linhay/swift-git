//
//  File.swift
//  
//
//  Created by linhey on 2022/5/2.
//

import Foundation

public extension Repository {
    
    func add(options: [AddOptions] = [], _ paths: [String]) throws {
        try run(["add"] + options.map(\.rawValue) + paths)
    }
    
    func add(options: [AddOptions] = [], _ paths: String...) throws {
        try add(options: options, paths)
    }
    
}


public struct AddOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension AddOptions {
    
    /// 冗余模式。
    static let verbose: AddOptions = "--verbose"
    
    /// 实际上不添加文件，仅展示文件是否存在或是否忽略。
    static let dryRun: AddOptions = "--dry-run"
    
    /// 允许添加已被忽略的文件。
    static let force: AddOptions = "--force"
    
    /// 以交互方式将工作树中的修改内容添加到索引。可以提供可选的路径参数，以将操作限制为工作树的子集。有关详细信息，请参见`‘交互模式’'。
    static let interactive: AddOptions = "--interactive"
    
    /// 交互地在索引和工作树之间选择补丁块并将它们添加到索引中。这让用户有机会在将修改后的内容添加到索引之前查看差异。这可以有效地运行 add --interactive，但是会绕过初始命令菜单，而直接跳转到 patch 子命令。有关详细信息，请参见`‘交互模式’'。
    static let patch: AddOptions = "--patch"
    
    /// 在编辑器中打开与索引的差异，使用户进行编辑。关闭编辑器后，调整块补丁头并将其应用于索引。此选项的目的是选择并选择要应用的补丁的行，甚至修改要暂存的行的内容。与使用交互式补丁块选择器相比，其更快，更灵活。但是，很容易混淆自己并创建不应用于索引的补丁。请参阅下面的编辑补丁。
    static let edit: AddOptions = "--edit"
    
    /// 在索引已经有与 <指定路径> 匹配项的地方更新索引。这会删除和修改索引项以匹配工作树，但不添加新文件。如果在使用 -u 选项时没有 <指定路径>，则整个工作树中的所有跟踪文件都将更新（旧版本 Git 会限制更新当前目录及其子目录）。
    static let update: AddOptions = "--update"
    
    /// 不仅在工作树中有与 <指定路径 >匹配的文件的地方更新索引，而且在索引中已经有一个项的地方更新索引。这将添加、修改和删除与工作树匹配的索引项。如果在使用 -A 选项时没有 <指定路径>，则整个工作树中的所有文件都将更新（旧版本的 Git 会限制当前目录及其子目录的更新）。
    static func ignoreRemoval(_ flag: Bool) -> AddOptions { flag ? "--ignore-removal" : "--no-ignore-removal" }
    static func all(_ flag: Bool) -> AddOptions { flag ? "--all" : "--no-all" }
    
    /// 只记录稍后将添加路径的事实。路径的项会被放置在索引中，但不包括改动的内容。这对于使用 git diff 显示文件的未暂存内容以及使 git commit -a 提交这些文件非常有用。
    static let intentToAdd: AddOptions = "--intent-to-add"
    
    /// 不添加文件，只刷新索引中的 stat() 信息。
    static let refresh: AddOptions = "--refresh"
    
    /// 如果由于索引错误而无法添加某些文件，请不要中止操作，而是继续添加其他文件。命令仍应以非零状态退出。可以将配置变量`add.ignoreErrors`设置为true，使其成为默认行为。
    static let ignoreErrors: AddOptions = "--ignore-errors"
    
    /// 此选项只能与—​dry-run一起使用。通过使用此选项，用户可以检查是否会忽略任何给定的文件，无论它们是否已存在于工作树中。
    static let ignoreMissing: AddOptions = "--ignore-missing"
    
    /// 默认情况下， git add 将在向索引添加嵌入式存储库时发出警告，而不使用 git submodule add 在 .gitmodules 中创建条目。此选项将抑制警告（例如，如果手动对子模块执行操作）。
    static let noWarnEmbeddedRepo: AddOptions = "--no-warn-embedded-repo"
    
    /// 对所有跟踪的文件应用`clean`过程，将它们再次强制添加到索引中。这在更改`core.autocrlf`配置或`text`属性以更正添加了错误CRLF/LF行结尾的文件后非常有用。此选项隐含`-u`选项。
    static let renormalize: AddOptions = "--renormalize"
    
    /// Pathspec在 <file> 中传递，而不是在命令行参数中传递。如果 <file> 正好是 -，则使用标准输入。Pathspec 元素由 LF 或 CR/LF 分隔。可以引用配置变量 core.quotePath 的 Pathspec 元素（请参见 linkgit:git config[1]）。另请参见 --pathspec-file-nul `和全局 `--literal-pathspecs。
    static func pathspecFromFile(_ file: String) -> AddOptions {
        .init("--pathspec-from-file=\(file)")
    }
    
    /// 只有在使用 --pathspec-from-file 时才有意义。指定路径元素用 NUL 字符分隔，所有其他字符都按字面意思（包括换行符和引号）表示。
    static let pathspecFileNul: AddOptions = "--pathspec-file-nul"
    
    // --chmod=(+|-)x
    // 重写添加文件的可执行位。可执行位仅在索引中更改，磁盘上的文件保持不变。
    
    
}
