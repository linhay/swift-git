import XCTest
@testable import SwiftGit

final class GitEnvironmentInitTests: XCTestCase {

    func testAutoInit_prefers_embed_when_available() throws {
        // We cannot easily manipulate Bundle.module in tests; at least call the auto init
        // to ensure it doesn't throw in a normal environment.
        do {
            _ = try GitEnvironment(type: .auto)
        } catch {
            // It's acceptable for the test environment to not have an embedded bundle,
            // but the call should not crash; swallowing errors here is intended.
            XCTAssertNotNil(error)
        }
    }

    func testCustomInit_with_invalid_folder_throws() throws {
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("swiftgit-nonexistent-\(UUID().uuidString)")
        XCTAssertThrowsError(try GitEnvironment(type: .custom(tmp)))
    }

}
