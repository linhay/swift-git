public struct MergeOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension MergeOptions {

    ///  --abort
static let abort: Self = "--abort"
    ///  --allow-unrelated-histories
static let allowUnrelatedHistories: Self = "--allow-unrelated-histories"
    ///  --autostash
static let autostash: Self = "--autostash"
    ///  --cleanup=<mode>
    static func cleanup(mode: String) -> Self { .init("--cleanup=\(mode)") }
    ///  --commit
static let commit: Self = "--commit"
    ///  --continue
static let `continue`: Self = "--continue"
    ///  --edit
static let edit: Self = "--edit"
    ///  --ff
static let ff: Self = "--ff"
    ///  --ff-only
static let ffOnly: Self = "--ff-only"
    ///  --file=<file>
    static func file(file: String) -> Self { .init("--file=\(file)") }
    ///  --gpg-sign[=<keyid>]
    static func gpgSign(keyid: [String]) -> Self { .init("--gpg-sign=\(keyid.joined(separator: ","))") }
    ///  --into-name <branch>
    static func intoName(branch: String) -> Self { .init("--into-name \(branch)") }
    ///  --log[=<n>]
    static func log(n: [String]) -> Self { .init("--log=\(n.joined(separator: ","))") }
    ///  --no-autostash
static let noAutostash: Self = "--no-autostash"
    ///  --no-commit
static let noCommit: Self = "--no-commit"
    ///  --no-edit
static let noEdit: Self = "--no-edit"
    ///  --no-ff
static let noFf: Self = "--no-ff"
    ///  --no-gpg-sign
static let noGpgSign: Self = "--no-gpg-sign"
    ///  --no-log
static let noLog: Self = "--no-log"
    ///  --no-overwrite-ignore
static let noOverwriteIgnore: Self = "--no-overwrite-ignore"
    ///  --no-progress
static let noProgress: Self = "--no-progress"
    ///  --no-rerere-autoupdate
static let noRerereAutoupdate: Self = "--no-rerere-autoupdate"
    ///  --no-signoff
static let noSignoff: Self = "--no-signoff"
    ///  --no-squash
static let noSquash: Self = "--no-squash"
    ///  --no-stat
static let noStat: Self = "--no-stat"
    ///  --no-summary
static let noSummary: Self = "--no-summary"
    ///  --no-verify
static let noVerify: Self = "--no-verify"
    ///  --no-verify-signatures
static let noVerifySignatures: Self = "--no-verify-signatures"
    ///  --overwrite-ignore
static let overwriteIgnore: Self = "--overwrite-ignore"
    ///  --progress
static let progress: Self = "--progress"
    ///  --quiet
static let quiet: Self = "--quiet"
    ///  --quit
static let quit: Self = "--quit"
    ///  --rerere-autoupdate
static let rerereAutoupdate: Self = "--rerere-autoupdate"
    ///  --signoff
static let signoff: Self = "--signoff"
    ///  --squash
static let squash: Self = "--squash"
    ///  --stat
static let stat: Self = "--stat"
    ///  --strategy-option=<option>
    static func strategyOption(option: String) -> Self { .init("--strategy-option=\(option)") }
    ///  --strategy=<strategy>
    static func strategy(strategy: String) -> Self { .init("--strategy=\(strategy)") }
    ///  --summary
static let summary: Self = "--summary"
    ///  --verbose
static let verbose: Self = "--verbose"
    ///  --verify
static let verify: Self = "--verify"
    ///  --verify-signatures
static let verifySignatures: Self = "--verify-signatures"

}