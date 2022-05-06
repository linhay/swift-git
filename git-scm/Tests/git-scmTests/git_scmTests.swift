import XCTest
import Foundation
//@testable import git_scm
import Stem

final class git_scmTests: XCTestCase {
    
    let folder = try! FilePath.Folder(path: "~/Desktop/SwiftGit/git-scm/Sources/git-scm").create()
    
    func js() {
"""
var list = [];
for (let item of document.getElementsByClassName('hdlist1')) {
    if (item.textContent.indexOf("--") > 0) {
         list.push(`"${item.textContent.trim()}"`)
    }
}
`[${list.join(", ")}]`
"""
    }
    
    func testDocBranchingAndMerging() throws {
        let dict = [
            "branch": ["--delete", "--create-reflog", "--force", "--move", "--copy", "--color[=<when>]", "--no-color", "--ignore-case", "--column[=<options>]", "--no-column", "--remotes", "--all", "--list", "--show-current", "--verbose", "--quiet", "--abbrev=<n>", "--no-abbrev", "--track[=(direct|inherit)]", "--no-track", "--recurse-submodules", "--set-upstream", "--set-upstream-to=<upstream>", "--unset-upstream", "--edit-description", "--contains [<commit>]", "--no-contains [<commit>]", "--merged [<commit>]", "--no-merged [<commit>]", "--sort=<key>", "--points-at <object>", "--format <format>"],
            
            "checkout": [
                "--quiet", "--progress", "--no-progress", "--force", "--ours", "--theirs", "--track[=(direct|inherit)]", "--no-track", "--guess", "--no-guess", "--detach", "--orphan <new-branch>", "--ignore-skip-worktree-bits", "--merge", "--conflict=<style>", "--patch", "--ignore-other-worktrees", "--overwrite-ignore", "--no-overwrite-ignore", "--recurse-submodules", "--no-recurse-submodules", "--overlay", "--no-overlay", "--pathspec-from-file=<file>", "--pathspec-file-nul", "--"],
            "switch": ["--create <new-branch>", "--force-create <new-branch>", "--detach"],
            
            "merge": ["--commit", "--no-commit", "--edit", "--no-edit", "--cleanup=<mode>", "--ff", "--no-ff", "--ff-only", "--gpg-sign[=<keyid>]", "--no-gpg-sign", "--log[=<n>]", "--no-log", "--signoff", "--no-signoff", "--stat", "--no-stat", "--squash", "--no-squash", "--[no-]verify", "--strategy=<strategy>", "--strategy-option=<option>", "--verify-signatures", "--no-verify-signatures", "--summary", "--no-summary", "--quiet", "--verbose", "--progress", "--no-progress", "--autostash", "--no-autostash", "--allow-unrelated-histories", "--into-name <branch>", "--file=<file>", "--rerere-autoupdate", "--no-rerere-autoupdate", "--overwrite-ignore", "--no-overwrite-ignore", "--abort", "--quit", "--continue"],
            "mergetool": ["--tool=<tool>", "--tool-help", "--no-prompt", "--prompt", "--gui", "--no-gui"],
            
            "log": [
                // "[--] <path>…​",
                "--follow", "--no-decorate", "--decorate[=short|full|auto|no]", "--decorate-refs=<pattern>", "--decorate-refs-exclude=<pattern>", "--source", "--[no-]mailmap", "--[no-]use-mailmap", "--full-diff", "--log-size",
                    "--max-count=<number>", "--skip=<number>", "--since=<date>", "--after=<date>", "--until=<date>", "--before=<date>", "--author=<pattern>", "--committer=<pattern>", "--grep-reflog=<pattern>", "--grep=<pattern>", "--all-match", "--invert-grep", "--regexp-ignore-case", "--basic-regexp", "--extended-regexp", "--fixed-strings", "--perl-regexp", "--remove-empty", "--merges", "--no-merges", "--min-parents=<number>", "--max-parents=<number>", "--no-min-parents", "--no-max-parents", "--first-parent", "--exclude-first-parent-only", "--not", "--all", "--branches[=<pattern>]", "--tags[=<pattern>]", "--remotes[=<pattern>]", "--glob=<glob-pattern>", "--exclude=<glob-pattern>", "--reflog", "--alternate-refs", "--single-worktree", "--ignore-missing", "--bisect", "--stdin", "--cherry-mark", "--cherry-pick", "--left-only", "--right-only", "--cherry", "--walk-reflogs", "--merge", "--boundary", "--simplify-by-decoration", "--full-history", "--simplify-merges",
                    "--ancestry-path",
                    "--full-history without parent rewriting", "--full-history with parent rewriting", "--dense", "--sparse", 
                    "--show-pulls", "--date-order", "--author-date-order", "--topo-order", "--reverse", "--no-walk[=(sorted|unsorted)]", "--do-walk", "--pretty[=<format>]", "--format=<format>", "--abbrev-commit", "--no-abbrev-commit", "--oneline", "--encoding=<encoding>", "--expand-tabs=<n>", "--expand-tabs", "--no-expand-tabs", "--notes[=<ref>]", "--no-notes", "--show-notes[=<ref>]", "--[no-]standard-notes", "--show-signature", "--relative-date", "--date=<format>", "--parents", "--children", "--left-right", "--graph", "--show-linear-break[=<barrier>]", "--patch", "--no-patch",
                    "--diff-merges=(off|none|on|first-parent|1|separate|m|combined|c|dense-combined|cc|remerge|r)",
                    "--no-diff-merges",
                    "--diff-merges=first-parent",
                    "--remerge-diff",
                    "--cc",
                    "--combined-all-paths",
                    "--unified=<n>",
                    "--output=<file>",
                    "--output-indicator-new=<char>",
                    "--output-indicator-old=<char>",
                    "--output-indicator-context=<char>",
                    "--raw",
                    "--patch-with-raw",
                    "--indent-heuristic",
                    "--no-indent-heuristic",
                    "--minimal",
                    "--patience",
                    "--histogram", "--anchored=<text>", "--diff-algorithm={patience|minimal|histogram|myers}", "--stat[=<width>[,<name-width>[,<count>]]]", "--compact-summary", "--numstat", "--shortstat", "--dirstat[=<param1,param2,…​>]", "--cumulative", "--dirstat-by-file[=<param1,param2>…​]", "--summary", "--patch-with-stat", "--name-only", "--name-status", "--submodule[=<format>]", "--color[=<when>]", "--no-color", "--color-moved[=<mode>]", "--no-color-moved", "--color-moved-ws=<modes>", "--no-color-moved-ws", "--word-diff[=<mode>]", "--word-diff-regex=<regex>", "--color-words[=<regex>]", "--no-renames", "--[no-]rename-empty", "--check", "--ws-error-highlight=<kind>", "--full-index", "--binary", "--abbrev[=<n>]", "--break-rewrites[=[<n>][/<m>]]", "--find-renames[=<n>]", "--find-copies[=<n>]", "--find-copies-harder", "--irreversible-delete", "--diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]", "--find-object=<object-id>", "--pickaxe-all", "--pickaxe-regex", "--skip-to=<file>", "--rotate-to=<file>", "--relative[=<path>]", "--no-relative", "--text", "--ignore-cr-at-eol", "--ignore-space-at-eol", "--ignore-space-change", "--ignore-all-space", "--ignore-blank-lines", "--ignore-matching-lines=<regex>", "--inter-hunk-context=<lines>", "--function-context", "--ext-diff", "--no-ext-diff", "--textconv", "--no-textconv", "--ignore-submodules[=<when>]", "--src-prefix=<prefix>", "--dst-prefix=<prefix>", "--no-prefix", "--line-prefix=<prefix>", "--ita-invisible-in-index"
                   ],
            
            "stash": ["push [-p|--patch] [-S|--staged] [-k|--[no-]keep-index] [-u|--include-untracked] [-a|--all] [-q|--quiet] [-m|--message <message>] [--pathspec-from-file=<file> [--pathspec-file-nul]] [--] [<pathspec>…​]", "save [-p|--patch] [-S|--staged] [-k|--[no-]keep-index] [-u|--include-untracked] [-a|--all] [-q|--quiet] [<message>]", "show [-u|--include-untracked|--only-untracked] [<diff-options>] [<stash>]", "pop [--index] [-q|--quiet] [<stash>]", "apply [--index] [-q|--quiet] [<stash>]", "drop [-q|--quiet] [<stash>]", "--all", "--include-untracked", "--no-include-untracked", "--only-untracked", "--index", "--keep-index", "--no-keep-index", "--patch", "--staged", "--pathspec-from-file=<file>", "--pathspec-file-nul", "--quiet", "--"],
            
            "tag": ["--annotate", "--sign", "--no-sign", "--local-user=<keyid>", "--force", "--delete", "--verify", "--list", "--sort=<key>", "--color[=<when>]", "--ignore-case", "--column[=<options>]", "--no-column", "--contains [<commit>]", "--no-contains [<commit>]", "--merged [<commit>]", "--no-merged [<commit>]", "--points-at <object>", "--message=<msg>", "--file=<file>", "--edit", "--cleanup=<mode>", "--create-reflog", "--format=<format>"],
            
            "worktree": ["--force", "--detach", "--[no-]checkout", "--[no-]guess-remote", "--[no-]track", "--lock", "--dry-run", "--porcelain", "--quiet", "--verbose", "--expire <time>", "--reason <string>"]
        ]
        
        try dict.forEach { (key, value) in
            try createFile(key: key, value: value)
        }
    }
    
    
    func testDocBasicSnapshotting() throws {
        let dict = [
            "add": [
                // "--chmod=(+|-)x",
                "--dry-run", "--verbose", "--force", "--sparse", "--interactive", "--patch", "--edit", "--update", "--all", "--no-ignore-removal", "--no-all", "--ignore-removal", "--intent-to-add", "--refresh", "--ignore-errors", "--ignore-missing", "--no-warn-embedded-repo", "--renormalize",
                "--pathspec-from-file=<file>", "--pathspec-file-nul", "--"],
            
            "status": ["--short", "--branch", "--show-stash", "--porcelain[=<version>]", "--long", "--verbose", "--untracked-files[=<mode>]", "--ignore-submodules[=<when>]", "--ignored[=<mode>]", "--column[=<options>]", "--no-column", "--ahead-behind", "--no-ahead-behind", "--renames", "--no-renames", "--find-renames[=<n>]"],
            
            "diff": [
                // "--diff-algorithm={patience|minimal|histogram|myers}",
                // "--diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]",
                // "--dirstat-by-file[=<param1,param2>…​]",
                // "--dirstat[=<param1,param2,…​>]",
                // "--break-rewrites[=[<n>][/<m>]]",
                // "--stat[=<width>[,<name-width>[,<count>]]]",
                // "-1 --base",
                // "-2 --ours",
                // "-3 --theirs",
                // "git-diff-index --cached <tree-ish>"
                "--patch", "--no-patch", "--unified=<n>", "--output=<file>", "--output-indicator-new=<char>", "--output-indicator-old=<char>", "--output-indicator-context=<char>", "--raw", "--patch-with-raw", "--indent-heuristic", "--no-indent-heuristic", "--minimal", "--patience", "--histogram", "--anchored=<text>",
                "--compact-summary", "--numstat", "--shortstat",
                "--cumulative",
                "--summary", "--patch-with-stat", "--name-only", "--name-status", "--submodule[=<format>]", "--color[=<when>]", "--no-color", "--color-moved[=<mode>]", "--no-color-moved", "--color-moved-ws=<modes>", "--no-color-moved-ws", "--word-diff[=<mode>]", "--word-diff-regex=<regex>", "--color-words[=<regex>]", "--no-renames", "--[no-]rename-empty", "--check", "--ws-error-highlight=<kind>", "--full-index", "--binary", "--abbrev[=<n>]",
                "--find-renames[=<n>]", "--find-copies[=<n>]", "--find-copies-harder", "--irreversible-delete",
                "--find-object=<object-id>", "--pickaxe-all", "--pickaxe-regex", "--skip-to=<file>", "--rotate-to=<file>", "--relative[=<path>]", "--no-relative", "--text", "--ignore-cr-at-eol", "--ignore-space-at-eol", "--ignore-space-change", "--ignore-all-space", "--ignore-blank-lines", "--ignore-matching-lines=<regex>", "--inter-hunk-context=<lines>", "--function-context", "--exit-code", "--quiet", "--ext-diff", "--no-ext-diff", "--textconv", "--no-textconv", "--ignore-submodules[=<when>]", "--src-prefix=<prefix>", "--dst-prefix=<prefix>", "--no-prefix", "--line-prefix=<prefix>", "--ita-invisible-in-index",
            ],
            
            "commit": [
                // "--trailer <token>[(=|:)<value>]",
                // "--fixup=[(amend|reword):]<commit>",
                "--all", "--patch", "--reuse-message=<commit>", "--reedit-message=<commit>",
                "--squash=<commit>", "--reset-author", "--short", "--branch", "--porcelain", "--long", "--null", "--file=<file>", "--author=<author>", "--date=<date>", "--message=<msg>", "--template=<file>", "--signoff", "--no-signoff",
                "--[no-]verify", "--allow-empty", "--allow-empty-message", "--cleanup=<mode>", "--edit", "--no-edit", "--amend", "--no-post-rewrite", "--include", "--only", "--pathspec-from-file=<file>", "--pathspec-file-nul", "--untracked-files[=<mode>]", "--verbose", "--quiet", "--dry-run", "--status", "--no-status", "--gpg-sign[=<keyid>]", "--no-gpg-sign", "--"],
            
            "notes": ["--force", "--message=<msg>", "--file=<file>", "--reuse-message=<object>", "--reedit-message=<object>", "--allow-empty", "--ref <ref>", "--ignore-missing", "--stdin", "--dry-run", "--strategy=<strategy>", "--commit", "--abort", "--quiet", "--verbose"],
            
            "restore": ["--source=<tree>", "--patch", "--worktree", "--staged", "--quiet", "--progress", "--no-progress", "--ours", "--theirs", "--merge", "--conflict=<style>", "--ignore-unmerged", "--ignore-skip-worktree-bits", "--recurse-submodules", "--no-recurse-submodules", "--overlay", "--no-overlay", "--pathspec-from-file=<file>", "--pathspec-file-nul", "--"],
            
            "reset": ["--soft", "--mixed", "--hard", "--merge", "--keep", "--[no-]recurse-submodules", "--quiet", "--refresh", "--no-refresh", "--pathspec-from-file=<file>", "--pathspec-file-nul", "--"],
            
            "rm": ["--force", "--dry-run", "--", "--cached", "--ignore-unmatch", "--sparse", "--quiet", "--pathspec-from-file=<file>", "--pathspec-file-nul"],
            
            "mv": ["--force", "--dry-run", "--verbose"],
        ]
        
        try dict.forEach { (key, value) in
            try createFile(key: key, value: value)
        }
    }
    
    func testDocGettingAndCreatingProjects() throws {
        let dict = [
            "init": ["--quiet",
                     "--bare",
                     "--object-format=<format>",
                     "--template=<template-directory>",
                     "--separate-git-dir=<git-dir>",
                     "--initial-branch=<branch-name>",
                     "--shared[=(false|true|umask|group|all|world|everybody|<perm>)]"
                    ],
            
            "clone": ["--local", "--no-hardlinks", "--shared", "--reference[-if-able] <repository>", "--dissociate", "--quiet", "--verbose", "--progress", "--server-option=<option>", "--no-checkout", "--[no-]reject-shallow", "--bare", "--sparse", "--filter=<filter-spec>", "--also-filter-submodules", "--mirror", "--origin <name>", "--branch <name>", "--upload-pack <upload-pack>", "--template=<template-directory>", "--config <key>=<value>", "--depth <depth>", "--shallow-since=<date>", "--shallow-exclude=<revision>", "--[no-]single-branch", "--no-tags", "--recurse-submodules[=<pathspec>]", "--[no-]shallow-submodules", "--[no-]remote-submodules", "--separate-git-dir=<git-dir>", "--jobs <n>"]
        ]
        
        try dict.forEach { (key, value) in
            try createFile(key: key, value: value)
        }
    }
    
    func testDocSetupAndConfig() throws {
        let dict = [
            "git": [
                //"--list-cmds=group[,group…​]"
                // "--config-env=<name>=<envvar>",
                "--version",
                "--help",
                "--exec-path[=<path>]",
                "--html-path",
                "--man-path",
                "--info-path",
                "--paginate",
                "--no-pager",
                "--git-dir=<path>",
                "--work-tree=<path>",
                "--namespace=<path>",
                "--super-prefix=<path>",
                "--bare",
                "--no-replace-objects",
                "--literal-pathspecs",
                "--glob-pathspecs",
                "--noglob-pathspecs",
                "--icase-pathspecs",
                "--no-optional-locks",
            ],
            
            "config": [
                "--replace-all",
                "--add",
                "--get",
                "--get-all",
                "--get-regexp",
                "--get-urlmatch <name> <URL>",
                "--global",
                "--system",
                "--local",
                "--worktree",
                "--file <configFile>",
                "--blob <blob>",
                "--remove-section",
                "--rename-section",
                "--unset",
                "--unset-all",
                "--list",
                "--fixed-value",
                "--type <type>",
                "--bool",
                "--int",
                "--bool-or-int",
                "--path",
                "--expiry-date",
                "--no-type",
                "--null",
                "--name-only",
                "--show-origin",
                "--show-scope",
                "--get-colorbool <name> [<stdout-is-tty>]",
                "--get-color <name> [<default>]",
                "--edit",
                "--includes",
                "--no-includes",
                "--default <value>"],
            
            "help": ["--all",
                     "--no-external-commands",
                     "--no-aliases",
                     "--verbose",
                     "--config",
                     "--guides",
                     "--info",
                     "--man",
                     "--web"],
            
            "bugreport": ["--output-directory <path>", "--suffix <format>"]
        ]
        
        try dict.forEach { (key, value) in
            try createFile(key: key, value: .init(Set(value)))
        }
        
    }
    
    func createFile(key: String, value: [String]) throws {
        let value = value.map { item -> [String] in
            if ["--"].contains(item) {
                return []
            }
            if item.contains("[no-]") {
                return [
                    item.replacingOccurrences(of: "[no-]", with: "no-"),
                    item.replacingOccurrences(of: "[no-]", with: "")
                ]
            } else if item.contains("[-if-able]") {
                return [
                    item.replacingOccurrences(of: "[-if-able]", with: "-if-able"),
                    item.replacingOccurrences(of: "[-if-able]", with: "")
                ]
            } else {
                return [item]
            }
        }.flatMap({ $0 })
        
        let content =
"""
public struct \(key.capitalized)Options: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension \(key.capitalized)Options {

\(try value.map(genFunc(_:)).sorted().joined(separator: "\n"))

}
"""
        try folder.open(name: "git-\(key).swift")
            .write(content.data(using: .utf8) ?? .init())
    }
    
    func name(_ string: String) -> String {
        let formatter = VariableFormatter(style: .camelCased)
        return formatter.string(string)
    }
    
    func testRegex() throws {
        print(try genFunc("--shared[=(false|true|umask|group|all|world|everybody|<perm>)]"))
    }
    
    func matchAndRemove(pattern: String, text: String) throws -> (String, [String]) {
        let regex = try NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: text, options: [], range: .init(location: 0, length: text.utf16.count))
        let replace = matches.map(\.range).map({ self.substring($0, in: text) })
        let parm = matches
            .filter({ $0.numberOfRanges >= 2 })
            .map({ $0.range(at: 1) })
            .map({ self.substring($0, in: text) })
            .filter({ $0.isEmpty == false })
        let str = replace
            .reduce(text, { $0.replacingOccurrences(of: $1, with: "") })
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return (str, parm)
    }
    
    func genFunc(_ text: String) throws -> String {
        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let mark = "    ///  \(text)\n"
        
        if ["<", "[", "{", "="].contains(where: { text.contains($0) }) == false {
            return mark + "static let \(name(text)): Self = \"\(text)\""
        }
        
        var list = try matchAndRemove(pattern: #"\[=<([\w-]+)>\]"#, text: text)
        if list.1.isEmpty {
            list = try matchAndRemove(pattern: #"\[<([\w-]+)>\]"#, text: text)
        }
        
        var `enum` = try matchAndRemove(pattern: #"\[=\(([\w\|<>]+)\)\]"#, text: list.0)
        if `enum`.1.isEmpty {
            `enum` = try matchAndRemove(pattern: #"\{([\w\|]+)\}"#, text: list.0)
        }
        if `enum`.1.isEmpty {
            `enum` = try matchAndRemove(pattern: #"=\(([\w\|-]+)\)"#, text: list.0)
        }
        
        var ivar = try matchAndRemove(pattern: #"=<([\w-]+)>"#, text: `enum`.0)
        if ivar.1.isEmpty {
            ivar = try matchAndRemove(pattern: #"<([\w-]+)>"#, text: `enum`.0)
        }
        
        let rawname  = ivar.0
            .replacingOccurrences(of: "=", with: "")
        let funcname = name(rawname)
        
        let cases = `enum`.1
            .map({ $0.split(separator: "|") })
            .flatMap({ $0 })
            .map(\.description)
            .map({ str in
                let casename = name(str)
                if casename != str {
                    return "case \(casename) = \"\(str)\""
                } else {
                    return "case \(casename)"
                }
            })
            .joined(separator: "\n")
        
        var enumCode = ""
        if cases.isEmpty == false {
            enumCode =
"""
enum \(funcname.capitalized): String {
\(cases)
}

"""
                .replacingOccurrences(of: "case <perm>", with: "// case <perm>")
        }
        
        let ivars = [
            (`enum`.1.isEmpty ? [] : ["_ \(funcname): \(funcname.capitalized)"]),
            ivar.1
                .map({ name($0) + ": String" }),
            list.1
                .map({ name($0) + ": [String]" })
        ]
            .filter({ $0.isEmpty == false })
            .map({ $0.joined(separator: ", ") })
            .joined(separator: ", ")
        
        let parms = [
            (`enum`.1.isEmpty ? [] : ["\\(\(funcname).rawValue)"]),
            ivar.1
                .map({ "\\(\(name($0)))" }),
            list.1
                .map({ "\\(\(name($0))" + #".joined(separator: ","))"# })
        ]
            .filter({ $0.isEmpty == false })
            .map({ $0.joined(separator: " ") })
            .joined(separator: " ")
        
        let separator = text.contains("=") ? "=" : " "
        return enumCode + mark + "    static func \(funcname)(\(ivars)) -> Self"
        + " { .init(\"\(rawname)\(separator)\(parms)\") }"
    }
    
    func substring(_ range: NSRange, in string: String) -> String {
        string[.init(utf16Offset: range.location, in: string)..<(.init(utf16Offset: range.location+range.length, in: string))].description
    }
    
}
