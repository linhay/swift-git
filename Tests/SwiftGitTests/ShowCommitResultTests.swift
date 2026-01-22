import XCTest
@testable import SwiftGit

final class ShowCommitResultTests: XCTestCase {

    func testSimilarityAndDissimilarityParsed() {
        let input = """
commit 0123456789abcdef0123456789abcdef01234567
Author: Foo Bar <foo@example.com>
AuthorDate: Mon Nov 17 18:21:25 2025 +0800
Commit: Foo Bar <foo@example.com>
CommitDate: Mon Nov 17 18:22:25 2025 +0800
diff --git a/file.txt b/file.txt
similarity index 75%
dissimilarity index 25%
--- a/file.txt
+++ b/file.txt
"""

        let repo = Repository(git: try! Git(environment: try! GitEnvironment(type: .auto)), url: URL(fileURLWithPath: "."))
        let result = repo.showCommitResult(from: input)
        XCTAssertFalse(result.items.isEmpty)
        let actions = result.items[0].actions
        // Expect both similarity and dissimilarity actions
        XCTAssertTrue(actions.contains { action in
            if case .similarity(let v) = action { return abs(v - 0.75) < 0.0001 }
            return false
        })
        XCTAssertTrue(actions.contains { action in
            if case .dissimilarity(let v) = action { return abs(v - 0.25) < 0.0001 }
            return false
        })
    }

}
