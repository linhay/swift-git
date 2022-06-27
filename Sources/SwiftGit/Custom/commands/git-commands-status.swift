//
//  File.swift
//  
//
//  Created by linhey on 2022/4/29.
//

import Foundation

public extension Git {
    
    func status(_ pathspec: String) throws -> GitStatus {
        let string = try status([.porcelain(.v2), .branch], pathspec: pathspec)
        var status = GitStatus()
        
        for line in string.split(separator: "\n").map(\.description) {
            
            if line.hasPrefix("# ") {
                let list = line.split(separator: " ").dropFirst().map(\.description)
                switch list[0] {
                case "branch.oid": status.branch.oid = list.last ?? ""
                case "branch.head": status.branch.head = list.last ?? ""
                case "branch.upstream": status.branch.upstream = list.last ?? ""
                case "branch.ab": status.branch.ab = .init(ahead: list[1], behind: list[2])
                default:
                    continue
                }
                continue
            }
            
            if line.hasPrefix("1 ") {
                let list = line.split(separator: " ").dropFirst().map(\.description)
                status.changed.append(.init(XY: list[0],
                                            sub: list[1],
                                            mH: list[2],
                                            mI: list[3],
                                            mW: list[4],
                                            hH: list[5],
                                            hI: list[6],
                                            path: list.dropFirst(7).joined(separator: " ")))
                continue
            }
            
            if line.hasPrefix("2 ") {
                let list = line.split(separator: " ").dropFirst().map(\.description)
                status.renamedCopied.append(.init(XY: list[0],
                                                  sub: list[1],
                                                  mH: list[2],
                                                  mI: list[3],
                                                  mW: list[4],
                                                  hH: list[5],
                                                  hI: list[6],
                                                  X: list[7],
                                                  path: list[8],
                                                  score: list[9],
                                                  sep: list[10],
                                                  origPath: list.dropFirst(11).joined(separator: " ")))
                continue
            }
            
            if line.hasPrefix("u ") {
                let list = line.split(separator: " ").dropFirst().map(\.description)
                status.unmerged.append(.init(XY: list[0],
                                             sub: list[1],
                                             m1: list[2],
                                             m2: list[3],
                                             m3: list[4],
                                             mW: list[5],
                                             h1: list[6],
                                             h2: list[7],
                                             h3: list[8],
                                             path: list.dropFirst(9).joined(separator: " ")))
                continue
            }
            
            if line.hasPrefix("? ") {
                status.untracked.append(.init(path: String(line.dropFirst("? ".count))))
                continue
            }
        }
        
        return status
    }
    
    func status(_ options: [StatusOptions], pathspec: String) throws -> String {
        return try run(["status"] + options.map(\.rawValue),
                       currentDirectoryURL: .init(fileURLWithPath: pathspec))
    }
    
    
    
}

public extension Repository {
    
    func status() throws -> GitStatus {
        try git.status(localURL.path)
    }
    
    func status(_ options: [StatusOptions]) throws -> String {
        try git.status(options, pathspec: localURL.path)
    }
    
    
    @discardableResult
    func status(_ cmd: String) throws -> String {
        try run("status" + cmd)
    }
    
}

public extension StatusOptions {
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
