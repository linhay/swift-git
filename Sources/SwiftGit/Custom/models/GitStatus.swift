//
//  File.swift
//  
//
//  Created by linhey on 2022/5/10.
//

import Foundation

public struct GitStatus: Equatable {
    
    public var branch: Branch = .init()
    public var changed: [ChangedEntry] = []
    public var renamedCopied: [RenamedCopiedEntry] = []
    public var unmerged: [UnmergedEntry] = []
    public var untracked: [UntrackedItem] = []
    
}

public extension GitStatus {
    
    /// 在特定类型中是否存在记录
    /// - Parameter types: 记录类型
    /// - Returns: 是否存在记录
    func hasEntry(in types: [EntryType] = EntryType.allCases) -> Bool {
        types.contains { type in
            switch type {
            case .changed:
                return !self.changed.isEmpty
            case .renamedCopied:
                return !self.renamedCopied.isEmpty
            case .unmerged:
                return !self.unmerged.isEmpty
            case .untracked:
                return !self.untracked.isEmpty
            }
        }
    }
    
}

public extension GitStatus {
    
    /**
     Field       Meaning
     --------------------------------------------------------
     <XY>        A 2 character field containing the staged and
     unstaged XY values described in the short format,
     with unchanged indicated by a "." rather than
     a space.
     <sub>       A 4 character field describing the submodule state.
     "N..." when the entry is not a submodule.
     "S<c><m><u>" when the entry is a submodule.
     <c> is "C" if the commit changed; otherwise ".".
     <m> is "M" if it has tracked changes; otherwise ".".
     <u> is "U" if there are untracked changes; otherwise ".".
     <mH>        The octal file mode in HEAD.
     <mI>        The octal file mode in the index.
     <mW>        The octal file mode in the worktree.
     <hH>        The object name in HEAD.
     <hI>        The object name in the index.
     <X><score>  The rename or copy score (denoting the percentage
     of similarity between the source and target of the
     move or copy). For example "R100" or "C75".
     <path>      The pathname.  In a renamed/copied entry, this
     is the target path.
     <sep>       When the `-z` option is used, the 2 pathnames are separated
     with a NUL (ASCII 0x00) byte; otherwise, a tab (ASCII 0x09)
     byte separates them.
     <origPath>  The pathname in the commit at HEAD or in the index.
     This is only present in a renamed/copied entry, and
     tells where the renamed/copied contents came from.
     --------------------------------------------------------
     */
    enum EntryType: Int, CaseIterable, Equatable {
        case changed
        case renamedCopied
        case unmerged
        case untracked
    }
    
    struct Index: Equatable {
        
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
    
    struct ChangedEntry: Equatable, Identifiable, Hashable {
        
        public var id: Int { hashValue }
        public let type: EntryType = .changed
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
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(XY)
            hasher.combine(sub)
            hasher.combine(mH)
            hasher.combine(mI)
            hasher.combine(mW)
            hasher.combine(hH)
            hasher.combine(hI)
            hasher.combine(X)
            hasher.combine(path)
        }
    }
    
    struct UntrackedItem: Equatable, Identifiable, Hashable {
        
        public var id: Int { hashValue }
        public let type: EntryType = .untracked
        public let path: String
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(path)
        }
    }
    
    struct RenamedCopiedEntry: Equatable, Identifiable, Hashable {
        
        public var id: Int { hashValue }
        public let type: EntryType = .renamedCopied
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
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(XY)
            hasher.combine(sub)
            hasher.combine(mH)
            hasher.combine(mI)
            hasher.combine(mW)
            hasher.combine(hH)
            hasher.combine(hI)
            hasher.combine(X)
            hasher.combine(path)
            hasher.combine(score)
            hasher.combine(sep)
            hasher.combine(origPath)
        }
    }
    
    struct UnmergedEntry: Equatable, Identifiable, Hashable {
        
        public var id: Int { hashValue }
        public let type: EntryType = .unmerged
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
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(XY)
            hasher.combine(sub)
            hasher.combine(m1)
            hasher.combine(m2)
            hasher.combine(m3)
            hasher.combine(mW)
            hasher.combine(h1)
            hasher.combine(h2)
            hasher.combine(h3)
            hasher.combine(path)
        }
    }
    
    struct Branch: Equatable {
        
        public struct Ab: Equatable {
            public let ahead: String
            public let behind: String
            
        }
        
        var ab: Ab?
        var oid: String = ""
        var head: String = ""
        var upstream: String = ""
        
    }
    
}
