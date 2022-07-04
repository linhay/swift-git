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
    lazy var repository = URL(string: "https://github.com/linhay/Arctic")!

    func test() async throws {
        _ = try? directory.delete()
        try await Git.shared.clone([], repository: repository, directory: directory.path)
    }
    
    func testStatus() async throws {
        let repo = try await Repository(path: directory.path, environment: .shared)
        
        let untracked = directory.file(name: "test-untracked")
        let add = directory.file(name: "test-add")
        let modify = directory.file(name: "test-modify")
        
        try [untracked, add, modify].forEach { file in
            try? file.delete()
            try file.create(with: Data([UInt8](repeating: .random(in: 0...100), count: 50)))
        }
        
        try await repo.add([], paths: [add.path, modify.path])
        let status = try await repo.status()
        print(status)
    }
    
    func testLog() async throws {
        let repo = try await Repository(path: directory.path, environment: .shared)
        let result = try await repo.log(options: [.limit(3)])
        assert(!result.isEmpty)
    }
    
}
