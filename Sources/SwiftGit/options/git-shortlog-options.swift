public struct ShortlogOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension ShortlogOptions {

    ///  --after=<date>
    static func after(_ date: String) -> Self { .init("--after=\(date)") }
    ///  --all
static let all: Self = "--all"
    ///  --all-match
static let allMatch: Self = "--all-match"
    ///  --alternate-refs
static let alternateRefs: Self = "--alternate-refs"
    ///  --ancestry-path
static let ancestryPath: Self = "--ancestry-path"
    ///  --author=<pattern>
    static func author(_ pattern: String) -> Self { .init("--author=\(pattern)") }
    ///  --basic-regexp
static let basicRegexp: Self = "--basic-regexp"
    ///  --before=<date>
    static func before(_ date: String) -> Self { .init("--before=\(date)") }
    ///  --bisect
static let bisect: Self = "--bisect"
    ///  --boundary
static let boundary: Self = "--boundary"
    ///  --branches[=<pattern>]
    static func branches(_ pattern: [String]) -> Self { .init("--branches=\(pattern.joined(separator: ","))") }
    ///  --cherry
static let cherry: Self = "--cherry"
    ///  --cherry-mark
static let cherryMark: Self = "--cherry-mark"
    ///  --cherry-pick
static let cherryPick: Self = "--cherry-pick"
    ///  --committer
static let committer: Self = "--committer"
    ///  --committer=<pattern>
    static func committer(_ pattern: String) -> Self { .init("--committer=\(pattern)") }
    ///  --dense
static let dense: Self = "--dense"
    ///  --email
static let email: Self = "--email"
    ///  --exclude-first-parent-only
static let excludeFirstParentOnly: Self = "--exclude-first-parent-only"
    ///  --exclude=<glob-pattern>
    static func exclude(_ globPattern: String) -> Self { .init("--exclude=\(globPattern)") }
    ///  --extended-regexp
static let extendedRegexp: Self = "--extended-regexp"
    ///  --first-parent
static let firstParent: Self = "--first-parent"
    ///  --fixed-strings
static let fixedStrings: Self = "--fixed-strings"
    ///  --format[=<format>]
    static func format(_ format: [String]) -> Self { .init("--format=\(format.joined(separator: ","))") }
    ///  --full-history
static let fullHistory: Self = "--full-history"
    ///  --full-history with parent rewriting
static let fullHistoryWithParentRewriting: Self = "--full-history with parent rewriting"
    ///  --full-history without parent rewriting
static let fullHistoryWithoutParentRewriting: Self = "--full-history without parent rewriting"
    ///  --glob=<glob-pattern>
    static func glob(_ globPattern: String) -> Self { .init("--glob=\(globPattern)") }
    ///  --grep-reflog=<pattern>
    static func grepReflog(_ pattern: String) -> Self { .init("--grep-reflog=\(pattern)") }
    ///  --grep=<pattern>
    static func grep(_ pattern: String) -> Self { .init("--grep=\(pattern)") }
    ///  --group=<type>
    static func group(_ type: String) -> Self { .init("--group=\(type)") }
    ///  --ignore-missing
static let ignoreMissing: Self = "--ignore-missing"
    ///  --invert-grep
static let invertGrep: Self = "--invert-grep"
    ///  --left-only
static let leftOnly: Self = "--left-only"
    ///  --max-count=<number>
    static func maxCount(_ number: String) -> Self { .init("--max-count=\(number)") }
    ///  --max-parents=<number>
    static func maxParents(_ number: String) -> Self { .init("--max-parents=\(number)") }
    ///  --merge
static let merge: Self = "--merge"
    ///  --merges
static let merges: Self = "--merges"
    ///  --min-parents=<number>
    static func minParents(_ number: String) -> Self { .init("--min-parents=\(number)") }
    ///  --no-max-parents
static let noMaxParents: Self = "--no-max-parents"
    ///  --no-merges
static let noMerges: Self = "--no-merges"
    ///  --no-min-parents
static let noMinParents: Self = "--no-min-parents"
    ///  --not
static let not: Self = "--not"
    ///  --numbered
static let numbered: Self = "--numbered"
    ///  --perl-regexp
static let perlRegexp: Self = "--perl-regexp"
    ///  --reflog
static let reflog: Self = "--reflog"
    ///  --regexp-ignore-case
static let regexpIgnoreCase: Self = "--regexp-ignore-case"
    ///  --remotes[=<pattern>]
    static func remotes(_ pattern: [String]) -> Self { .init("--remotes=\(pattern.joined(separator: ","))") }
    ///  --remove-empty
static let removeEmpty: Self = "--remove-empty"
    ///  --right-only
static let rightOnly: Self = "--right-only"
    ///  --show-pulls
static let showPulls: Self = "--show-pulls"
    ///  --simplify-by-decoration
static let simplifyByDecoration: Self = "--simplify-by-decoration"
    ///  --simplify-merges
static let simplifyMerges: Self = "--simplify-merges"
    ///  --since=<date>
    static func since(_ date: String) -> Self { .init("--since=\(date)") }
    ///  --single-worktree
static let singleWorktree: Self = "--single-worktree"
    ///  --skip=<number>
    static func skip(_ number: String) -> Self { .init("--skip=\(number)") }
    ///  --sparse
static let sparse: Self = "--sparse"
    ///  --stdin
static let stdin: Self = "--stdin"
    ///  --summary
static let summary: Self = "--summary"
    ///  --tags[=<pattern>]
    static func tags(_ pattern: [String]) -> Self { .init("--tags=\(pattern.joined(separator: ","))") }
    ///  --until=<date>
    static func until(_ date: String) -> Self { .init("--until=\(date)") }
    ///  --walk-reflogs
static let walkReflogs: Self = "--walk-reflogs"

}