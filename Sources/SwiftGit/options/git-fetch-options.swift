public struct FetchOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension FetchOptions {

    ///  --all
static let all: Self = "--all"
    ///  --append
static let append: Self = "--append"
    ///  --atomic
static let atomic: Self = "--atomic"
    ///  --auto-gc
static let autoGc: Self = "--auto-gc"
    ///  --auto-maintenance
static let autoMaintenance: Self = "--auto-maintenance"
    ///  --deepen=<depth>
    static func deepen(_ depth: String) -> Self { .init("--deepen=\(depth)") }
    ///  --depth=<depth>
    static func depth(_ depth: String) -> Self { .init("--depth=\(depth)") }
    ///  --dry-run
static let dryRun: Self = "--dry-run"
    ///  --force
static let force: Self = "--force"
    ///  --ipv4
static let ipv4: Self = "--ipv4"
    ///  --ipv6
static let ipv6: Self = "--ipv6"
    ///  --jobs=<n>
    static func jobs(_ n: String) -> Self { .init("--jobs=\(n)") }
    ///  --keep
static let keep: Self = "--keep"
    ///  --multiple
static let multiple: Self = "--multiple"
    ///  --negotiate-only
static let negotiateOnly: Self = "--negotiate-only"
    ///  --negotiation-tip=<commit|glob>
    static func negotiationTipCommitGlob() -> Self { .init("--negotiation-tip<commit|glob>=") }
    ///  --no-auto-gc
static let noAutoGc: Self = "--no-auto-gc"
    ///  --no-auto-maintenance
static let noAutoMaintenance: Self = "--no-auto-maintenance"
    ///  --no-recurse-submodules
static let noRecurseSubmodules: Self = "--no-recurse-submodules"
    ///  --no-show-forced-updates
static let noShowForcedUpdates: Self = "--no-show-forced-updates"
    ///  --no-tags
static let noTags: Self = "--no-tags"
    ///  --no-write-commit-graph
static let noWriteCommitGraph: Self = "--no-write-commit-graph"
    ///  --no-write-fetch-head
static let noWriteFetchHead: Self = "--no-write-fetch-head"
    ///  --prefetch
static let prefetch: Self = "--prefetch"
    ///  --progress
static let progress: Self = "--progress"
    ///  --prune
static let prune: Self = "--prune"
    ///  --prune-tags
static let pruneTags: Self = "--prune-tags"
    ///  --quiet
static let quiet: Self = "--quiet"
    ///  --recurse-submodules-default=[yes|on-demand]
    static func recurseSubmodulesDefaultYesOnDemand() -> Self { .init("--recurse-submodules-default[yes|on-demand]=") }
    ///  --recurse-submodules[=yes|on-demand|no]
    static func recurseSubmodulesYesOnDemandNo() -> Self { .init("--recurse-submodules[yes|on-demand|no]=") }
    ///  --refetch
static let refetch: Self = "--refetch"
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
    ///  --stdin
static let stdin: Self = "--stdin"
    ///  --submodule-prefix=<path>
    static func submodulePrefix(_ path: String) -> Self { .init("--submodule-prefix=\(path)") }
    ///  --tags
static let tags: Self = "--tags"
    ///  --unshallow
static let unshallow: Self = "--unshallow"
    ///  --update-head-ok
static let updateHeadOk: Self = "--update-head-ok"
    ///  --update-shallow
static let updateShallow: Self = "--update-shallow"
    ///  --upload-pack <upload-pack>
    static func uploadPack(_ uploadPack: String) -> Self { .init("--upload-pack \(uploadPack)") }
    ///  --verbose
static let verbose: Self = "--verbose"
    ///  --write-commit-graph
static let writeCommitGraph: Self = "--write-commit-graph"
    ///  --write-fetch-head
static let writeFetchHead: Self = "--write-fetch-head"

}