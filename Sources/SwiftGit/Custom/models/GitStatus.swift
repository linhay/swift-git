//
//  File.swift
//  
//
//  Created by linhey on 2022/5/10.
//

import Foundation

public struct GitStatus {
    public var branch: Branch = .init()
    public var changed: [ChangedEntry] = []
    public var renamedCopied: [RenamedCopiedEntry] = []
    public var unmerged: [UnmergedEntry] = []
    public var untracked: [UntrackedItem] = []
}

extension GitStatus {
    
    public struct Index: Equatable {
        
        public enum Style: Character, Equatable {
            case unmodified = "."
            case modified = "M"
            /// file type changed (regular file, symbolic link or submodule)
            case fileTypeChanged = "T"
            case added = "A"
            case deleted = "D"
            case renamed = "R"
            /// copied (if config option status.renames is set to "copies")
            case copied = "C"
            case updatedButUnmerged = "U"
        }
        
        public let staged: Style
        public let unStaged: Style
        
    }
    
    public struct ChangedEntry {
        
        public var index: Index { .init(staged: .init(rawValue: XY.first!)!, unStaged: .init(rawValue: XY.last!)!) }
        
        public let XY: String
        public let sub: String
        public let mH: String
        public let mI: String
        public let mW: String
        public let hH: String
        public let hI: String
        public let X: String
        public let path: String
    }
    
    public struct UntrackedItem {
        public let path: String
    }
    
    public struct RenamedCopiedEntry {
        
        public var index: Index { .init(staged: .init(rawValue: XY.first!)!, unStaged: .init(rawValue: XY.last!)!) }
        
        public let XY: String
        public let sub: String
        public let mH: String
        public let mI: String
        public let mW: String
        public let hH: String
        public let hI: String
        public let X: String
        public let path: String
        public let score: String
        public let sep: String
        public let origPath: String
    }
    
    public struct UnmergedEntry {
        
        public var index: Index { .init(staged: .init(rawValue: XY.first!)!, unStaged: .init(rawValue: XY.last!)!) }
        
        public let XY: String
        public let sub: String
        public let m1: String
        public let m2: String
        public let m3: String
        public let mW: String
        public let h1: String
        public let h2: String
        public let h3: String
        public let path: String
    }
    
    public struct Branch {
        
        public struct Ab {
            public let ahead: String
            public let behind: String
            
        }
        
        var ab: Ab?
        var oid: String = ""
        var head: String = ""
        var upstream: String = ""
        
    }
    
}
