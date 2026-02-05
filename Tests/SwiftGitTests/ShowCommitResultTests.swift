import Foundation
import XCTest

@testable import SwiftGit

final class ShowCommitResultTests: XCTestCase {

    private func makeRepository() -> Repository {
        let env = GitEnvironment(
            resource: .init(executableURL: URL(fileURLWithPath: "/usr/bin/true")),
            variables: [],
            triggers: []
        )
        return Repository(git: Git(environment: env), path: "/tmp")
    }

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

        let repo = makeRepository()
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

    func testRenameAndCopyActionsParsed() {
        let input = """
commit 1111111111111111111111111111111111111111
Author: Foo Bar <foo@example.com>
AuthorDate: Mon Nov 17 18:21:25 2025 +0800
Commit: Foo Bar <foo@example.com>
CommitDate: Mon Nov 17 18:22:25 2025 +0800
diff --git a/old.txt b/new.txt
similarity index 100%
rename from old.txt
rename to new.txt
--- a/old.txt
+++ b/new.txt
diff --git a/src/copy.txt b/src/copy2.txt
copy from src/copy.txt
copy to src/copy2.txt
--- a/src/copy.txt
+++ b/src/copy2.txt
"""

        let repo = makeRepository()
        let result = repo.showCommitResult(from: input)
        XCTAssertEqual(result.items.count, 2)

        let rename = result.items[0]
        XCTAssertEqual(rename.diff.a, "old.txt")
        XCTAssertEqual(rename.diff.b, "new.txt")
        XCTAssertTrue(rename.actions.contains { action in
            if case .renameFrom("old.txt") = action { return true }
            return false
        })
        XCTAssertTrue(rename.actions.contains { action in
            if case .renameTo("new.txt") = action { return true }
            return false
        })
        XCTAssertTrue(rename.actions.contains { action in
            if case .similarity(let value) = action { return abs(value - 1.0) < 0.0001 }
            return false
        })

        let copy = result.items[1]
        XCTAssertEqual(copy.diff.a, "src/copy.txt")
        XCTAssertEqual(copy.diff.b, "src/copy2.txt")
        XCTAssertTrue(copy.actions.contains { action in
            if case .copyFrom("src/copy.txt") = action { return true }
            return false
        })
        XCTAssertTrue(copy.actions.contains { action in
            if case .copyTo("src/copy2.txt") = action { return true }
            return false
        })
    }

    func testFileModesAndIndexParsed() {
        let input = """
commit 2222222222222222222222222222222222222222
Author: Foo Bar <foo@example.com>
AuthorDate: Mon Nov 17 18:21:25 2025 +0800
Commit: Foo Bar <foo@example.com>
CommitDate: Mon Nov 17 18:22:25 2025 +0800
diff --git a/file.txt b/file.txt
new file mode 100644
deleted file mode 100755
old file mode 100644
file mode 100644
index 1111111..2222222
--- a/file.txt
+++ b/file.txt
"""

        let repo = makeRepository()
        let result = repo.showCommitResult(from: input)
        XCTAssertEqual(result.items.count, 1)
        let actions = result.items[0].actions

        XCTAssertTrue(actions.contains { action in
            if case .new(let mode) = action { return mode == 0o100644 }
            return false
        })
        XCTAssertTrue(actions.contains { action in
            if case .deleted(let mode) = action { return mode == 0o100755 }
            return false
        })
        XCTAssertTrue(actions.contains { action in
            if case .old(let mode) = action { return mode == 0o100644 }
            return false
        })
        XCTAssertTrue(actions.contains { action in
            if case .file(let mode) = action { return mode == 0o100644 }
            return false
        })
        XCTAssertTrue(actions.contains { action in
            if case .index(let index) = action {
                return index.from == "1111111" && index.to == "2222222"
            }
            return false
        })
    }

    func testIndexWithModePreservesTrailingModeText() {
        let input = """
commit 4444444444444444444444444444444444444444
Author: Foo Bar <foo@example.com>
AuthorDate: Mon Nov 17 18:21:25 2025 +0800
Commit: Foo Bar <foo@example.com>
CommitDate: Mon Nov 17 18:22:25 2025 +0800
diff --git a/file.txt b/file.txt
index 1111111..2222222 100644
--- a/file.txt
+++ b/file.txt
"""

        let repo = makeRepository()
        let result = repo.showCommitResult(from: input)
        XCTAssertEqual(result.items.count, 1)
        let actions = result.items[0].actions
        XCTAssertTrue(actions.contains { action in
            if case .index(let index) = action {
                return index.from == "1111111" && index.to == "2222222 100644"
            }
            return false
        })
    }

    func testFinalDiffRecordIsAppendedWithoutMarkers() {
        let input = """
commit 5555555555555555555555555555555555555555
Author: Foo Bar <foo@example.com>
AuthorDate: Mon Nov 17 18:21:25 2025 +0800
Commit: Foo Bar <foo@example.com>
CommitDate: Mon Nov 17 18:22:25 2025 +0800

Message
diff --git a/file.txt b/file.txt
new file mode 100644
"""

        let repo = makeRepository()
        let result = repo.showCommitResult(from: input)
        XCTAssertEqual(result.message, "Message")
        XCTAssertEqual(result.items.count, 1)
        XCTAssertEqual(result.items[0].diff.a, "file.txt")
        XCTAssertEqual(result.items[0].diff.b, "file.txt")
    }

    func testMessageStopsWhenDiffStarts() {
        let input = """
commit 3333333333333333333333333333333333333333
Author: Foo Bar <foo@example.com>
AuthorDate: Mon Nov 17 18:21:25 2025 +0800
Commit: Foo Bar <foo@example.com>
CommitDate: Mon Nov 17 18:22:25 2025 +0800

Message line
  Second line
diff --git a/file.txt b/file.txt
--- a/file.txt
+++ b/file.txt
Trailing line
"""

        let repo = makeRepository()
        let result = repo.showCommitResult(from: input)
        XCTAssertEqual(result.message, "Message line\n  Second line")
    }

}
