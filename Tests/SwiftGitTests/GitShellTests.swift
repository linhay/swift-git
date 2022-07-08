//
//  File.swift
//  
//
//  Created by linhey on 2022/6/27.
//

import XCTest
import Stem
import SwiftGit
import Combine

class GitShellTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func testfindGit() async throws {
        let command = "where git"
        let item = try await GitShell.zsh(string: command)!
        print(#function, ": ", item)
        GitShell.zshPublisher(string: command)
            .breakpointOnError()
            .sink { _ in
            } receiveValue: { str in
                XCTAssert(str == item)
            }.store(in: &cancellables)
    }
    
}
