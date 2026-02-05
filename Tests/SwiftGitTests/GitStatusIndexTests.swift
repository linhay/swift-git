import XCTest

@testable import SwiftGit

final class GitStatusIndexTests: XCTestCase {

    func testIndexFromXY_valid_values() {
        let index1 = GitStatus.Index(fromXY: "M.")
        XCTAssertEqual(index1?.staged, .modified)
        XCTAssertEqual(index1?.unStaged, .unmodified)

        let index2 = GitStatus.Index(fromXY: ".A")
        XCTAssertEqual(index2?.staged, .unmodified)
        XCTAssertEqual(index2?.unStaged, .added)

        let index3 = GitStatus.Index(fromXY: "UU")
        XCTAssertEqual(index3?.staged, .updatedButUnmerged)
        XCTAssertEqual(index3?.unStaged, .updatedButUnmerged)
    }

    func testIndexFromXY_invalid_values_return_nil() {
        XCTAssertNil(GitStatus.Index(fromXY: "M"))
        XCTAssertNil(GitStatus.Index(fromXY: "??"))
        XCTAssertNil(GitStatus.Index(fromXY: "Z!"))
        XCTAssertNil(GitStatus.Index(fromXY: ""))
    }

    func testRenamedCopiedEntryIndex_invalid_xy_falls_back_to_unmodified() {
        let entry = GitStatus.RenamedCopiedEntry(
            XY: "",
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
        XCTAssertEqual(entry.index.staged, .unmodified)
        XCTAssertEqual(entry.index.unStaged, .unmodified)
    }

    func testUnmergedEntryIndex_invalid_xy_falls_back_to_unmodified() {
        let entry = GitStatus.UnmergedEntry(
            XY: "",
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
        XCTAssertEqual(entry.index.staged, .unmodified)
        XCTAssertEqual(entry.index.unStaged, .unmodified)
    }

}
