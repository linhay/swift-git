import XCTest
@testable import SwiftGit

final class ParseTests: XCTestCase {

    func testChangedEntryIndex_valid() {
        let entry = GitStatus.ChangedEntry(
            XY: "MM",
            sub: "----",
            mH: "000",
            mI: "000",
            mW: "000",
            hH: "h",
            hI: "i",
            path: "path"
        )
        let index = entry.index
        XCTAssertEqual(index.staged, .modified)
        XCTAssertEqual(index.unStaged, .modified)
    }

    func testRenamedCopiedEntryIndex_valid() {
        let entry = GitStatus.RenamedCopiedEntry(
            XY: "A.",
            sub: "----",
            mH: "000",
            mI: "000",
            mW: "000",
            hH: "h",
            hI: "i",
            X: "R100",
            path: "to",
            score: "100",
            sep: "\t",
            origPath: "from"
        )
        let index = entry.index
        // staged 'A' (added) and unstaged '.' (unmodified)
        XCTAssertEqual(index.staged, .added)
        XCTAssertEqual(index.unStaged, .unmodified)
    }

    func testUnmergedEntryIndex_valid() {
        let entry = GitStatus.UnmergedEntry(
            XY: "UU",
            sub: "----",
            m1: "000",
            m2: "000",
            m3: "000",
            mW: "000",
            h1: "h1",
            h2: "h2",
            h3: "h3",
            path: "p"
        )
        let index = entry.index
        XCTAssertEqual(index.staged, .updatedButUnmerged)
        XCTAssertEqual(index.unStaged, .updatedButUnmerged)
    }

    func testResource_init_folder_missing_binaries_returns_nil() {
        // create a temporary folder without git binaries
        let fm = FileManager.default
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("swiftgit-test-\(UUID().uuidString)")
        try? fm.createDirectory(at: tmp, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tmp) }

        let resource = GitEnvironment.Resource(folder: tmp)
        XCTAssertNil(resource)
    }

    func testVariable_configNoSysyem_key_and_value() {
        let v = GitEnvironment.Variable.configNoSysyem(true)
        XCTAssertEqual(v.key, "GIT_CONFIG_NOSYSTEM")
        XCTAssertEqual(v.value, "true")
    }

    func testVariable_configNoSystem_key_and_value() {
        let v = GitEnvironment.Variable.configNoSystem(false)
        XCTAssertEqual(v.key, "GIT_CONFIG_NOSYSTEM")
        XCTAssertEqual(v.value, "false")
    }

    func testChangedEntryIndex_malformed_XY_returns_unmodified() {
        let entry = GitStatus.ChangedEntry(
            XY: "",
            sub: "----",
            mH: "000",
            mI: "000",
            mW: "000",
            hH: "h",
            hI: "i",
            path: "path"
        )
        let index = entry.index
        XCTAssertEqual(index.staged, .unmodified)
        XCTAssertEqual(index.unStaged, .unmodified)
    }

    func testHasEntry_various_types() {
        var status = GitStatus()
        XCTAssertFalse(status.hasEntry())
        status.changed.append(.init(XY: "MM", sub: "", mH: "", mI: "", mW: "", hH: "", hI: "", path: "p"))
        XCTAssertTrue(status.hasEntry())
        XCTAssertTrue(status.hasEntry(in: [.changed]))
        XCTAssertFalse(status.hasEntry(in: [.untracked]))
    }

    func testSplitCommandLine_basic_and_quoted() {
        let s1 = "git commit -m \"hello world\""
        let parts1 = splitCommandLine(s1)
        XCTAssertEqual(parts1, ["git", "commit", "-m", "hello world"]) 

        let s2 = "echo 'single quoted arg' plain"
        let parts2 = splitCommandLine(s2)
        XCTAssertEqual(parts2, ["echo", "single quoted arg", "plain"]) 

        let s3 = "cmd escaped\\ space"
        let parts3 = splitCommandLine(s3)
        XCTAssertEqual(parts3, ["cmd", "escaped space"]) 
    }

}
