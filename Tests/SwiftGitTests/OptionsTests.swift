import XCTest

@testable import SwiftGit

final class OptionsTests: XCTestCase {

    func testCommitOptions_raw_values() {
        XCTAssertEqual(CommitOptions.all.rawValue, "--all")
        XCTAssertEqual(CommitOptions.allowEmpty.rawValue, "--allow-empty")
        XCTAssertEqual(CommitOptions.noEdit.rawValue, "--no-edit")
        XCTAssertEqual(CommitOptions.author("Alice <a@b.com>").rawValue, "--author=Alice <a@b.com>")
        XCTAssertEqual(CommitOptions.message("hello").rawValue, "--message=hello")
        XCTAssertEqual(CommitOptions.gpgSign(["ABC", "DEF"]).rawValue, "--gpg-sign=ABC,DEF")
        XCTAssertEqual(CommitOptions.untrackedFiles(["all"]).rawValue, "--untracked-files=all")
        XCTAssertEqual(CommitOptions.pathspecFromFile("/tmp/list").rawValue, "--pathspec-from-file=/tmp/list")
    }

    func testStatusOptions_raw_values() {
        XCTAssertEqual(StatusOptions.branch.rawValue, "--branch")
        XCTAssertEqual(StatusOptions.noRenames.rawValue, "--no-renames")
        XCTAssertEqual(StatusOptions.column(["always"]).rawValue, "--column=always")
        XCTAssertEqual(StatusOptions.findRenames(["50%"]).rawValue, "--find-renames=50%")
        XCTAssertEqual(StatusOptions.ignored(["matching"]).rawValue, "--ignored=matching")
        XCTAssertEqual(StatusOptions.ignoreSubmodules(["all"]).rawValue, "--ignore-submodules=all")
        XCTAssertEqual(StatusOptions.porcelain(["v2"]).rawValue, "--porcelain=v2")
        XCTAssertEqual(StatusOptions.untrackedFiles(["no"]).rawValue, "--untracked-files=no")
    }

    func testOptions_literal_initialization() {
        let commit: CommitOptions = "--dry-run"
        XCTAssertEqual(commit.rawValue, "--dry-run")

        let status: StatusOptions = "--short"
        XCTAssertEqual(status.rawValue, "--short")
    }

    func testCommitOptions_typed_helpers() {
        XCTAssertEqual(CommitOptions.porcelain(.v2).rawValue, "--porcelain=v2")
        XCTAssertEqual(CommitOptions.cleanup(.strip).rawValue, "--cleanup=strip")
        XCTAssertEqual(CommitOptions.cleanup(.default).rawValue, "--cleanup=default")
        XCTAssertEqual(CommitOptions.untrackedFiles(.no).rawValue, "--untracked-files=no")
    }

    func testStatusOptions_typed_helpers() {
        XCTAssertEqual(StatusOptions.aheadBehind(true).rawValue, "--ahead-behind")
        XCTAssertEqual(StatusOptions.aheadBehind(false).rawValue, "--no-ahead-behind")
        XCTAssertEqual(StatusOptions.renames(true).rawValue, "--renames")
        XCTAssertEqual(StatusOptions.renames(false).rawValue, "--no-renames")
        XCTAssertEqual(StatusOptions.findRenames(90).rawValue, "--find-renames=-M90%")
        XCTAssertEqual(StatusOptions.column(.no).rawValue, "--column=no")
        XCTAssertEqual(StatusOptions.ignored(.matching).rawValue, "--ignored=matching")
        XCTAssertEqual(StatusOptions.ignoreSubmodules(.dirty).rawValue, "--ignore-submodules=dirty")
        XCTAssertEqual(StatusOptions.porcelain(.v2).rawValue, "--porcelain=v2")
        XCTAssertEqual(StatusOptions.untrackedFiles(.normal).rawValue, "--untracked-files=normal")
    }

}
