//
//  File.swift
//  
//
//  Created by linhey on 2022/5/2.
//

import Foundation

public extension Repository {

    func diff(options: [DiffOptions] = [], commands: [String]) throws -> String {
        return try run(["diff"] + options.map(\.rawValue) + commands)
    }
    
}

public struct DiffOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
}

public extension DiffOptions {
    
    /// Generate the diff in raw format.
    static let raw: DiffOptions = "--raw"
    /// Synonym for --dirstat=cumulative
    static let cumulative: DiffOptions = "--cumulative"
    /// Output a condensed summary of extended header information such as creations, renames and mode changes.
    static let summary: DiffOptions = "--summary"
    
    /// When --raw, --numstat, --name-only or --name-status has been given, do not munge pathnames and use NULs as output field terminators. Without this option, pathnames with "unusual" characters are quoted as explained for the configuration variable core.quotePath (see git-config[1]).
    static let z: DiffOptions = "-z"
    /// Show only names of changed files. The file names are often encoded in UTF-8. For more information see the discussion about encoding in the git-log[1] manual page.
    static let nameOnly: DiffOptions = "--name-only"
    /// Show only names and status of changed files. See the description of the --diff-filter option on what the status letters mean. Just like --name-only the file names are often encoded in UTF-8.
    static let nameStatus: DiffOptions = "--name-status"

    /// Similar to --stat, but shows number of added and deleted lines in decimal notation and pathname without abbreviation, to make it more machine friendly. For binary files, outputs two - instead of saying 0 0.
    static let numstat: DiffOptions = "--numstat"

    /// Output only the last line of the --stat format containing total number of modified files, as well as number of added and deleted lines.
    static let shortstat: DiffOptions = "--shortstat"

    ///Output a condensed summary of extended header information such as file creations or deletions ("new" or "gone", optionally "+l" if it’s a symlink) and mode changes ("+x" or "-x" for adding or removing executable bit respectively) in diffstat. The information is put between the filename part and the graph part. Implies --stat.
    static let compactSummary: DiffOptions = "--compact-summary"

    
    /// Enable the heuristic that shifts diff hunk boundaries to make patches easier to read. This is the default.
    static func indentHeuristic(_ flag: Bool) -> DiffOptions { .init(stringLiteral: flag ? "--indent-heuristic" : "--no-indent-heuristic") }

    
    /// Generate patch (see section on generating patches). This is the default.
    /// Suppress diff output. Useful for commands like git show that show the patch by default, or to cancel the effect of --patch.
    static func patch(_ flag: Bool) -> DiffOptions { .init(stringLiteral: flag ? "--patch" : "--no-patch") }

    /// Generate diffs with <n> lines of context instead of the usual three. Implies --patch.
    static func unified(_ n: Int) -> DiffOptions { .init(stringLiteral: "--unified=\(n)") }
    
    /// Output to a specific file instead of stdout.
    static func output(_ path: String) -> DiffOptions { .init(stringLiteral: "--output=\(path)") }
    
    enum OutputIndicator: String {
        case new
        case old
        case context
    }
    
    /// Specify the character used to indicate new, old or context lines in the generated patch. Normally they are +, - and ' ' respectively.
    static func outputIndicator(_ char: String, for: OutputIndicator) -> DiffOptions {
        .init(stringLiteral: "--output-indicator-\(`for`.rawValue)=\(char)")
    }
    
    enum DiffAlgorithm: String {
        case `default`
        case myers
        case minimal
        case patience
        case histogram
    }
    
    /**
     Choose a diff algorithm. The variants are as follows:

     - myers, default: The basic greedy diff algorithm. Currently, this is the default.
     - minimal: Spend extra time to make sure the smallest possible diff is produced.
     - patience: Use "patience diff" algorithm when generating patches.
     - histogram: This algorithm extends the patience algorithm to "support low-occurrence common elements".

     For instance, if you configured the diff.algorithm variable to a non-default value and want to use the default one, then you have to use --diff-algorithm=default option.
    */
    static func diffAlgorithm(_ algorithm: DiffAlgorithm) -> DiffOptions {
        .init(stringLiteral: "--diff-algorithm=\(algorithm.rawValue)")
    }
    
    /**
     Generate a diff using the "anchored diff" algorithm.

     This option may be specified more than once.

     If a line exists in both the source and destination, exists only once, and starts with this text, this algorithm attempts to prevent it from appearing as a deletion or addition in the output. It uses the "patience diff" algorithm internally.
     */
    static func anchored(_ text: String) -> DiffOptions {
        .init(stringLiteral: "--anchored=\(text)")
    }
    
    /** TODO
     --stat[=<宽度>[,<名称宽度>[,<计数>]]]
     生成差异统计。默认情况下，文件名部分将使用尽可能多的空间，其余部分用于图形部分。最大宽度默认为终端宽度，如果未连接到终端，则默认为 80 列，并且可以被覆盖 <width>。<name-width>文件名部分的宽度可以通过在逗号后给出另一个宽度来限制。--stat-graph-width=<width>可以通过使用（影响生成统计图的所有命令）或设置diff.statGraphWidth=<width> （不影响）来限制图形部分的宽度 git format-patch。通过提供第三个参数<count>，您可以将输出限制为第一行，如果还有更多则<count>紧随其后。...

     也可以使用 和 单独设置这些--stat-width=<width>参数 。--stat-name-width=<name-width>--stat-count=<count>

     --dirstat[=<param1,param2,…​>]
     Output the distribution of relative amount of changes for each sub-directory. The behavior of --dirstat can be customized by passing it a comma separated list of parameters. The defaults are controlled by the diff.dirstat configuration variable (see git-config[1]). The following parameters are available:

     changes
     Compute the dirstat numbers by counting the lines that have been removed from the source, or added to the destination. This ignores the amount of pure code movements within a file. In other words, rearranging lines in a file is not counted as much as other changes. This is the default behavior when no parameter is given.

     lines
     Compute the dirstat numbers by doing the regular line-based diff analysis, and summing the removed/added line counts. (For binary files, count 64-byte chunks instead, since binary files have no natural concept of lines). This is a more expensive --dirstat behavior than the changes behavior, but it does count rearranged lines within a file as much as other changes. The resulting output is consistent with what you get from the other --*stat options.

     files
     Compute the dirstat numbers by counting the number of files changed. Each changed file counts equally in the dirstat analysis. This is the computationally cheapest --dirstat behavior, since it does not have to look at the file contents at all.

     cumulative
     Count changes in a child directory for the parent directory as well. Note that when using cumulative, the sum of the percentages reported may exceed 100%. The default (non-cumulative) behavior can be specified with the noncumulative parameter.

     <limit>
     An integer parameter specifies a cut-off percent (3% by default). Directories contributing less than this percentage of the changes are not shown in the output.

     Example: The following will count changed files, while ignoring directories with less than 10% of the total amount of changed files, and accumulating child directory counts in the parent directories: --dirstat=files,10,cumulative.

     --dirstat-by-file[=<param1,param2>…​]
     Synonym for --dirstat=files,param1,param2…
     
     --submodule[=<format>]
     Specify how differences in submodules are shown. When specifying --submodule=short the short format is used. This format just shows the names of the commits at the beginning and end of the range. When --submodule or --submodule=log is specified, the log format is used. This format lists the commits in the range like git-submodule[1] summary does. When --submodule=diff is specified, the diff format is used. This format shows an inline diff of the changes in the submodule contents between the commit range. Defaults to diff.submodule or the short format if the config option is unset.

     --color[=<when>]
     Show colored diff. --color (i.e. without =<when>) is the same as --color=always. <when> can be one of always, never, or auto. It can be changed by the color.ui and color.diff configuration settings.

     --no-color
     Turn off colored diff. This can be used to override configuration settings. It is the same as --color=never.

     --color-moved[=<mode>]
     Moved lines of code are colored differently. It can be changed by the diff.colorMoved configuration setting. The <mode> defaults to no if the option is not given and to zebra if the option with no mode is given. The mode must be one of:

     no
     Moved lines are not highlighted.

     default
     Is a synonym for zebra. This may change to a more sensible mode in the future.

     plain
     Any line that is added in one location and was removed in another location will be colored with color.diff.newMoved. Similarly color.diff.oldMoved will be used for removed lines that are added somewhere else in the diff. This mode picks up any moved line, but it is not very useful in a review to determine if a block of code was moved without permutation.

     blocks
     Blocks of moved text of at least 20 alphanumeric characters are detected greedily. The detected blocks are painted using either the color.diff.{old,new}Moved color. Adjacent blocks cannot be told apart.

     zebra
     Blocks of moved text are detected as in blocks mode. The blocks are painted using either the color.diff.{old,new}Moved color or color.diff.{old,new}MovedAlternative. The change between the two colors indicates that a new block was detected.

     dimmed-zebra
     Similar to zebra, but additional dimming of uninteresting parts of moved code is performed. The bordering lines of two adjacent blocks are considered interesting, the rest is uninteresting. dimmed_zebra is a deprecated synonym.

     --no-color-moved
     Turn off move detection. This can be used to override configuration settings. It is the same as --color-moved=no.

     --color-moved-ws=<modes>
     This configures how whitespace is ignored when performing the move detection for --color-moved. It can be set by the diff.colorMovedWS configuration setting. These modes can be given as a comma separated list:

     no
     Do not ignore whitespace when performing move detection.

     ignore-space-at-eol
     Ignore changes in whitespace at EOL.

     ignore-space-change
     Ignore changes in amount of whitespace. This ignores whitespace at line end, and considers all other sequences of one or more whitespace characters to be equivalent.

     ignore-all-space
     Ignore whitespace when comparing lines. This ignores differences even if one line has whitespace where the other line has none.

     allow-indentation-change
     Initially ignore any whitespace in the move detection, then group the moved code blocks only into a block if the change in whitespace is the same per line. This is incompatible with the other modes.

     --no-color-moved-ws
     Do not ignore whitespace when performing move detection. This can be used to override configuration settings. It is the same as --color-moved-ws=no.

     --word-diff[=<mode>]
     Show a word diff, using the <mode> to delimit changed words. By default, words are delimited by whitespace; see --word-diff-regex below. The <mode> defaults to plain, and must be one of:

     color
     Highlight changed words using only colors. Implies --color.

     plain
     Show words as [-removed-] and {+added+}. Makes no attempts to escape the delimiters if they appear in the input, so the output may be ambiguous.

     porcelain
     Use a special line-based format intended for script consumption. Added/removed/unchanged runs are printed in the usual unified diff format, starting with a +/-/` ` character at the beginning of the line and extending to the end of the line. Newlines in the input are represented by a tilde ~ on a line of its own.

     none
     Disable word diff again.

     Note that despite the name of the first mode, color is used to highlight the changed parts in all modes if enabled.

     --word-diff-regex=<regex>
     Use <regex> to decide what a word is, instead of considering runs of non-whitespace to be a word. Also implies --word-diff unless it was already enabled.

     Every non-overlapping match of the <regex> is considered a word. Anything between these matches is considered whitespace and ignored(!) for the purposes of finding differences. You may want to append |[^[:space:]] to your regular expression to make sure that it matches all non-whitespace characters. A match that contains a newline is silently truncated(!) at the newline.

     For example, --word-diff-regex=. will treat each character as a word and, correspondingly, show differences character by character.

     The regex can also be set via a diff driver or configuration option, see gitattributes[5] or git-config[1]. Giving it explicitly overrides any diff driver or configuration setting. Diff drivers override configuration settings.

     --color-words[=<regex>]
     Equivalent to --word-diff=color plus (if a regex was specified) --word-diff-regex=<regex>.

     --no-renames
     Turn off rename detection, even when the configuration file gives the default to do so.

     --[no-]rename-empty
     Whether to use empty blobs as rename source.

     --check
     Warn if changes introduce conflict markers or whitespace errors. What are considered whitespace errors is controlled by core.whitespace configuration. By default, trailing whitespaces (including lines that consist solely of whitespaces) and a space character that is immediately followed by a tab character inside the initial indent of the line are considered whitespace errors. Exits with non-zero status if problems are found. Not compatible with --exit-code.

     --ws-error-highlight=<kind>
     Highlight whitespace errors in the context, old or new lines of the diff. Multiple values are separated by comma, none resets previous values, default reset the list to new and all is a shorthand for old,new,context. When this option is not given, and the configuration variable diff.wsErrorHighlight is not set, only whitespace errors in new lines are highlighted. The whitespace errors are colored with color.diff.whitespace.

     --full-index
     Instead of the first handful of characters, show the full pre- and post-image blob object names on the "index" line when generating patch format output.

     --binary
     In addition to --full-index, output a binary diff that can be applied with git-apply. Implies --patch.

     --abbrev[=<n>]
     Instead of showing the full 40-byte hexadecimal object name in diff-raw format output and diff-tree header lines, show the shortest prefix that is at least <n> hexdigits long that uniquely refers the object. In diff-patch output format, --full-index takes higher precedence, i.e. if --full-index is specified, full blob names will be shown regardless of --abbrev. Non default number of digits can be specified with --abbrev=<n>.

     -B[<n>][/<m>]
     --break-rewrites[=[<n>][/<m>]]
     Break complete rewrite changes into pairs of delete and create. This serves two purposes:

     It affects the way a change that amounts to a total rewrite of a file not as a series of deletion and insertion mixed together with a very few lines that happen to match textually as the context, but as a single deletion of everything old followed by a single insertion of everything new, and the number m controls this aspect of the -B option (defaults to 60%). -B/70% specifies that less than 30% of the original should remain in the result for Git to consider it a total rewrite (i.e. otherwise the resulting patch will be a series of deletion and insertion mixed together with context lines).

     When used with -M, a totally-rewritten file is also considered as the source of a rename (usually -M only considers a file that disappeared as the source of a rename), and the number n controls this aspect of the -B option (defaults to 50%). -B20% specifies that a change with addition and deletion compared to 20% or more of the file’s size are eligible for being picked up as a possible source of a rename to another file.

     -M[<n>]
     --find-renames[=<n>]
     Detect renames. If n is specified, it is a threshold on the similarity index (i.e. amount of addition/deletions compared to the file’s size). For example, -M90% means Git should consider a delete/add pair to be a rename if more than 90% of the file hasn’t changed. Without a % sign, the number is to be read as a fraction, with a decimal point before it. I.e., -M5 becomes 0.5, and is thus the same as -M50%. Similarly, -M05 is the same as -M5%. To limit detection to exact renames, use -M100%. The default similarity index is 50%.

     -C[<n>]
     --find-copies[=<n>]
     Detect copies as well as renames. See also --find-copies-harder. If n is specified, it has the same meaning as for -M<n>.

     --find-copies-harder
     For performance reasons, by default, -C option finds copies only if the original file of the copy was modified in the same changeset. This flag makes the command inspect unmodified files as candidates for the source of copy. This is a very expensive operation for large projects, so use it with caution. Giving more than one -C option has the same effect.

     -D
     --irreversible-delete
     Omit the preimage for deletes, i.e. print only the header but not the diff between the preimage and /dev/null. The resulting patch is not meant to be applied with patch or git apply; this is solely for people who want to just concentrate on reviewing the text after the change. In addition, the output obviously lacks enough information to apply such a patch in reverse, even manually, hence the name of the option.

     When used together with -B, omit also the preimage in the deletion part of a delete/create pair.

     -l<num>
     The -M and -C options involve some preliminary steps that can detect subsets of renames/copies cheaply, followed by an exhaustive fallback portion that compares all remaining unpaired destinations to all relevant sources. (For renames, only remaining unpaired sources are relevant; for copies, all original sources are relevant.) For N sources and destinations, this exhaustive check is O(N^2). This option prevents the exhaustive portion of rename/copy detection from running if the number of source/destination files involved exceeds the specified number. Defaults to diff.renameLimit. Note that a value of 0 is treated as unlimited.

     --diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]
     Select only files that are Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), have their type (i.e. regular file, symlink, submodule, …​) changed (T), are Unmerged (U), are Unknown (X), or have had their pairing Broken (B). Any combination of the filter characters (including none) can be used. When * (All-or-none) is added to the combination, all paths are selected if there is any file that matches other criteria in the comparison; if there is no file that matches other criteria, nothing is selected.

     Also, these upper-case letters can be downcased to exclude. E.g. --diff-filter=ad excludes added and deleted paths.

     Note that not all diffs can feature all types. For instance, copied and renamed entries cannot appear if detection for those types is disabled.

     -S<string>
     Look for differences that change the number of occurrences of the specified string (i.e. addition/deletion) in a file. Intended for the scripter’s use.

     It is useful when you’re looking for an exact block of code (like a struct), and want to know the history of that block since it first came into being: use the feature iteratively to feed the interesting block in the preimage back into -S, and keep going until you get the very first version of the block.

     Binary files are searched as well.

     -G<regex>
     Look for differences whose patch text contains added/removed lines that match <regex>.

     To illustrate the difference between -S<regex> --pickaxe-regex and -G<regex>, consider a commit with the following diff in the same file:

     +    return frotz(nitfol, two->ptr, 1, 0);
     ...
     -    hit = frotz(nitfol, mf2.ptr, 1, 0);
     While git log -G"frotz\(nitfol" will show this commit, git log -S"frotz\(nitfol" --pickaxe-regex will not (because the number of occurrences of that string did not change).

     Unless --text is supplied patches of binary files without a textconv filter will be ignored.

     See the pickaxe entry in gitdiffcore[7] for more information.

     --find-object=<object-id>
     Look for differences that change the number of occurrences of the specified object. Similar to -S, just the argument is different in that it doesn’t search for a specific string but for a specific object id.

     The object can be a blob or a submodule commit. It implies the -t option in git-log to also find trees.

     --pickaxe-all
     When -S or -G finds a change, show all the changes in that changeset, not just the files that contain the change in <string>.

     --pickaxe-regex
     Treat the <string> given to -S as an extended POSIX regular expression to match.

     -O<orderfile>
     Control the order in which files appear in the output. This overrides the diff.orderFile configuration variable (see git-config[1]). To cancel diff.orderFile, use -O/dev/null.

     The output order is determined by the order of glob patterns in <orderfile>. All files with pathnames that match the first pattern are output first, all files with pathnames that match the second pattern (but not the first) are output next, and so on. All files with pathnames that do not match any pattern are output last, as if there was an implicit match-all pattern at the end of the file. If multiple pathnames have the same rank (they match the same pattern but no earlier patterns), their output order relative to each other is the normal order.

     <orderfile> is parsed as follows:

     Blank lines are ignored, so they can be used as separators for readability.

     Lines starting with a hash ("#") are ignored, so they can be used for comments. Add a backslash ("\") to the beginning of the pattern if it starts with a hash.

     Each other line contains a single pattern.

     Patterns have the same syntax and semantics as patterns used for fnmatch(3) without the FNM_PATHNAME flag, except a pathname also matches a pattern if removing any number of the final pathname components matches the pattern. For example, the pattern "foo*bar" matches "fooasdfbar" and "foo/bar/baz/asdf" but not "foobarx".

     --skip-to=<file>
     --rotate-to=<file>
     Discard the files before the named <file> from the output (i.e. skip to), or move them to the end of the output (i.e. rotate to). These were invented primarily for use of the git difftool command, and may not be very useful otherwise.

     -R
     Swap two inputs; that is, show differences from index or on-disk file to tree contents.

     --relative[=<path>]
     --no-relative
     When run from a subdirectory of the project, it can be told to exclude changes outside the directory and show pathnames relative to it with this option. When you are not in a subdirectory (e.g. in a bare repository), you can name which subdirectory to make the output relative to by giving a <path> as an argument. --no-relative can be used to countermand both diff.relative config option and previous --relative.

     -a
     --text
     Treat all files as text.

     --ignore-cr-at-eol
     Ignore carriage-return at the end of line when doing a comparison.

     --ignore-space-at-eol
     Ignore changes in whitespace at EOL.

     -b
     --ignore-space-change
     Ignore changes in amount of whitespace. This ignores whitespace at line end, and considers all other sequences of one or more whitespace characters to be equivalent.

     -w
     --ignore-all-space
     Ignore whitespace when comparing lines. This ignores differences even if one line has whitespace where the other line has none.

     --ignore-blank-lines
     Ignore changes whose lines are all blank.

     -I<regex>
     --ignore-matching-lines=<regex>
     Ignore changes whose all lines match <regex>. This option may be specified more than once.

     --inter-hunk-context=<lines>
     Show the context between diff hunks, up to the specified number of lines, thereby fusing hunks that are close to each other. Defaults to diff.interHunkContext or 0 if the config option is unset.

     -W
     --function-context
     Show whole function as context lines for each change. The function names are determined in the same way as git diff works out patch hunk headers (see Defining a custom hunk-header in gitattributes[5]).

     --exit-code
     Make the program exit with codes similar to diff(1). That is, it exits with 1 if there were differences and 0 means no differences.

     --quiet
     Disable all output of the program. Implies --exit-code.

     --ext-diff
     Allow an external diff helper to be executed. If you set an external diff driver with gitattributes[5], you need to use this option with git-log[1] and friends.

     --no-ext-diff
     Disallow external diff drivers.

     --textconv
     --no-textconv
     Allow (or disallow) external text conversion filters to be run when comparing binary files. See gitattributes[5] for details. Because textconv filters are typically a one-way conversion, the resulting diff is suitable for human consumption, but cannot be applied. For this reason, textconv filters are enabled by default only for git-diff[1] and git-log[1], but not for git-format-patch[1] or diff plumbing commands.

     --ignore-submodules[=<when>]
     Ignore changes to submodules in the diff generation. <when> can be either "none", "untracked", "dirty" or "all", which is the default. Using "none" will consider the submodule modified when it either contains untracked or modified files or its HEAD differs from the commit recorded in the superproject and can be used to override any settings of the ignore option in git-config[1] or gitmodules[5]. When "untracked" is used submodules are not considered dirty when they only contain untracked content (but they are still scanned for modified content). Using "dirty" ignores all changes to the work tree of submodules, only changes to the commits stored in the superproject are shown (this was the behavior until 1.7.0). Using "all" hides all changes to submodules.

     --src-prefix=<prefix>
     Show the given source prefix instead of "a/".

     --dst-prefix=<prefix>
     Show the given destination prefix instead of "b/".

     --no-prefix
     Do not show any source or destination prefix.

     --line-prefix=<prefix>
     Prepend an additional prefix to every line of output.

     --ita-invisible-in-index
     By default entries added by "git add -N" appear as an existing empty file in "git diff" and a new file in "git diff --cached". This option makes the entry appear as a new file in "git diff" and non-existent in "git diff --cached". This option could be reverted with --ita-visible-in-index. Both options are experimental and could be removed in future.

     For more detailed explanation on these common options, see also gitdiffcore[7].

     -1 --base
     -2 --ours
     -3 --theirs
     Compare the working tree with the "base" version (stage #1), "our branch" (stage #2) or "their branch" (stage #3). The index contains these stages only for unmerged entries i.e. while resolving conflicts. See git-read-tree[1] section "3-Way Merge" for detailed information.

     -0
     Omit diff output for unmerged entries and just show "Unmerged". Can be used only when comparing the working tree with the index.

     <path>…
     The <paths> parameters, when given, are used to limit the diff to the named paths (you can give directory names and get diff for all files under them).
     */
    
}
