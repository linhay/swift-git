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
    lazy var testClone = workFolder.folder(name: "test-clone")
    lazy var arctic = workFolder.folder(name: "Arctic")
    lazy var repository = URL(string: "https://github.com/linhay/Arctic")!
        
    func testWithDirectory() throws {
        try? testClone.delete()
        try Git.shared.clone([ .depth(1)], repository: repository, directory: testClone.path)
        assert(testClone.isExist)
    }
    
    func testWithInFolder() throws {
        try? arctic.delete()
        let result = try Git.shared.clone([.depth(1)], repository: repository, workDirectoryURL: workFolder.url)
        assert(arctic.isExist)
        assert(result.localURL.path == arctic.url.path)
    }
    
    func testWithLocalExistsDirectory() throws {
        _ = try? arctic.create()
        do {
            try Git.shared.clone([.depth(1)], repository: repository, workDirectoryURL: workFolder.url)
        } catch {
            guard let error = error as? GitError else {
                throw error
            }
            assert(error.code == GitError.existsDirectory("").code)
        }
    }
    
}
