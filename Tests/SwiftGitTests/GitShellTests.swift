//
//  File.swift
//  
//
//  Created by linhey on 2022/6/27.
//

import XCTest
import Stem
import Combine

class StemShellTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func testfindGit() async throws {
        let command = "where git"
        let item = try await StemShell.zsh(string: command)!
        print(#function, ": ", item)
        StemShell.zshPublisher(string: command)
            .breakpointOnError()
            .sink { _ in
            } receiveValue: { str in
                XCTAssert(str == item)
            }.store(in: &cancellables)
    }
    
    func testfindGitSync() throws {
        let command = "where git"
        let item = try StemShell.zsh(string: command)!
        print(#function, ": ", item)
    }
    
}
