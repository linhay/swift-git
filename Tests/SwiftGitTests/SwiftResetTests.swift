//
//  File.swift
//  
//
//  Created by linhey on 2022/5/10.
//

import XCTest
import Stem
import SwiftGit

class SwiftResetTests: XCTestCase {
    
    lazy var workFolder = try! FilePath.Folder(path: "~/Downloads/")
    lazy var directory = workFolder.folder(name: "test-clone")
    lazy var repository = "https://github.com/linhay/Arctic"
    
    func testReset() async throws {
        let repository = try Repository(path: directory.path, environment: .shared)
        try await repository.reset([], paths: [.all])
    }
    
}
