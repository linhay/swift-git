//
//  File.swift
//  
//
//  Created by linhey on 2022/5/3.
//

import Foundation


public extension CommitOptions {

    /**
     以易于解析的格式给出脚本的输出。 这类似于简短的输出，但在不同的Git版本中，无论用户配置如何，都会保持稳定。
     版本参数用于指定格式版本。 这是可选的，默认为原始版本的 "v1 "格式。
     Give the output in an easy-to-parse format for scripts. This is similar to the short output, but will remain stable across Git versions and regardless of user
     configuration. See below for details.
     The version parameter is used to specify the format version. This is optional and defaults to the original version v1 format.
     */
    static func porcelain(_ version: PorcelainMode) -> CommitOptions {
        .init(stringLiteral: "--porcelain=\(version.rawValue)")
    }
    
    enum Cleanup: String {
        /// Strip leading and trailing empty lines, trailing whitespace, commentary and collapse consecutive empty lines.
        case strip
        /// Same as strip except #commentary is not removed.
        case whitespace
        /// Do not change the message at all.
        case verbatim
        /** Same as whitespace except that everything from (and including) the line found below is truncated, if the message is to be edited. "#" can be customized with core.commentChar.
         # ------------------------ >8 ------------------------
         */
        case scissors
        /// Same as strip if the message is to be edited. Otherwise whitespace.
        case `default`
    }
    
    static func cleanup(_ mode: Cleanup) -> CommitOptions {
        .init("--cleanup=\(mode.rawValue)")
    }
    
    static func untrackedFiles(_ mode: UntrackedFilesMode) -> StatusOptions {
        .init(stringLiteral: "--untracked-files=\(mode.rawValue)")
    }

}
