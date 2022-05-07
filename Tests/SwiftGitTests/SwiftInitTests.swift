//
//  SwiftInitTests.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import XCTest
import Stem
import SwiftGit

class SwiftInitTests: XCTestCase {
    
    lazy var workFolder = try! FilePath.Folder(sanbox: .temporary)
    lazy var target = try! workFolder.folder(name: "test")

    func testTemplate() throws {
        try? target.delete()
        try Git.`init`(.quiet, .defaultTemplate, directory: target.path)
        let items = try target
            .subFilePaths(predicates: [])
            .map(\.url.lastPathComponent)
            .sorted()
        assert(items == [".git"])
    }
    
    func testBare() throws {
        try? target.delete()
        try Git.`init`(.quiet, .defaultTemplate, .bare, directory: target.path)
        let items = try target
            .subFilePaths(predicates: [])
            .map(\.url.lastPathComponent)
            .sorted()
        assert(items == ["HEAD","config", "description", "hooks", "info", "objects", "refs"])
    }
    
    func testBranch() throws {
        try? target.delete()
        try Git.`init`(.quiet, .defaultTemplate, .initialBranch("testBranch"), directory: target.path)
        /// TODO
    }
    
}
