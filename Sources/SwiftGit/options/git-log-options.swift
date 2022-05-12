public struct LogOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension LogOptions {
    
    ///  --abbrev-commit
    static let abbrevCommit: Self = "--abbrev-commit"
    ///  --abbrev[=<n>]
    static func abbrev(_ n: [String]) -> Self { .init("--abbrev=\(n.joined(separator: ","))") }
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
    ///  --anchored=<text>
    static func anchored(_ text: String) -> Self { .init("--anchored=\(text)") }
    ///  --author-date-order
    static let authorDateOrder: Self = "--author-date-order"
    ///  --author=<pattern>
    static func author(_ pattern: String) -> Self { .init("--author=\(pattern)") }
    ///  --basic-regexp
    static let basicRegexp: Self = "--basic-regexp"
    ///  --before=<date>
    static func before(_ date: String) -> Self { .init("--before=\(date)") }
    ///  --binary
    static let binary: Self = "--binary"
    ///  --bisect
    static let bisect: Self = "--bisect"
    ///  --boundary
    static let boundary: Self = "--boundary"
    ///  --branches[=<pattern>]
    static func branches(_ pattern: [String]) -> Self { .init("--branches=\(pattern.joined(separator: ","))") }
    ///  --break-rewrites[=[<n>][/<m>]]
    static func breakRewrites(_ m: String, _ n: [String]) -> Self { .init("--break-rewrites[[/]]=\(m) \(n.joined(separator: ","))") }
    ///  --cc
    static let cc: Self = "--cc"
    ///  --check
    static let check: Self = "--check"
    ///  --cherry
    static let cherry: Self = "--cherry"
    ///  --cherry-mark
    static let cherryMark: Self = "--cherry-mark"
    ///  --cherry-pick
    static let cherryPick: Self = "--cherry-pick"
    ///  --children
    static let children: Self = "--children"
    ///  --color-moved-ws=<modes>
    static func colorMovedWs(_ modes: String) -> Self { .init("--color-moved-ws=\(modes)") }
    ///  --color-moved[=<mode>]
    static func colorMoved(_ mode: [String]) -> Self { .init("--color-moved=\(mode.joined(separator: ","))") }
    ///  --color-words[=<regex>]
    static func colorWords(_ regex: [String]) -> Self { .init("--color-words=\(regex.joined(separator: ","))") }
    ///  --color[=<when>]
    static func color(_ when: [String]) -> Self { .init("--color=\(when.joined(separator: ","))") }
    ///  --combined-all-paths
    static let combinedAllPaths: Self = "--combined-all-paths"
    ///  --committer=<pattern>
    static func committer(_ pattern: String) -> Self { .init("--committer=\(pattern)") }
    ///  --compact-summary
    static let compactSummary: Self = "--compact-summary"
    ///  --cumulative
    static let cumulative: Self = "--cumulative"
    ///  --date-order
    static let dateOrder: Self = "--date-order"
    ///  --date=<format>
    static func date(_ format: String) -> Self { .init("--date=\(format)") }
    ///  --decorate-refs-exclude=<pattern>
    static func decorateRefsExclude(_ pattern: String) -> Self { .init("--decorate-refs-exclude=\(pattern)") }
    ///  --decorate-refs=<pattern>
    static func decorateRefs(_ pattern: String) -> Self { .init("--decorate-refs=\(pattern)") }
    ///  --decorate[=short|full|auto|no]
    static func decorateShortFullAutoNo() -> Self { .init("--decorate[short|full|auto|no]=") }
    ///  --dense
    static let dense: Self = "--dense"
    ///  --diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]
    static func diffFilterACDMRTUXB() -> Self { .init("--diff-filter[(A|C|D|M|R|T|U|X|B)…​[*]]=") }
    ///  --diff-merges=first-parent
    static func diffMergesfirstParent() -> Self { .init("--diff-mergesfirst-parent=") }
    ///  --dirstat-by-file[=<param1,param2>…​]
    static func dirstatByFileParam1Param2() -> Self { .init("--dirstat-by-file[<param1,param2>…​]=") }
    ///  --dirstat[=<param1,param2,…​>]
    static func dirstatParam1Param2() -> Self { .init("--dirstat[<param1,param2,…​>]=") }
    ///  --do-walk
    static let doWalk: Self = "--do-walk"
    ///  --dst-prefix=<prefix>
    static func dstPrefix(_ prefix: String) -> Self { .init("--dst-prefix=\(prefix)") }
    ///  --encoding=<encoding>
    static func encoding(_ encoding: String) -> Self { .init("--encoding=\(encoding)") }
    ///  --exclude-first-parent-only
    static let excludeFirstParentOnly: Self = "--exclude-first-parent-only"
    ///  --exclude=<glob-pattern>
    static func exclude(_ globPattern: String) -> Self { .init("--exclude=\(globPattern)") }
    ///  --expand-tabs
    static let expandTabs: Self = "--expand-tabs"
    ///  --expand-tabs=<n>
    static func expandTabs(_ n: String) -> Self { .init("--expand-tabs=\(n)") }
    ///  --ext-diff
    static let extDiff: Self = "--ext-diff"
    ///  --extended-regexp
    static let extendedRegexp: Self = "--extended-regexp"
    ///  --find-copies-harder
    static let findCopiesHarder: Self = "--find-copies-harder"
    ///  --find-copies[=<n>]
    static func findCopies(_ n: [String]) -> Self { .init("--find-copies=\(n.joined(separator: ","))") }
    ///  --find-object=<object-id>
    static func findObject(_ objectId: String) -> Self { .init("--find-object=\(objectId)") }
    ///  --find-renames[=<n>]
    static func findRenames(_ n: [String]) -> Self { .init("--find-renames=\(n.joined(separator: ","))") }
    ///  --first-parent
    static let firstParent: Self = "--first-parent"
    ///  --fixed-strings
    static let fixedStrings: Self = "--fixed-strings"
    ///  --follow
    static let follow: Self = "--follow"
    ///  --format=<format>
    static func format(_ format: String) -> Self { .init("--format=\(format)") }
    ///  --full-diff
    static let fullDiff: Self = "--full-diff"
    ///  --full-history
    static let fullHistory: Self = "--full-history"
    ///  --full-history with parent rewriting
    static let fullHistoryWithParentRewriting: Self = "--full-history with parent rewriting"
    ///  --full-history without parent rewriting
    static let fullHistoryWithoutParentRewriting: Self = "--full-history without parent rewriting"
    ///  --full-index
    static let fullIndex: Self = "--full-index"
    ///  --function-context
    static let functionContext: Self = "--function-context"
    ///  --glob=<glob-pattern>
    static func glob(_ globPattern: String) -> Self { .init("--glob=\(globPattern)") }
    ///  --graph
    static let graph: Self = "--graph"
    ///  --grep-reflog=<pattern>
    static func grepReflog(_ pattern: String) -> Self { .init("--grep-reflog=\(pattern)") }
    ///  --grep=<pattern>
    static func grep(_ pattern: String) -> Self { .init("--grep=\(pattern)") }
    ///  --histogram
    static let histogram: Self = "--histogram"
    ///  --ignore-all-space
    static let ignoreAllSpace: Self = "--ignore-all-space"
    ///  --ignore-blank-lines
    static let ignoreBlankLines: Self = "--ignore-blank-lines"
    ///  --ignore-cr-at-eol
    static let ignoreCrAtEol: Self = "--ignore-cr-at-eol"
    ///  --ignore-matching-lines=<regex>
    static func ignoreMatchingLines(_ regex: String) -> Self { .init("--ignore-matching-lines=\(regex)") }
    ///  --ignore-missing
    static let ignoreMissing: Self = "--ignore-missing"
    ///  --ignore-space-at-eol
    static let ignoreSpaceAtEol: Self = "--ignore-space-at-eol"
    ///  --ignore-space-change
    static let ignoreSpaceChange: Self = "--ignore-space-change"
    ///  --ignore-submodules[=<when>]
    static func ignoreSubmodules(_ when: [String]) -> Self { .init("--ignore-submodules=\(when.joined(separator: ","))") }
    ///  --indent-heuristic
    static let indentHeuristic: Self = "--indent-heuristic"
    ///  --inter-hunk-context=<lines>
    static func interHunkContext(_ lines: String) -> Self { .init("--inter-hunk-context=\(lines)") }
    ///  --invert-grep
    static let invertGrep: Self = "--invert-grep"
    ///  --irreversible-delete
    static let irreversibleDelete: Self = "--irreversible-delete"
    ///  --ita-invisible-in-index
    static let itaInvisibleInIndex: Self = "--ita-invisible-in-index"
    ///  --left-only
    static let leftOnly: Self = "--left-only"
    ///  --left-right
    static let leftRight: Self = "--left-right"
    ///  --line-prefix=<prefix>
    static func linePrefix(_ prefix: String) -> Self { .init("--line-prefix=\(prefix)") }
    ///  --log-size
    static let logSize: Self = "--log-size"
    ///  --mailmap
    static let mailmap: Self = "--mailmap"
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
    ///  --minimal
    static let minimal: Self = "--minimal"
    ///  --name-only
    static let nameOnly: Self = "--name-only"
    ///  --name-status
    static let nameStatus: Self = "--name-status"
    ///  --no-abbrev-commit
    static let noAbbrevCommit: Self = "--no-abbrev-commit"
    ///  --no-color
    static let noColor: Self = "--no-color"
    ///  --no-color-moved
    static let noColorMoved: Self = "--no-color-moved"
    ///  --no-color-moved-ws
    static let noColorMovedWs: Self = "--no-color-moved-ws"
    ///  --no-decorate
    static let noDecorate: Self = "--no-decorate"
    ///  --no-diff-merges
    static let noDiffMerges: Self = "--no-diff-merges"
    ///  --no-expand-tabs
    static let noExpandTabs: Self = "--no-expand-tabs"
    ///  --no-ext-diff
    static let noExtDiff: Self = "--no-ext-diff"
    ///  --no-indent-heuristic
    static let noIndentHeuristic: Self = "--no-indent-heuristic"
    ///  --no-mailmap
    static let noMailmap: Self = "--no-mailmap"
    ///  --no-max-parents
    static let noMaxParents: Self = "--no-max-parents"
    ///  --no-merges
    static let noMerges: Self = "--no-merges"
    ///  --no-min-parents
    static let noMinParents: Self = "--no-min-parents"
    ///  --no-notes
    static let noNotes: Self = "--no-notes"
    ///  --no-patch
    static let noPatch: Self = "--no-patch"
    ///  --no-prefix
    static let noPrefix: Self = "--no-prefix"
    ///  --no-relative
    static let noRelative: Self = "--no-relative"
    ///  --no-rename-empty
    static let noRenameEmpty: Self = "--no-rename-empty"
    ///  --no-renames
    static let noRenames: Self = "--no-renames"
    ///  --no-standard-notes
    static let noStandardNotes: Self = "--no-standard-notes"
    ///  --no-textconv
    static let noTextconv: Self = "--no-textconv"
    ///  --no-use-mailmap
    static let noUseMailmap: Self = "--no-use-mailmap"
    ///  --not
    static let not: Self = "--not"
    ///  --notes[=<ref>]
    static func notes(_ ref: [String]) -> Self { .init("--notes=\(ref.joined(separator: ","))") }
    ///  --numstat
    static let numstat: Self = "--numstat"
    ///  --oneline
    static let oneline: Self = "--oneline"
    ///  --output-indicator-context=<char>
    static func outputIndicatorContext(_ char: String) -> Self { .init("--output-indicator-context=\(char)") }
    ///  --output-indicator-new=<char>
    static func outputIndicatorNew(_ char: String) -> Self { .init("--output-indicator-new=\(char)") }
    ///  --output-indicator-old=<char>
    static func outputIndicatorOld(_ char: String) -> Self { .init("--output-indicator-old=\(char)") }
    ///  --output=<file>
    static func output(_ file: String) -> Self { .init("--output=\(file)") }
    ///  --parents
    static let parents: Self = "--parents"
    ///  --patch
    static let patch: Self = "--patch"
    ///  --patch-with-raw
    static let patchWithRaw: Self = "--patch-with-raw"
    ///  --patch-with-stat
    static let patchWithStat: Self = "--patch-with-stat"
    ///  --patience
    static let patience: Self = "--patience"
    ///  --perl-regexp
    static let perlRegexp: Self = "--perl-regexp"
    ///  --pickaxe-all
    static let pickaxeAll: Self = "--pickaxe-all"
    ///  --pickaxe-regex
    static let pickaxeRegex: Self = "--pickaxe-regex"
    ///  --pretty[=<format>]
    static func pretty(_ format: [String]) -> Self { .init("--pretty=\(format.joined(separator: ","))") }
    ///  --raw
    static let raw: Self = "--raw"
    ///  --reflog
    static let reflog: Self = "--reflog"
    ///  --regexp-ignore-case
    static let regexpIgnoreCase: Self = "--regexp-ignore-case"
    ///  --relative-date
    static let relativeDate: Self = "--relative-date"
    ///  --relative[=<path>]
    static func relative(_ path: [String]) -> Self { .init("--relative=\(path.joined(separator: ","))") }
    ///  --remerge-diff
    static let remergeDiff: Self = "--remerge-diff"
    ///  --remotes[=<pattern>]
    static func remotes(_ pattern: [String]) -> Self { .init("--remotes=\(pattern.joined(separator: ","))") }
    ///  --remove-empty
    static let removeEmpty: Self = "--remove-empty"
    ///  --rename-empty
    static let renameEmpty: Self = "--rename-empty"
    ///  --reverse
    static let reverse: Self = "--reverse"
    ///  --right-only
    static let rightOnly: Self = "--right-only"
    ///  --rotate-to=<file>
    static func rotateTo(_ file: String) -> Self { .init("--rotate-to=\(file)") }
    ///  --shortstat
    static let shortstat: Self = "--shortstat"
    ///  --show-linear-break[=<barrier>]
    static func showLinearBreak(_ barrier: [String]) -> Self { .init("--show-linear-break=\(barrier.joined(separator: ","))") }
    ///  --show-notes[=<ref>]
    static func showNotes(_ ref: [String]) -> Self { .init("--show-notes=\(ref.joined(separator: ","))") }
    ///  --show-pulls
    static let showPulls: Self = "--show-pulls"
    ///  --show-signature
    static let showSignature: Self = "--show-signature"
    ///  --simplify-by-decoration
    static let simplifyByDecoration: Self = "--simplify-by-decoration"
    ///  --simplify-merges
    static let simplifyMerges: Self = "--simplify-merges"
    ///  --since=<date>
    static func since(_ date: String) -> Self { .init("--since=\(date)") }
    ///  --single-worktree
    static let singleWorktree: Self = "--single-worktree"
    ///  --skip-to=<file>
    static func skipTo(_ file: String) -> Self { .init("--skip-to=\(file)") }
    ///  --skip=<number>
    static func skip(_ number: String) -> Self { .init("--skip=\(number)") }
    ///  --source
    static let source: Self = "--source"
    ///  --sparse
    static let sparse: Self = "--sparse"
    ///  --src-prefix=<prefix>
    static func srcPrefix(_ prefix: String) -> Self { .init("--src-prefix=\(prefix)") }
    ///  --standard-notes
    static let standardNotes: Self = "--standard-notes"
    ///  --stat[=<width>[,<name-width>[,<count>]]]
    static func statNameWidthCount(_ width: String) -> Self { .init("--stat[[,<name-width>[,<count>]]]=\(width)") }
    ///  --stdin
    static let stdin: Self = "--stdin"
    ///  --submodule[=<format>]
    static func submodule(_ format: [String]) -> Self { .init("--submodule=\(format.joined(separator: ","))") }
    ///  --summary
    static let summary: Self = "--summary"
    ///  --tags[=<pattern>]
    static func tags(_ pattern: [String]) -> Self { .init("--tags=\(pattern.joined(separator: ","))") }
    ///  --text
    static let text: Self = "--text"
    ///  --textconv
    static let textconv: Self = "--textconv"
    ///  --topo-order
    static let topoOrder: Self = "--topo-order"
    ///  --unified=<n>
    static func unified(_ n: String) -> Self { .init("--unified=\(n)") }
    ///  --until=<date>
    static func until(_ date: String) -> Self { .init("--until=\(date)") }
    ///  --use-mailmap
    static let useMailmap: Self = "--use-mailmap"
    ///  --walk-reflogs
    static let walkReflogs: Self = "--walk-reflogs"
    ///  --word-diff-regex=<regex>
    static func wordDiffRegex(_ regex: String) -> Self { .init("--word-diff-regex=\(regex)") }
    ///  --word-diff[=<mode>]
    static func wordDiff(_ mode: [String]) -> Self { .init("--word-diff=\(mode.joined(separator: ","))") }
    ///  --ws-error-highlight=<kind>
    static func wsErrorHighlight(_ kind: String) -> Self { .init("--ws-error-highlight=\(kind)") }
    enum Diffalgorithm: String {
        case patience
        case minimal
        case histogram
        case myers
    }
    ///  --diff-algorithm={patience|minimal|histogram|myers}
    static func diffAlgorithm(_ diffAlgorithm: Diffalgorithm) -> Self { .init("--diff-algorithm=\(diffAlgorithm.rawValue)") }
    enum Diffmerges: String {
        case off
        case none
        case on
        case firstParent = "first-parent"
        case _1 = "1"
        case separate
        case m
        case combined
        case c
        case denseCombined = "dense-combined"
        case cc
        case remerge
        case r
    }
    ///  --diff-merges=(off|none|on|first-parent|1|separate|m|combined|c|dense-combined|cc|remerge|r)
    static func diffMerges(_ diffMerges: Diffmerges) -> Self { .init("--diff-merges=\(diffMerges.rawValue)") }
    enum Nowalk: String {
        case sorted
        case unsorted
    }
    ///  --no-walk[=(sorted|unsorted)]
    static func noWalk(_ noWalk: Nowalk) -> Self { .init("--no-walk=\(noWalk.rawValue)") }
    
}
