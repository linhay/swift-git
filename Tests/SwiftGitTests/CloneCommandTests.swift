import XCTest
@testable import SwiftGit

final class CloneCommandTests: XCTestCase {

    func testRepositoryUrl_with_credentials_embeds_userinfo() throws {
        let git = try Git(environment: GitEnvironment(type: .auto))
        let url = URL(string: "https://example.com/repo.git")!
        let repo = try git.repository(url: url, credentials: .plaintext(username: "u", password: "p"))
        XCTAssertTrue(repo.contains("u:"))
        XCTAssertTrue(repo.contains("@"))
    }

    func testClone_workDirectory_with_empty_lastPath_throws() throws {
        let git = try Git(environment: GitEnvironment(type: .auto))
        let repo = URL(string: "file:///")!
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        XCTAssertThrowsError(try git.clone([], repository: repo, workDirectoryURL: tmp))
    }

}
