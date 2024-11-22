//
//  File.swift
//  
//
//  Created by linhey on 2022/5/10.
//

import XCTest
import STFilePath
import SwiftGit
import Stem

class SwiftResetTests: XCTestCase {
    
    lazy var workFolder = STFolder("~/Downloads/")
    lazy var directory = workFolder.folder("test-clone")
    lazy var repository = "https://github.com/linhay/Arctic"
    
    func testReset() async throws {
        let repository = try Repository(path: directory.path, environment: .shared)
        try await repository.reset([], paths: [.all])
    }
    
}
