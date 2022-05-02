//
//  File.swift
//  
//
//  Created by linhey on 2022/5/3.
//

import Foundation

public extension Repository {
    
    func commit(options: [AddOptions] = [], _ paths: [String]) throws {
        try run(["add"] + options.map(\.rawValue) + paths)
    }
    
    func commit(options: [AddOptions] = [], _ paths: String...) throws {
        try add(options: options, paths)
    }
    
}


public struct CommitOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension CommitOptions {

    /// 冗余模式。
    static let verbose: CommitOptions = "--verbose"
    /// 实际上不添加文件，仅展示文件是否存在或是否忽略。
    static let dryRun: CommitOptions = "--dry-run"
    /// be more quiet
    static let quiet: CommitOptions = "--quiet"
    static let all: CommitOptions = "--all"
    static let patch: CommitOptions = "--patch"
    static let resetAuthor: CommitOptions = "--reset-author"

    /// 以简短的形式给出输出。
    /// Give the output in the short-format.
    static let short: CommitOptions = "--short"
    
    /// 给出长格式的输出。这是默认的。
    /// Give the output in the long-format. This is the default.
    static let long: CommitOptions = "--long"
    
    /// 即使在短文中也要显示分支和跟踪信息。
    /// Show the branch and tracking info even in short-format.
    static let branch: CommitOptions = "--branch"
    
    /// 用NUL而不是LF来终止条目。 如果没有给出其他格式，这就意味着`--porcelain=v1`的输出格式。
    /// terminate entries with NUL
    static let null: CommitOptions = "--null"

    static let allowEmpty: CommitOptions = "--allow-empty"
    static let allowEmptyMessage: CommitOptions = "--allow-empty-message"
    static let amend: CommitOptions = "--amend"
    static let noPostRewrite: CommitOptions = "--no-post-rewrite"
    static let include: CommitOptions = "--include"
    static let only: CommitOptions = "--only"

    /**
     以易于解析的格式给出脚本的输出。 这类似于简短的输出，但在不同的Git版本中，无论用户配置如何，都会保持稳定。
     版本参数用于指定格式版本。 这是可选的，默认为原始版本的 "v1 "格式。
     Give the output in an easy-to-parse format for scripts. This is similar to the short output, but will remain stable across Git versions and regardless of user
     configuration. See below for details.
     The version parameter is used to specify the format version. This is optional and defaults to the original version v1 format.
     */
    static func porcelain(_ version: PorcelainMode) -> CommitOptions {
        .init(stringLiteral: "--porcelain=\(version.rawValue)")
    }
    
    static func reuseMessage(_ commit: String) -> CommitOptions {
        .init("--reuse-message=\(commit)")
    }
    
    static func reeditMessage(_ commit: String) -> CommitOptions {
        .init("--reedit-message=\(commit)")
    }
    
    static func squash(_ commit: String) -> CommitOptions {
        .init("--squash=\(commit)")
    }
    
    static func file(_ file: String) -> CommitOptions {
        .init("--file=\(file)")
    }
    
    static func author(_ author: String) -> CommitOptions {
        .init("--author=\(author)")
    }
    
    static func date(_ date: String) -> CommitOptions {
        .init("--date=\(date)")
    }
    
    static func message(_ message: String) -> CommitOptions {
        .init("--message=\(message)")
    }
    
    static func template(_ file: String) -> CommitOptions {
        .init("--template=\(file)")
    }
    
    enum Cleanup: String {
        /// Strip leading and trailing empty lines, trailing whitespace, commentary and collapse consecutive empty lines.
        case strip
        /// Same as strip except #commentary is not removed.
        case whitespace
        /// Do not change the message at all.
        case verbatim
        /** Same as whitespace except that everything from (and including) the line found below is truncated, if the message is to be edited. "#" can be customized with core.commentChar.
         # ------------------------ >8 ------------------------
         */
        case scissors
        /// Same as strip if the message is to be edited. Otherwise whitespace.
        case `default`
    }
    
    static func cleanup(_ mode: Cleanup) -> CommitOptions {
        .init("--cleanup=\(mode.rawValue)")
    }
    
    /// Pathspec在 <file> 中传递，而不是在命令行参数中传递。如果 <file> 正好是 -，则使用标准输入。Pathspec 元素由 LF 或 CR/LF 分隔。可以引用配置变量 core.quotePath 的 Pathspec 元素（请参见 linkgit:git config[1]）。另请参见 --pathspec-file-nul `和全局 `--literal-pathspecs。
    static func pathspecFromFile(_ file: String) -> CommitOptions {
        .init("--pathspec-from-file=\(file)")
    }
    
    /// 只有在使用 --pathspec-from-file 时才有意义。指定路径元素用 NUL 字符分隔，所有其他字符都按字面意思（包括换行符和引号）表示。
    static let pathspecFileNul: CommitOptions = "--pathspec-file-nul"
    
    static func untrackedFiles(_ mode: UntrackedFilesMode) -> StatusOptions {
        .init(stringLiteral: "--untracked-files=\(mode.rawValue)")
    }
    
    static func signoff(_ flag: Bool) -> CommitOptions { flag ? "--signoff" : "--no-signoff" }
    static func verify(_ flag: Bool) -> CommitOptions { flag ? "--verify" : "--no-verify" }
    static func edit(_ flag: Bool) -> CommitOptions { flag ? "--edit" : "--no-edit" }
    static func status(_ flag: Bool) -> CommitOptions { flag ? "--status" : "--no-status" }

    
    /**
     -S[<keyid>]
     --gpg-sign[=<keyid>]
     --no-gpg-sign
     GPG-sign commits. The keyid argument is optional and defaults to the committer identity; if specified, it must be stuck to the option without a space. --no-gpg-sign is useful to countermand both commit.gpgSign configuration variable, and earlier --gpg-sign.
     
     --trailer <token>[(=|:)<value>]
     Specify a (<token>, <value>) pair that should be applied as a trailer. (e.g. git commit --trailer "Signed-off-by:C O Mitter \ <committer@example.com>" --trailer "Helped-by:C O Mitter \ <committer@example.com>" will add the "Signed-off-by" trailer and the "Helped-by" trailer to the commit message.) The trailer.* configuration variables (git-interpret-trailers[1]) can be used to define if a duplicated trailer is omitted, where in the run of trailers each trailer would appear, and other details.
     
     --fixup=[(amend|reword):]<commit>
     Create a new commit which "fixes up" <commit> when applied with git rebase --autosquash. Plain --fixup=<commit> creates a "fixup!" commit which changes the content of <commit> but leaves its log message untouched. --fixup=amend:<commit> is similar but creates an "amend!" commit which also replaces the log message of <commit> with the log message of the "amend!" commit. --fixup=reword:<commit> creates an "amend!" commit which replaces the log message of <commit> with its own log message but makes no changes to the content of <commit>.

     The commit created by plain --fixup=<commit> has a subject composed of "fixup!" followed by the subject line from <commit>, and is recognized specially by git rebase --autosquash. The -m option may be used to supplement the log message of the created commit, but the additional commentary will be thrown away once the "fixup!" commit is squashed into <commit> by git rebase --autosquash.

     The commit created by --fixup=amend:<commit> is similar but its subject is instead prefixed with "amend!". The log message of <commit> is copied into the log message of the "amend!" commit and opened in an editor so it can be refined. When git rebase --autosquash squashes the "amend!" commit into <commit>, the log message of <commit> is replaced by the refined log message from the "amend!" commit. It is an error for the "amend!" commit’s log message to be empty unless --allow-empty-message is specified.

     --fixup=reword:<commit> is shorthand for --fixup=amend:<commit> --only. It creates an "amend!" commit with only a log message (ignoring any changes staged in the index). When squashed by git rebase --autosquash, it replaces the log message of <commit> without making any other changes.

     Neither "fixup!" nor "amend!" commits change authorship of <commit> when applied by git rebase --autosquash. See git-rebase[1] for details.
     */
}
