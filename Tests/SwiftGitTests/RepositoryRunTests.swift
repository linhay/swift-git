import XCTest
@testable import SwiftGit

final class RepositoryRunTests: XCTestCase {

    func testRun_string_command_splitting() throws {
        // Ensure string-based run uses splitCommandLine properly; we won't actually run git here
        let parts = splitCommandLine("git -c 'a b' commit -m \"hi\"")
        XCTAssertEqual(parts.first, "git")
        XCTAssertTrue(parts.contains("commit"))
        XCTAssertTrue(parts.contains("hi"))
    }

}
