//
//  File.swift
//  
//
//  Created by linhey on 2022/5/10.
//

import Foundation

public struct StatusChangedEntry {
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

public struct StatusUntrackedItem {
    public let path: String
}

public struct StatusRenamedCopiedEntry {
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

public struct StatusUnmergedEntry {
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

public struct StatusBranch {
    
    public struct Ab {
        public let ahead: String
        public let behind: String
        
    }
    
    var ab: Ab?
    var oid: String = ""
    var head: String = ""
    var upstream: String = ""
    
}

public struct Status {
    public var branch: StatusBranch = .init()
    public var changed: [StatusChangedEntry] = []
    public var renamedCopied: [StatusRenamedCopiedEntry] = []
    public var unmerged: [StatusUnmergedEntry] = []
    public var untracked: [StatusUntrackedItem] = []
}
