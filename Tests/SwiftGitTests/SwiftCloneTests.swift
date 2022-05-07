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
    lazy var repository = "https://github.com/linhay/SwiftGit"

    func test() throws {
        print(directory.path)
        try? directory.delete()
        _ = try Git.clone(.defaultTemplate, repository: repository, directory: directory.path)
        assert(directory.isExist)
    }
    
}
