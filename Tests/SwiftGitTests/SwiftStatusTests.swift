//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import XCTest
import STFilePath
@testable
import SwiftGit

class SwiftStatusTests: XCTestCase {
    
    lazy var workFolder = STFolder("~/Downloads/")
    lazy var directory = workFolder.folder("test-clone")
    lazy var repository = URL(string: "https://github.com/linhay/Arctic")!
    
    func test() async throws {
        _ = try? directory.delete()
        try await Git.shared.clone([], repository: repository, directory: directory.path)
    }
    
    func testStatus() async throws {
        let repo = try Repository(path: directory.path, environment: .shared)
        
        let untracked = directory.file("test-untracked")
        let add = directory.file( "test-add")
        let modify = directory.file("test-modify")
        
        try [untracked, add, modify].forEach { file in
            try? file.delete()
            try file.create(with: Data([UInt8](repeating: .random(in: 0...100), count: 50)))
        }
        
        try await repo.add([], paths: [add.path, modify.path])
        let status = try await repo.status()
        print(status)
    }
    
    func testLog() async throws {
        let repo = try Repository(path: directory.path, environment: .shared)
        let result = try await repo.log(options: [.limit(3)])
        assert(!result.isEmpty)
    }
    
    func testShowCommitResult1() throws {
        let string =
"""
commit 9a1d113d09df3d97f3a87cf26c4f9decc3da620e
Author:     username <username@email.com>
AuthorDate: Wed Jun 8 10:57:59 2022 +0800
Commit:     username <username@email.com>
CommitDate: Wed Jun 8 10:57:59 2022 +0800

    新增 dui_warning

diff --git a/SVGs/dui_warning.svg b/SVGs/dui_warning.svg
new file mode 100644
index 0000000..ed894f0
--- /dev/null
+++ b/SVGs/dui_warning.svg
@@ -0,0 +1,3 @@
+<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
+<path d="M8 16C12.4183 16 16 12.4183 16 8C16 3.58172 12.4183 0 8 0C3.58172 0 0 3.58172 0 8C0 12.4183 3.58172 16 8 16ZM7 4C7 3.44772 7.44772 3 8 3C8.55228 3 9 3.44772 9 4V8C9 8.55228 8.55228 9 8 9C7.44772 9 7 8.55228 7 8V4ZM7 12C7 11.4477 7.44772 11 8 11C8.55228 11 9 11.4477 9 12C9 12.5523 8.55228 13 8 13C7.44772 13 7 12.5523 7 12Z" fill="#333333"/>
+</svg>
"""
        let commit = Repository(path: "", environment: try .shared).showCommitResult(from: string)
        
        assert(commit.ID == "9a1d113d09df3d97f3a87cf26c4f9decc3da620e")
        assert(commit.items == [.init(diff: .init(a: "SVGs/dui_warning.svg", b: "SVGs/dui_warning.svg"),
                                      actions: [.new(mode: 0o100644), .index(.init(from: "0000000", to: "ed894f0"))])])
        assert(commit.author == .init(user: .init(name: "username", email: "username@email.com"), date: Date.init(timeIntervalSince1970: 1654657079)))
        assert(commit.commit == .init(user: .init(name: "username", email: "username@email.com"), date: Date.init(timeIntervalSince1970: 1654657079)))
        assert(commit.message == "新增 dui_warning")
    }
    
    
    func testShowCommitResult2() throws {
        let string =
"""
commit 463bfbcbb4c5e61fbdefbec658b0a317a780461f (HEAD -> master, origin/master, origin/HEAD)
Author:     username <username@email.com>
AuthorDate: Wed Jun 8 10:57:59 2022 +0800
Commit:     username <username@email.com>
CommitDate: Wed Jun 8 10:57:59 2022 +0800

    9.21.0

diff --git a/Images/bg_sharepic.png b/Images/bg_sharepic.png
new file mode 100644
index 00000000..7c55edee
Binary files /dev/null and b/Images/bg_sharepic.png differ
"""
        let commit = Repository(path: "", environment: try .shared).showCommitResult(from: string)
        
        assert(commit.ID == "463bfbcbb4c5e61fbdefbec658b0a317a780461f")
        assert(commit.items == [.init(diff: .init(a: "Images/bg_sharepic.png", b: "Images/bg_sharepic.png"),
                                      actions: [.new(mode: 0o100644), .index(.init(from: "00000000", to: "7c55edee"))])])
        assert(commit.author == .init(user: .init(name: "username", email: "username@email.com"), date: Date.init(timeIntervalSince1970: 1654657079)))
        assert(commit.commit == .init(user: .init(name: "username", email: "username@email.com"), date: Date.init(timeIntervalSince1970: 1654657079)))
        assert(commit.message == "9.21.0")
    }
    
    
    func testls() async throws {
        _ = try? directory.delete()
        try await Git.shared.clone([], repository: repository, directory: directory.path)
        let repo = try Repository(path: directory.path, environment: .shared)
        let str = try await repo.lsRemote([.getURL], refs: [])
        assert(str == repository.absoluteString)
    }
    
}
