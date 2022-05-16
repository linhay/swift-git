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
    
    ///  --all
    static let all: Self = "--all"
    ///  --allow-empty
    static let allowEmpty: Self = "--allow-empty"
    ///  --allow-empty-message
    static let allowEmptyMessage: Self = "--allow-empty-message"
    ///  --amend
    static let amend: Self = "--amend"
    ///  --author=<author>
    static func author(_ author: String) -> Self { .init("--author=\(author)") }
    ///  --branch
    static let branch: Self = "--branch"
    ///  --cleanup=<mode>
    static func cleanup(_ mode: String) -> Self { .init("--cleanup=\(mode)") }
    ///  --date=<date>
    static func date(_ date: String) -> Self { .init("--date=\(date)") }
    ///  --dry-run
    static let dryRun: Self = "--dry-run"
    ///  --edit
    static let edit: Self = "--edit"
    ///  --file=<file>
    static func file(_ file: String) -> Self { .init("--file=\(file)") }
    ///  --gpg-sign[=<keyid>]
    static func gpgSign(_ keyid: [String]) -> Self { .init("--gpg-sign=\(keyid.joined(separator: ","))") }
    ///  --include
    static let include: Self = "--include"
    ///  --long
    static let long: Self = "--long"
    ///  --message=<msg>
    static func message(_ msg: String) -> Self { .init("--message=\(msg)") }
    ///  --no-edit
    static let noEdit: Self = "--no-edit"
    ///  --no-gpg-sign
    static let noGpgSign: Self = "--no-gpg-sign"
    ///  --no-post-rewrite
    static let noPostRewrite: Self = "--no-post-rewrite"
    ///  --no-signoff
    static let noSignoff: Self = "--no-signoff"
    ///  --no-status
    static let noStatus: Self = "--no-status"
    ///  --no-verify
    static let noVerify: Self = "--no-verify"
    ///  --null
    static let null: Self = "--null"
    ///  --only
    static let only: Self = "--only"
    ///  --patch
    static let patch: Self = "--patch"
    ///  --pathspec-file-nul
    static let pathspecFileNul: Self = "--pathspec-file-nul"
    ///  --pathspec-from-file=<file>
    static func pathspecFromFile(_ file: String) -> Self { .init("--pathspec-from-file=\(file)") }
    ///  --porcelain
    static let porcelain: Self = "--porcelain"
    ///  --quiet
    static let quiet: Self = "--quiet"
    ///  --reedit-message=<commit>
    static func reeditMessage(_ commit: String) -> Self { .init("--reedit-message=\(commit)") }
    ///  --reset-author
    static let resetAuthor: Self = "--reset-author"
    ///  --reuse-message=<commit>
    static func reuseMessage(_ commit: String) -> Self { .init("--reuse-message=\(commit)") }
    ///  --short
    static let short: Self = "--short"
    ///  --signoff
    static let signoff: Self = "--signoff"
    ///  --squash=<commit>
    static func squash(_ commit: String) -> Self { .init("--squash=\(commit)") }
    ///  --status
    static let status: Self = "--status"
    ///  --template=<file>
    static func template(_ file: String) -> Self { .init("--template=\(file)") }
    ///  --untracked-files[=<mode>]
    static func untrackedFiles(_ mode: [String]) -> Self { .init("--untracked-files=\(mode.joined(separator: ","))") }
    ///  --verbose
    static let verbose: Self = "--verbose"
    ///  --verify
    static let verify: Self = "--verify"
    
}
