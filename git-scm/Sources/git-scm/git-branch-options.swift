public struct BranchOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension BranchOptions {

    ///  --abbrev=<n>
    static func abbrev(n: String) -> Self { .init("--abbrev=\(n)") }
    ///  --all
static let all: Self = "--all"
    ///  --color[=<when>]
    static func color(when: [String]) -> Self { .init("--color=\(when.joined(separator: ","))") }
    ///  --column[=<options>]
    static func column(options: [String]) -> Self { .init("--column=\(options.joined(separator: ","))") }
    ///  --contains [<commit>]
    static func contains(commit: [String]) -> Self { .init("--contains \(commit.joined(separator: ","))") }
    ///  --copy
static let copy: Self = "--copy"
    ///  --create-reflog
static let createReflog: Self = "--create-reflog"
    ///  --delete
static let delete: Self = "--delete"
    ///  --edit-description
static let editDescription: Self = "--edit-description"
    ///  --force
static let force: Self = "--force"
    ///  --format <format>
    static func format(format: String) -> Self { .init("--format \(format)") }
    ///  --ignore-case
static let ignoreCase: Self = "--ignore-case"
    ///  --list
static let list: Self = "--list"
    ///  --merged [<commit>]
    static func merged(commit: [String]) -> Self { .init("--merged \(commit.joined(separator: ","))") }
    ///  --move
static let move: Self = "--move"
    ///  --no-abbrev
static let noAbbrev: Self = "--no-abbrev"
    ///  --no-color
static let noColor: Self = "--no-color"
    ///  --no-column
static let noColumn: Self = "--no-column"
    ///  --no-contains [<commit>]
    static func noContains(commit: [String]) -> Self { .init("--no-contains \(commit.joined(separator: ","))") }
    ///  --no-merged [<commit>]
    static func noMerged(commit: [String]) -> Self { .init("--no-merged \(commit.joined(separator: ","))") }
    ///  --no-track
static let noTrack: Self = "--no-track"
    ///  --points-at <object>
    static func pointsAt(object: String) -> Self { .init("--points-at \(object)") }
    ///  --quiet
static let quiet: Self = "--quiet"
    ///  --recurse-submodules
static let recurseSubmodules: Self = "--recurse-submodules"
    ///  --remotes
static let remotes: Self = "--remotes"
    ///  --set-upstream
static let setUpstream: Self = "--set-upstream"
    ///  --set-upstream-to=<upstream>
    static func setUpstreamTo(upstream: String) -> Self { .init("--set-upstream-to=\(upstream)") }
    ///  --show-current
static let showCurrent: Self = "--show-current"
    ///  --sort=<key>
    static func sort(key: String) -> Self { .init("--sort=\(key)") }
    ///  --unset-upstream
static let unsetUpstream: Self = "--unset-upstream"
    ///  --verbose
static let verbose: Self = "--verbose"
enum Track: String {
case direct
case inherit
}
    ///  --track[=(direct|inherit)]
    static func track(_ track: Track) -> Self { .init("--track=\(track.rawValue)") }

}