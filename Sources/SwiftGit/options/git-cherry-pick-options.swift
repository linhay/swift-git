public struct CherryPickOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension CherryPickOptions {

    ///  --abort
static let abort: Self = "--abort"
    ///  --allow-empty
static let allowEmpty: Self = "--allow-empty"
    ///  --allow-empty-message
static let allowEmptyMessage: Self = "--allow-empty-message"
    ///  --cleanup=<mode>
    static func cleanup(_ mode: String) -> Self { .init("--cleanup=\(mode)") }
    ///  --continue
static let `continue`: Self = "--continue"
    ///  --edit
static let edit: Self = "--edit"
    ///  --ff
static let ff: Self = "--ff"
    ///  --gpg-sign[=<keyid>]
    static func gpgSign(_ keyid: [String]) -> Self { .init("--gpg-sign=\(keyid.joined(separator: ","))") }
    ///  --keep-redundant-commits
static let keepRedundantCommits: Self = "--keep-redundant-commits"
    ///  --mainline <parent-number>
    static func mainline(_ parentNumber: String) -> Self { .init("--mainline \(parentNumber)") }
    ///  --no-commit
static let noCommit: Self = "--no-commit"
    ///  --no-gpg-sign
static let noGpgSign: Self = "--no-gpg-sign"
    ///  --no-rerere-autoupdate
static let noRerereAutoupdate: Self = "--no-rerere-autoupdate"
    ///  --quit
static let quit: Self = "--quit"
    ///  --rerere-autoupdate
static let rerereAutoupdate: Self = "--rerere-autoupdate"
    ///  --signoff
static let signoff: Self = "--signoff"
    ///  --skip
static let skip: Self = "--skip"
    ///  --strategy-option=<option>
    static func strategyOption(_ option: String) -> Self { .init("--strategy-option=\(option)") }
    ///  --strategy=<strategy>
    static func strategy(_ strategy: String) -> Self { .init("--strategy=\(strategy)") }

}