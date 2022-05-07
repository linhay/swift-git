public struct ShowOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension ShowOptions {

    ///  --abbrev-commit
static let abbrevCommit: Self = "--abbrev-commit"
    ///  --abbrev[=<n>]
    static func abbrev(n: [String]) -> Self { .init("--abbrev=\(n.joined(separator: ","))") }
    ///  --anchored=<text>
    static func anchored(text: String) -> Self { .init("--anchored=\(text)") }
    ///  --binary
static let binary: Self = "--binary"
    ///  --break-rewrites[=[<n>][/<m>]]
    static func breakRewrites(m: String, n: [String]) -> Self { .init("--break-rewrites[[/]]=\(m) \(n.joined(separator: ","))") }
    ///  --cc
static let cc: Self = "--cc"
    ///  --check
static let check: Self = "--check"
    ///  --color-moved-ws=<modes>
    static func colorMovedWs(modes: String) -> Self { .init("--color-moved-ws=\(modes)") }
    ///  --color-moved[=<mode>]
    static func colorMoved(mode: [String]) -> Self { .init("--color-moved=\(mode.joined(separator: ","))") }
    ///  --color-words[=<regex>]
    static func colorWords(regex: [String]) -> Self { .init("--color-words=\(regex.joined(separator: ","))") }
    ///  --color[=<when>]
    static func color(when: [String]) -> Self { .init("--color=\(when.joined(separator: ","))") }
    ///  --combined-all-paths
static let combinedAllPaths: Self = "--combined-all-paths"
    ///  --compact-summary
static let compactSummary: Self = "--compact-summary"
    ///  --cumulative
static let cumulative: Self = "--cumulative"
    ///  --diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]
    static func diffFilterACDMRTUXB() -> Self { .init("--diff-filter[(A|C|D|M|R|T|U|X|B)…​[*]]=") }
    ///  --dirstat-by-file[=<param1,param2>…​]
    static func dirstatByFileParam1Param2() -> Self { .init("--dirstat-by-file[<param1,param2>…​]=") }
    ///  --dirstat[=<param1,param2,…​>]
    static func dirstatParam1Param2() -> Self { .init("--dirstat[<param1,param2,…​>]=") }
    ///  --dst-prefix=<prefix>
    static func dstPrefix(prefix: String) -> Self { .init("--dst-prefix=\(prefix)") }
    ///  --encoding=<encoding>
    static func encoding(encoding: String) -> Self { .init("--encoding=\(encoding)") }
    ///  --expand-tabs
static let expandTabs: Self = "--expand-tabs"
    ///  --expand-tabs=<n>
    static func expandTabs(n: String) -> Self { .init("--expand-tabs=\(n)") }
    ///  --ext-diff
static let extDiff: Self = "--ext-diff"
    ///  --find-copies-harder
static let findCopiesHarder: Self = "--find-copies-harder"
    ///  --find-copies[=<n>]
    static func findCopies(n: [String]) -> Self { .init("--find-copies=\(n.joined(separator: ","))") }
    ///  --find-object=<object-id>
    static func findObject(objectId: String) -> Self { .init("--find-object=\(objectId)") }
    ///  --find-renames[=<n>]
    static func findRenames(n: [String]) -> Self { .init("--find-renames=\(n.joined(separator: ","))") }
    ///  --format=<format>
    static func format(format: String) -> Self { .init("--format=\(format)") }
    ///  --full-index
static let fullIndex: Self = "--full-index"
    ///  --function-context
static let functionContext: Self = "--function-context"
    ///  --histogram
static let histogram: Self = "--histogram"
    ///  --ignore-all-space
static let ignoreAllSpace: Self = "--ignore-all-space"
    ///  --ignore-blank-lines
static let ignoreBlankLines: Self = "--ignore-blank-lines"
    ///  --ignore-cr-at-eol
static let ignoreCrAtEol: Self = "--ignore-cr-at-eol"
    ///  --ignore-matching-lines=<regex>
    static func ignoreMatchingLines(regex: String) -> Self { .init("--ignore-matching-lines=\(regex)") }
    ///  --ignore-space-at-eol
static let ignoreSpaceAtEol: Self = "--ignore-space-at-eol"
    ///  --ignore-space-change
static let ignoreSpaceChange: Self = "--ignore-space-change"
    ///  --ignore-submodules[=<when>]
    static func ignoreSubmodules(when: [String]) -> Self { .init("--ignore-submodules=\(when.joined(separator: ","))") }
    ///  --indent-heuristic
static let indentHeuristic: Self = "--indent-heuristic"
    ///  --inter-hunk-context=<lines>
    static func interHunkContext(lines: String) -> Self { .init("--inter-hunk-context=\(lines)") }
    ///  --irreversible-delete
static let irreversibleDelete: Self = "--irreversible-delete"
    ///  --ita-invisible-in-index
static let itaInvisibleInIndex: Self = "--ita-invisible-in-index"
    ///  --line-prefix=<prefix>
    static func linePrefix(prefix: String) -> Self { .init("--line-prefix=\(prefix)") }
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
    ///  --no-diff-merges
static let noDiffMerges: Self = "--no-diff-merges"
    ///  --no-expand-tabs
static let noExpandTabs: Self = "--no-expand-tabs"
    ///  --no-ext-diff
static let noExtDiff: Self = "--no-ext-diff"
    ///  --no-indent-heuristic
static let noIndentHeuristic: Self = "--no-indent-heuristic"
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
    ///  --notes[=<ref>]
    static func notes(ref: [String]) -> Self { .init("--notes=\(ref.joined(separator: ","))") }
    ///  --numstat
static let numstat: Self = "--numstat"
    ///  --oneline
static let oneline: Self = "--oneline"
    ///  --output-indicator-context=<char>
    static func outputIndicatorContext(char: String) -> Self { .init("--output-indicator-context=\(char)") }
    ///  --output-indicator-new=<char>
    static func outputIndicatorNew(char: String) -> Self { .init("--output-indicator-new=\(char)") }
    ///  --output-indicator-old=<char>
    static func outputIndicatorOld(char: String) -> Self { .init("--output-indicator-old=\(char)") }
    ///  --output=<file>
    static func output(file: String) -> Self { .init("--output=\(file)") }
    ///  --patch
static let patch: Self = "--patch"
    ///  --patch-with-raw
static let patchWithRaw: Self = "--patch-with-raw"
    ///  --patch-with-stat
static let patchWithStat: Self = "--patch-with-stat"
    ///  --patience
static let patience: Self = "--patience"
    ///  --pickaxe-all
static let pickaxeAll: Self = "--pickaxe-all"
    ///  --pickaxe-regex
static let pickaxeRegex: Self = "--pickaxe-regex"
    ///  --pretty[=<format>]
    static func pretty(format: [String]) -> Self { .init("--pretty=\(format.joined(separator: ","))") }
    ///  --raw
static let raw: Self = "--raw"
    ///  --relative[=<path>]
    static func relative(path: [String]) -> Self { .init("--relative=\(path.joined(separator: ","))") }
    ///  --rename-empty
static let renameEmpty: Self = "--rename-empty"
    ///  --rotate-to=<file>
    static func rotateTo(file: String) -> Self { .init("--rotate-to=\(file)") }
    ///  --shortstat
static let shortstat: Self = "--shortstat"
    ///  --show-notes[=<ref>]
    static func showNotes(ref: [String]) -> Self { .init("--show-notes=\(ref.joined(separator: ","))") }
    ///  --show-signature
static let showSignature: Self = "--show-signature"
    ///  --skip-to=<file>
    static func skipTo(file: String) -> Self { .init("--skip-to=\(file)") }
    ///  --src-prefix=<prefix>
    static func srcPrefix(prefix: String) -> Self { .init("--src-prefix=\(prefix)") }
    ///  --standard-notes
static let standardNotes: Self = "--standard-notes"
    ///  --stat[=<width>[,<name-width>[,<count>]]]
    static func statNameWidthCount(width: String) -> Self { .init("--stat[[,<name-width>[,<count>]]]=\(width)") }
    ///  --submodule[=<format>]
    static func submodule(format: [String]) -> Self { .init("--submodule=\(format.joined(separator: ","))") }
    ///  --summary
static let summary: Self = "--summary"
    ///  --text
static let text: Self = "--text"
    ///  --textconv
static let textconv: Self = "--textconv"
    ///  --unified=<n>
    static func unified(n: String) -> Self { .init("--unified=\(n)") }
    ///  --word-diff-regex=<regex>
    static func wordDiffRegex(regex: String) -> Self { .init("--word-diff-regex=\(regex)") }
    ///  --word-diff[=<mode>]
    static func wordDiff(mode: [String]) -> Self { .init("--word-diff=\(mode.joined(separator: ","))") }
    ///  --ws-error-highlight=<kind>
    static func wsErrorHighlight(kind: String) -> Self { .init("--ws-error-highlight=\(kind)") }
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
enum Gitshowsformatsv100: String {
case commit
}
    ///  git show -s --format=%s v1.0.0^{commit}
    static func gitShowSFormatSV100(_ gitShowSFormatSV100: Gitshowsformatsv100) -> Self { .init("git show -s --format%s v1.0.0^=\(gitShowSFormatSV100.rawValue)") }

}