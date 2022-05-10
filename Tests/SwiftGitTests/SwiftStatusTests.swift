//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import XCTest
import Stem
import SwiftGit

class SwiftStatusTests: XCTestCase {
    
    lazy var workFolder = try! FilePath.Folder(path: "~/Downloads/")
    lazy var directory = workFolder.folder(name: "test-clone")
    lazy var repository = "https://github.com/linhay/SwiftGit"

    func test() throws {
        _ = try Git.clone(.defaultTemplate, repository: repository, directory: directory.path)
    }
    
    func testStatus() throws {
        let file = directory.file(name: "test-111")
        try? file.delete()
        try? file.create()
        print(try Git.status(directory.path))
    }
    
}
