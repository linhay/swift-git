//
//  File.swift
//  
//
//  Created by linhey on 2022/6/27.
//

import XCTest
import Stem
import SwiftGit

class GitShellTests: XCTestCase {

    func testfindGit() throws {
        print(String(data: try GitShell.data(["-c" , "where git"]), encoding: .utf8)!)
    }

}
