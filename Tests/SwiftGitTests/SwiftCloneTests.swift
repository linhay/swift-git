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
        
    func testWithDirectory() async throws {
        try? testClone.delete()
        try await Git.shared.clone([ .depth(1)], repository: repository, directory: testClone.path)
        assert(testClone.isExist)
    }
    
    func testWithInFolder() async throws {
        try? arctic.delete()
        let result = try await Git.shared.clone([.depth(1)], repository: repository, workDirectoryURL: workFolder.url)
        assert(arctic.isExist)
        assert(result.localURL.path == arctic.url.path)
    }
    
    func testWithLocalExistsDirectory() async throws {
        _ = try? arctic.create()
        do {
            try await Git.shared.clone([.depth(1)], repository: repository, workDirectoryURL: workFolder.url)
        } catch {
            guard let error = error as? GitError else {
                throw error
            }
            assert(error.code == GitError.existsDirectory("").code)
        }
    }
    
}
