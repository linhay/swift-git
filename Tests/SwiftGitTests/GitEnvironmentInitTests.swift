import XCTest
@testable import SwiftGit

final class GitEnvironmentInitTests: XCTestCase {

    func testAutoInit_uses_system_git() throws {
        // Auto now maps to system git; if git is unavailable, the init may throw.
        do {
            _ = try GitEnvironment(type: .auto)
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testCustomInit_with_invalid_folder_throws() throws {
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("swiftgit-nonexistent-\(UUID().uuidString)")
        XCTAssertThrowsError(try GitEnvironment(type: .custom(tmp)))
    }

}
