import XCTest

@testable import SwiftGit

final class ReferenceTests: XCTestCase {

    func testReference_init_special_heads() {
        let head: Reference = "HEAD"
        if case .head = head {} else { XCTFail("Expected .head") }
        XCTAssertEqual(head.name, "HEAD")

        let fetch: Reference = "FETCH_HEAD"
        if case .fetchHead = fetch {} else { XCTFail("Expected .fetchHead") }
        XCTAssertEqual(fetch.name, "FETCH_HEAD")

        let orig: Reference = "ORIG_HEAD"
        if case .origHead = orig {} else { XCTFail("Expected .origHead") }
        XCTAssertEqual(orig.name, "ORIG_HEAD")
    }

    func testReference_init_branch_tag_other() {
        let branchRef: Reference = "refs/heads/main"
        switch branchRef {
        case .branch(let branch):
            XCTAssertEqual(branch.longName, "refs/heads/main")
            XCTAssertEqual(branch.type, .local)
        default:
            XCTFail("Expected .branch")
        }
        XCTAssertEqual(branchRef.name, "refs/heads/main")

        let remoteBranch: Reference = "refs/remotes/origin/main"
        switch remoteBranch {
        case .branch(let branch):
            XCTAssertEqual(branch.longName, "refs/remotes/origin/main")
            XCTAssertEqual(branch.type, .remote)
        default:
            XCTFail("Expected .branch")
        }

        let tagRef: Reference = "refs/tags/v1.2.3"
        switch tagRef {
        case .tag(let tag):
            XCTAssertEqual(tag.longName, "refs/tags/v1.2.3")
            XCTAssertEqual(tag.shortName, "v1.2.3")
        default:
            XCTFail("Expected .tag")
        }
        XCTAssertEqual(tagRef.name, "refs/tags/v1.2.3")

        let other: Reference = "refs/notes/commits"
        switch other {
        case .other(let value):
            XCTAssertEqual(value, "refs/notes/commits")
        default:
            XCTFail("Expected .other")
        }
        XCTAssertEqual(other.name, "refs/notes/commits")
    }

    func testBranch_state_and_init() {
        XCTAssertNotNil(Branch(longName: "refs/heads/main"))
        XCTAssertNotNil(Branch(longName: "refs/remotes/origin/main"))
        XCTAssertNil(Branch(longName: "refs/tags/v1.0"))

        XCTAssertEqual(Branch.State(rawValue: "refs/heads/main"), .local)
        XCTAssertEqual(Branch.State(rawValue: "refs/remotes/origin/main"), .remote)
        XCTAssertNil(Branch.State(rawValue: "refs/tags/v1.0"))
    }

    func testTag_short_name_and_literal() {
        let tag = Tag(longName: "refs/tags/v2.0.0", commit: "abc123")
        XCTAssertNotNil(tag)
        XCTAssertEqual(tag?.shortName, "v2.0.0")
        XCTAssertEqual(tag?.commit, "abc123")

        let literal: Tag = "v3.1.4"
        XCTAssertEqual(literal.longName, "refs/tags/v3.1.4")
        XCTAssertEqual(literal.shortName, "v3.1.4")
    }

    func testCommit_name_with_mnemonics() {
        XCTAssertEqual(Commit.head().name, "HEAD")
        let commit = Commit.head([.tilde(2), .caret(1)])
        XCTAssertEqual(commit.name, "HEAD~2^1")
    }

    func testPathspec_all_and_literal() {
        let path: Pathspec = "src"
        XCTAssertEqual(path.value, "src")
        XCTAssertEqual(Pathspec.all.value, ".")
        XCTAssertEqual([Pathspec].all.map(\.value), ["."])
    }

}
