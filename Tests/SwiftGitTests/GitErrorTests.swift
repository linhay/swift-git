import Foundation
import XCTest

@testable import SwiftGit

final class GitErrorTests: XCTestCase {

    func testErrorDescriptions() {
        XCTAssertEqual(
            GitError.unableLoadEmbeddGitInstance.errorDescription,
            "Unable to load the embedd git instance"
        )
        XCTAssertEqual(
            GitError.unableLoadCustomGitInstance.errorDescription,
            "Unable to load the custom git instance"
        )
        XCTAssertEqual(
            GitError.noGitInstanceFoundOnSystem.errorDescription,
            "no git instance found on the system"
        )
        XCTAssertEqual(
            GitError.existsDirectory("/tmp/repo").errorDescription,
            "destination path '/tmp/repo' already exists and is not an empty directory."
        )
        XCTAssertEqual(
            GitError.processFatal("fatal: boom").errorDescription,
            "fatal: boom"
        )
        XCTAssertEqual(
            GitError.parser(nil).errorDescription,
            "parser error: "
        )

        let underlying = NSError(
            domain: "SwiftGitTests",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "boom"]
        )
        XCTAssertEqual(
            GitError.other(underlying).errorDescription,
            "other: boom"
        )
    }

    func testErrorCodes() {
        XCTAssertEqual(GitError.noGitInstanceFoundOnSystem.code, 101)
        XCTAssertEqual(GitError.unableLoadEmbeddGitInstance.code, 102)
        XCTAssertEqual(GitError.unableLoadCustomGitInstance.code, 103)
        XCTAssertEqual(GitError.existsDirectory("x").code, 401)
        XCTAssertEqual(GitError.processFatal("x").code, 402)
        XCTAssertEqual(GitError.other(NSError(domain: "x", code: 1)).code, 403)
        XCTAssertEqual(GitError.parser(nil).code, 404)
    }

}
