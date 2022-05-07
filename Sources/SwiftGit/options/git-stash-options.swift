public struct StashOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension StashOptions {

    ///  --all
static let all: Self = "--all"
    ///  --include-untracked
static let includeUntracked: Self = "--include-untracked"
    ///  --index
static let index: Self = "--index"
    ///  --keep-index
static let keepIndex: Self = "--keep-index"
    ///  --no-include-untracked
static let noIncludeUntracked: Self = "--no-include-untracked"
    ///  --no-keep-index
static let noKeepIndex: Self = "--no-keep-index"
    ///  --only-untracked
static let onlyUntracked: Self = "--only-untracked"
    ///  --patch
static let patch: Self = "--patch"
    ///  --pathspec-file-nul
static let pathspecFileNul: Self = "--pathspec-file-nul"
    ///  --pathspec-from-file=<file>
    static func pathspecFromFile(_ file: String) -> Self { .init("--pathspec-from-file=\(file)") }
    ///  --quiet
static let quiet: Self = "--quiet"
    ///  --staged
static let staged: Self = "--staged"
    ///  apply [--index] [-q|--quiet] [<stash>]
    static func applyIndexQQuiet(_ stash: [String]) -> Self { .init("apply [--index] [-q|--quiet] \(stash.joined(separator: ","))") }
    ///  drop [-q|--quiet] [<stash>]
    static func dropQQuiet(_ stash: [String]) -> Self { .init("drop [-q|--quiet] \(stash.joined(separator: ","))") }
    ///  pop [--index] [-q|--quiet] [<stash>]
    static func popIndexQQuiet(_ stash: [String]) -> Self { .init("pop [--index] [-q|--quiet] \(stash.joined(separator: ","))") }
    ///  push [-p|--patch] [-S|--staged] [-k|--keep-index] [-u|--include-untracked] [-a|--all] [-q|--quiet] [-m|--message <message>] [--pathspec-from-file=<file> [--pathspec-file-nul]] [--] [<pathspec>…​]
    static func pushPPatchSStagedKKeepIndexUIncludeUntrackedAAllQQuietMMessageMessagePathspecFromFilePathspecFileNulPathspec(_ file: String) -> Self { .init("push [-p|--patch] [-S|--staged] [-k|--keep-index] [-u|--include-untracked] [-a|--all] [-q|--quiet] [-m|--message <message>] [--pathspec-from-file [--pathspec-file-nul]] [--] [<pathspec>…​]=\(file)") }
    ///  push [-p|--patch] [-S|--staged] [-k|--no-keep-index] [-u|--include-untracked] [-a|--all] [-q|--quiet] [-m|--message <message>] [--pathspec-from-file=<file> [--pathspec-file-nul]] [--] [<pathspec>…​]
    static func pushPPatchSStagedKNoKeepIndexUIncludeUntrackedAAllQQuietMMessageMessagePathspecFromFilePathspecFileNulPathspec(_ file: String) -> Self { .init("push [-p|--patch] [-S|--staged] [-k|--no-keep-index] [-u|--include-untracked] [-a|--all] [-q|--quiet] [-m|--message <message>] [--pathspec-from-file [--pathspec-file-nul]] [--] [<pathspec>…​]=\(file)") }
    ///  save [-p|--patch] [-S|--staged] [-k|--keep-index] [-u|--include-untracked] [-a|--all] [-q|--quiet] [<message>]
    static func savePPatchSStagedKKeepIndexUIncludeUntrackedAAllQQuiet(_ message: [String]) -> Self { .init("save [-p|--patch] [-S|--staged] [-k|--keep-index] [-u|--include-untracked] [-a|--all] [-q|--quiet] \(message.joined(separator: ","))") }
    ///  save [-p|--patch] [-S|--staged] [-k|--no-keep-index] [-u|--include-untracked] [-a|--all] [-q|--quiet] [<message>]
    static func savePPatchSStagedKNoKeepIndexUIncludeUntrackedAAllQQuiet(_ message: [String]) -> Self { .init("save [-p|--patch] [-S|--staged] [-k|--no-keep-index] [-u|--include-untracked] [-a|--all] [-q|--quiet] \(message.joined(separator: ","))") }
    ///  show [-u|--include-untracked|--only-untracked] [<diff-options>] [<stash>]
    static func showUIncludeUntrackedOnlyUntracked(_ diffOptions: [String], _ stash: [String]) -> Self { .init("show [-u|--include-untracked|--only-untracked] \(diffOptions.joined(separator: ",")) \(stash.joined(separator: ","))") }

}