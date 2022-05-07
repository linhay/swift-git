public struct PushOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension PushOptions {

    ///  --all
static let all: Self = "--all"
    ///  --atomic
static let atomic: Self = "--atomic"
    ///  --delete
static let delete: Self = "--delete"
    ///  --dry-run
static let dryRun: Self = "--dry-run"
    ///  --exec=<git-receive-pack>
    static func exec(_ gitReceivePack: String) -> Self { .init("--exec=\(gitReceivePack)") }
    ///  --follow-tags
static let followTags: Self = "--follow-tags"
    ///  --force
static let force: Self = "--force"
    ///  --force-if-includes
static let forceIfIncludes: Self = "--force-if-includes"
    ///  --force-with-lease
static let forceWithLease: Self = "--force-with-lease"
    ///  --force-with-lease=<refname>
    static func forceWithLease(_ refname: String) -> Self { .init("--force-with-lease=\(refname)") }
    ///  --force-with-lease=<refname>:<expect>
    static func forceWithLeaseExpect(_ refname: String) -> Self { .init("--force-with-lease:<expect>=\(refname)") }
    ///  --ipv4
static let ipv4: Self = "--ipv4"
    ///  --ipv6
static let ipv6: Self = "--ipv6"
    ///  --mirror
static let mirror: Self = "--mirror"
    ///  --no-atomic
static let noAtomic: Self = "--no-atomic"
    ///  --no-force-if-includes
static let noForceIfIncludes: Self = "--no-force-if-includes"
    ///  --no-force-with-lease
static let noForceWithLease: Self = "--no-force-with-lease"
    ///  --no-recurse-submodules
static let noRecurseSubmodules: Self = "--no-recurse-submodules"
    ///  --no-signed
static let noSigned: Self = "--no-signed"
    ///  --no-thin
static let noThin: Self = "--no-thin"
    ///  --no-verify
static let noVerify: Self = "--no-verify"
    ///  --porcelain
static let porcelain: Self = "--porcelain"
    ///  --progress
static let progress: Self = "--progress"
    ///  --prune
static let prune: Self = "--prune"
    ///  --push-option=<option>
    static func pushOption(_ option: String) -> Self { .init("--push-option=\(option)") }
    ///  --quiet
static let quiet: Self = "--quiet"
    ///  --receive-pack=<git-receive-pack>
    static func receivePack(_ gitReceivePack: String) -> Self { .init("--receive-pack=\(gitReceivePack)") }
    ///  --recurse-submodules=check|on-demand|only|no
    static func recurseSubmodulescheckOnDemandOnlyNo() -> Self { .init("--recurse-submodulescheck|on-demand|only|no=") }
    ///  --repo=<repository>
    static func repo(_ repository: String) -> Self { .init("--repo=\(repository)") }
    ///  --set-upstream
static let setUpstream: Self = "--set-upstream"
    ///  --signed
static let signed: Self = "--signed"
    ///  --tags
static let tags: Self = "--tags"
    ///  --thin
static let thin: Self = "--thin"
    ///  --verbose
static let verbose: Self = "--verbose"
    ///  --verify
static let verify: Self = "--verify"
enum Signed: String {
case `true` = "true"
case `false` = "false"
case ifAsked = "if-asked"
}
    ///  --signed=(true|false|if-asked)
    static func signed(_ signed: Signed) -> Self { .init("--signed=\(signed.rawValue)") }

}