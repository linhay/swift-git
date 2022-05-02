//
//  File.swift
//  
//
//  Created by linhey on 2022/4/29.
//

import Foundation

public extension Repository {
    
    struct Status {
        
        struct Changes {
            var modified: [String]
            var deleted: [String]
        }
        
        struct Branch {
            var oid: String
            var head: String
            var upstream: String
        }
        
        var branch: Branch
        let changes: Changes
        let untracked: [String]
    }
    
    func status() throws -> Status {
        let string = try statusOutput(.porcelain(.v2), .branch)
        var branch = Status.Branch(oid: "", head: "", upstream: "")
        var changes = Status.Changes(modified: [], deleted: [])
        var untracked: [String] = []
        
        for line in string.split(separator: "\n").map(\.description) {
            
            if line.hasPrefix("# ") {
                let list = line.split(separator: " ").dropFirst().map(\.description)
                switch list.first! {
                case "branch.oid": branch.oid = list.last ?? ""
                case "branch.head": branch.head = list.last ?? ""
                case "branch.upstream": branch.upstream = list.last ?? ""
                default:
                    continue
                }
                continue
            }
            
            if line.hasPrefix("1 .M ") {
                let list = line.split(separator: " ").dropFirst().map(\.description)
                changes.modified.append(list.last!)
                continue
            }
            
            if line.hasPrefix("1 .D ") {
                let list = line.split(separator: " ").dropFirst().map(\.description)
                changes.deleted.append(list.last!)
                continue
            }
            
            if line.hasPrefix("? ") {
                let list = line.split(separator: " ").dropFirst().map(\.description)
                untracked.append(list.last!)
                continue
            }
        }
        
        return .init(branch: branch, changes: changes, untracked: untracked)
    }
    
    func statusOutput(_ options: [StatusOptions] = []) throws -> String {
        return try run((["status"] + options.map(\.rawValue)))
    }
    
    func statusOutput(_ options: StatusOptions...) throws -> String {
        return try statusOutput(options)
    }
    
}

public struct StatusOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
}

public extension StatusOptions {
    /**
     除了显示被修改的文件名外，还显示被分阶段提交的文本修改（即，像`git diff --cached`的输出）。如果`-v`被指定了两次，那么也会显示工作树中尚未分阶段的变化（即，像`git diff`的输出）。
     In addition to the names of files that have been changed, also show the textual changes that are staged to be committed (i.e., like the output of git diff --cached).
     If -v is specified twice, then also show the changes in the working tree that have not yet been staged (i.e., like the output of git diff).
     */
    static let verbose: StatusOptions = "--verbose"
    
    /// 以简短的形式给出输出。
    /// Give the output in the short-format.
    static let short: StatusOptions = "--short"
    
    /// 给出长格式的输出。这是默认的。
    /// Give the output in the long-format. This is the default.
    static let long: StatusOptions = "--long"
    
    /// 即使在短文中也要显示分支和跟踪信息。
    /// Show the branch and tracking info even in short-format.
    static let branch: StatusOptions = "--branch"
    
    /// 显示目前藏匿的条目数量。
    /// Show the number of entries currently stashed away.
    static let showStash: StatusOptions = "--show-stash"
    
    /// 显示或不显示该分支相对于其上游分支的详细超前/滞后计数。 默认为true。
    /// compute full ahead/behind values
    static func aheadBehind(_ flag: Bool) -> StatusOptions { flag ? "--ahead-behind" : "--no-ahead-behind" }
    
    /// 用NUL而不是LF来终止条目。 如果没有给出其他格式，这就意味着`--porcelain=v1`的输出格式。
    /// terminate entries with NUL
    static let null: StatusOptions = "--null"
    
    /// 开启/关闭重名检测，不受用户配置影响。
    /// do not detect renames
    static func renames(_ flag: Bool) -> StatusOptions { flag ? "--renames" : "--no-renames" }
    
    /// 开启重名检测，可选择设置相似度阈值。
    /// 检测重命名。如果n指定，它是相似性指数的阈值（即添加/删除量与文件大小相比）。例如，-M90%意味着如果超过 90% 的文件没有更改，Git 应该将删除/添加对视为重命名。如果没有%符号，数字将被读取为分数，前面有小数点。即，-M5变为 0.5，因此与 相同-M50%。同样，-M05与 相同-M5%。要将检测限制为精确的重命名，请使用 -M100%. 默认相似度指数为 50%。
    /// detect renames, optionally set similarity index
    /// - Parameter n: 0-100
    static func findRenames(_ n: Int) -> StatusOptions {
        .init(stringLiteral: "--find-renames=-M\(n)%")
    }
    
    enum Column: String {
        case no
    }
    
    /// list untracked files in columns
    static func column(_ style: Column) -> StatusOptions {
        .init(stringLiteral: "--column=\(style.rawValue)")
    }
    
    enum Ignored: String {
        /// [Default] 显示被忽略的文件和目录，除非 --untracked-files=all is specified, in which case individual files in ignored directories are displayed.
        case traditional
        /// 不显示被忽略的文件。
        case matching
        /// 不显示被忽略的文件。
        case no
    }
    
    /**
     也显示忽略的文件。
     模式参数用于指定对被忽略文件的处理。 它是可选的：默认为 "traditional"。
     show ignored files, optional modes: traditional, matching, no. (Default: traditional)
     */
    static func ignored(_ mode: Ignored) -> StatusOptions {
        .init(stringLiteral: "--ignored=\(mode.rawValue)")
    }
    
    enum IgnoreSubmodules: String {
        case none
        case all
        case dirty
        case untracked
    }
    
    /**
     在寻找变化时忽略子模块的变化。<when>可以是
     - none: 當子模塊包含未被追蹤或修訂的檔案，或者它的頭部與超級工程中記錄的提交不同時，就會認為子模塊被修改了，可以用來覆蓋 git-config[1] 或 gitmodules[5] 中 "忽略 "選項的任何設定。
     - untracked: 当子模块只包含未跟踪的内容时，不被认为是脏的（但它们仍然被扫描为修改的内容）。
     - dirty: 会忽略所有对子模块工作树的修改，只显示存储在超级项目中的提交的修改（这是1.7.0之前的行为）。
     - all: 这是默认的. 会隐藏子模块的所有变化（当配置选项`status.submoduleSummary`被设置时，会抑制子模块摘要的输出）。
     */
    /// ignore changes to submodules, optional when: all, dirty, untracked. (Default: all)
    static func ignoreSubmodules(_ when: IgnoreSubmodules) -> StatusOptions {
        .init(stringLiteral: "--ignored=\(when.rawValue)")
    }
    
    /**
     以易于解析的格式给出脚本的输出。 这类似于简短的输出，但在不同的Git版本中，无论用户配置如何，都会保持稳定。
     版本参数用于指定格式版本。 这是可选的，默认为原始版本的 "v1 "格式。
     Give the output in an easy-to-parse format for scripts. This is similar to the short output, but will remain stable across Git versions and regardless of user
     configuration. See below for details.
     The version parameter is used to specify the format version. This is optional and defaults to the original version v1 format.
     */
    static func porcelain(_ version: PorcelainMode) -> StatusOptions {
        .init(stringLiteral: "--porcelain=\(version.rawValue)")
    }
    
    /**
     模式参数用于指定对未跟踪文件的处理。 它是可选的：默认为 "所有"，如果指定，必须与选项卡在一起（例如，-uno，但不是`-u no`）。
     
     可能的选择是:
     - no: 不显示未跟踪的文件。
     - normal: 显示未被追踪的文件和目录。
     - all: 也显示未被追踪的目录中的单个文件。
     
     当不使用`-u`选项时，将显示未跟踪的文件和目录（即与指定`normal`相同），以帮助你避免忘记添加新创建的文件。 因为在文件系统中寻找未跟踪的文件需要额外的工作，在一个大的工作树中，这种模式可能需要一些时间。 如果支持的话，考虑启用无痕缓存和分割索引（见`git upd-index --untracked-cache`和`git upd-index --split-index`），否则你可以使用`no`来让`git status`更快地返回而不显示无痕文件。
     默认值可以用git-config[1]中记载的 status.showUntrackedFiles 配置变量来改变。
     
     Show untracked files.
     
     The mode parameter is used to specify the handling of untracked files. It is optional: it defaults to all, and if specified, it must be stuck to the option (e.g.
     -uno, but not -u no).
     
     The possible options are:
     - no: Show no untracked files.
     - normal: Shows untracked files and directories.
     */
    static func untrackedFiles(_ mode: UntrackedFilesMode) -> StatusOptions {
        .init(stringLiteral: "--untracked-files=\(mode.rawValue)")
    }
}
