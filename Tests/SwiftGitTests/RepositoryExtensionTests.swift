import Foundation
import XCTest

@testable import SwiftGit

final class RepositoryExtensionTests: XCTestCase {

    private func makeRepository() -> Repository {
        let env = GitEnvironment(
            resource: .init(executableURL: URL(fileURLWithPath: "/usr/bin/true")),
            variables: [],
            triggers: []
        )
        return Repository(git: Git(environment: env), path: "/tmp")
    }

    func testHasPrefixAndReturn_trims_prefix_and_whitespace() {
        let repo = makeRepository()
        let value = repo.hasPrefixAndReturn("Author: Alice <a@b.com>", prefix: "Author:")
        XCTAssertEqual(value, "Alice <a@b.com>")
    }

    func testHasPrefixAndReturn_returns_nil_for_mismatch() {
        let repo = makeRepository()
        let value = repo.hasPrefixAndReturn("Commit: Bob", prefix: "Author:")
        XCTAssertNil(value)
    }

    func testHasPrefixAndReturn_empty_suffix() {
        let repo = makeRepository()
        let value = repo.hasPrefixAndReturn("commit", prefix: "commit")
        XCTAssertEqual(value, "")
    }

    func testHasPrefixAndReturn_preserves_inner_spaces() {
        let repo = makeRepository()
        let value = repo.hasPrefixAndReturn("commit   123", prefix: "commit")
        XCTAssertEqual(value, "123")
    }

}
