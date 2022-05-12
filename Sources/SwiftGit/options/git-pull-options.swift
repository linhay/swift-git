public struct PullOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension PullOptions {
    
    ///  --all
    static let all: Self = "--all"
    ///  --allow-unrelated-histories
    static let allowUnrelatedHistories: Self = "--allow-unrelated-histories"
    ///  --append
    static let append: Self = "--append"
    ///  --atomic
    static let atomic: Self = "--atomic"
    ///  --autostash
    static let autostash: Self = "--autostash"
    ///  --cleanup=<mode>
    static func cleanup(_ mode: String) -> Self { .init("--cleanup=\(mode)") }
    ///  --commit
    static let commit: Self = "--commit"
    ///  --deepen=<depth>
    static func deepen(_ depth: String) -> Self { .init("--deepen=\(depth)") }
    ///  --depth=<depth>
    static func depth(_ depth: String) -> Self { .init("--depth=\(depth)") }
    ///  --dry-run
    static let dryRun: Self = "--dry-run"
    ///  --edit
    static let edit: Self = "--edit"
    ///  --ff
    static let ff: Self = "--ff"
    ///  --ff-only
    static let ffOnly: Self = "--ff-only"
    ///  --force
    static let force: Self = "--force"
    ///  --gpg-sign[=<keyid>]
    static func gpgSign(_ keyid: [String]) -> Self { .init("--gpg-sign=\(keyid.joined(separator: ","))") }
    ///  --ipv4
    static let ipv4: Self = "--ipv4"
    ///  --ipv6
    static let ipv6: Self = "--ipv6"
    ///  --jobs=<n>
    static func jobs(_ n: String) -> Self { .init("--jobs=\(n)") }
    ///  --keep
    static let keep: Self = "--keep"
    ///  --log[=<n>]
    static func log(_ n: [String]) -> Self { .init("--log=\(n.joined(separator: ","))") }
    ///  --negotiate-only
    static let negotiateOnly: Self = "--negotiate-only"
    ///  --negotiation-tip=<commit|glob>
    static func negotiationTipCommitGlob() -> Self { .init("--negotiation-tip<commit|glob>=") }
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
    ///  --no-rebase
    static let noRebase: Self = "--no-rebase"
    ///  --no-recurse-submodules[=yes|on-demand|no]
    static func noRecurseSubmodulesYesOnDemandNo() -> Self { .init("--no-recurse-submodules[yes|on-demand|no]=") }
    ///  --no-show-forced-updates
    static let noShowForcedUpdates: Self = "--no-show-forced-updates"
    ///  --no-signoff
    static let noSignoff: Self = "--no-signoff"
    ///  --no-squash
    static let noSquash: Self = "--no-squash"
    ///  --no-stat
    static let noStat: Self = "--no-stat"
    ///  --no-summary
    static let noSummary: Self = "--no-summary"
    ///  --no-tags
    static let noTags: Self = "--no-tags"
    ///  --no-verify
    static let noVerify: Self = "--no-verify"
    ///  --no-verify-signatures
    static let noVerifySignatures: Self = "--no-verify-signatures"
    ///  --prefetch
    static let prefetch: Self = "--prefetch"
    ///  --progress
    static let progress: Self = "--progress"
    ///  --prune
    static let prune: Self = "--prune"
    ///  --quiet
    static let quiet: Self = "--quiet"
    ///  --rebase[=false|true|merges|interactive]
    static func rebaseFalseTrueMergesInteractive() -> Self { .init("--rebase[false|true|merges|interactive]=") }
    ///  --recurse-submodules[=yes|on-demand|no]
    static func recurseSubmodulesYesOnDemandNo() -> Self { .init("--recurse-submodules[yes|on-demand|no]=") }
    ///  --refmap=<refspec>
    static func refmap(_ refspec: String) -> Self { .init("--refmap=\(refspec)") }
    ///  --server-option=<option>
    static func serverOption(_ option: String) -> Self { .init("--server-option=\(option)") }
    ///  --set-upstream
    static let setUpstream: Self = "--set-upstream"
    ///  --shallow-exclude=<revision>
    static func shallowExclude(_ revision: String) -> Self { .init("--shallow-exclude=\(revision)") }
    ///  --shallow-since=<date>
    static func shallowSince(_ date: String) -> Self { .init("--shallow-since=\(date)") }
    ///  --show-forced-updates
    static let showForcedUpdates: Self = "--show-forced-updates"
    ///  --signoff
    static let signoff: Self = "--signoff"
    ///  --squash
    static let squash: Self = "--squash"
    ///  --stat
    static let stat: Self = "--stat"
    ///  --strategy-option=<option>
    static func strategyOption(_ option: String) -> Self { .init("--strategy-option=\(option)") }
    ///  --strategy=<strategy>
    static func strategy(_ strategy: String) -> Self { .init("--strategy=\(strategy)") }
    ///  --summary
    static let summary: Self = "--summary"
    ///  --tags
    static let tags: Self = "--tags"
    ///  --unshallow
    static let unshallow: Self = "--unshallow"
    ///  --update-shallow
    static let updateShallow: Self = "--update-shallow"
    ///  --upload-pack <upload-pack>
    static func uploadPack(_ uploadPack: String) -> Self { .init("--upload-pack \(uploadPack)") }
    ///  --verbose
    static let verbose: Self = "--verbose"
    ///  --verify
    static let verify: Self = "--verify"
    ///  --verify-signatures
    static let verifySignatures: Self = "--verify-signatures"
    
}
