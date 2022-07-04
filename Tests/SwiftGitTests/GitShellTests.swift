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

    func testfindGit() async throws {
        let item = await String(data: try GitShell.zsh("where git"), encoding: .utf8)!
        print(item)
    }

}
