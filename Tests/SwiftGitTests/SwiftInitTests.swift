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
    
    lazy var workFolder = try! FilePath.Folder(path: "~/Downloads/")
    lazy var target = workFolder.folder(name: "test-init")
    
    func testTemplate() async throws {
        try? target.delete()
        try await Git.shared.`init`([.quiet], directory: target.path)
        let items = try target
            .subFilePaths(predicates: [])
            .map(\.url.lastPathComponent)
            .sorted()
        assert(items == [".git"])
    }
    
    func testBare() async throws {
        try? target.delete()
        try await Git.shared.`init`([.quiet, .bare], directory: target.path)
        let items = try target
            .subFilePaths(predicates: [])
            .map(\.url.lastPathComponent)
        assert(Set(items).isSubset(of: ["HEAD","config", "objects", "refs"]))
    }
    
    func testBranch() async throws {
        try? target.delete()
        try await Git.shared.`init`([.quiet, .initialBranch("testBranch")], directory: target.path)
        /// TODO
    }
    
}
