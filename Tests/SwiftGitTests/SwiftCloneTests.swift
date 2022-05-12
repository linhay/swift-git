//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import XCTest
import Stem
import SwiftGit

class SwiftCloneTests: XCTestCase {
    
    lazy var workFolder = try! FilePath.Folder(path: "~/Downloads/")
    lazy var directory = workFolder.folder(name: "test-clone")
    lazy var repository = URL(string: "https://github.com/linhay/Arctic")!

    func testWithDirectory() throws {
        try? directory.delete()
        _ = try Git.clone([.defaultTemplate, .depth(1)], repository: repository, directory: directory.path)
        assert(directory.isExist)
    }
    
    func testWithInFolder() throws {
        lazy var directory = workFolder.folder(name: "Arctic")
        try? directory.delete()
        let result = try Git.clone([.defaultTemplate, .depth(1)], repository: repository, workDirectoryURL: workFolder.url)
        assert(directory.isExist)
        assert(result.localURL == directory.url)
    }
    
}
