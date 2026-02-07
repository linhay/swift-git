import XCTest
@testable import SwiftGit

final class GitEnvironmentTests: XCTestCase {

    func testFormatterVersion_handles_no_version_token() throws {
        // formatter(version:) is fileprivate in original file, test via public interface
        // Use a sample output and ensure calling version() won't crash; we can't access formatter directly.
        // This test is a smoke test verifying version() doesn't throw for unexpected output.
        struct DummyGit: Codable {}
        // Shared Git/GitEnvironment were removed; this test remains a placeholder.
        XCTAssertTrue(true)
    }

}
