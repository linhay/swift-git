import XCTest
@testable import SwiftGit

final class IntegrationTests: XCTestCase {

    func makeTempDir(_ name: String = "swiftgit-int") throws -> URL {
        let fm = FileManager.default
        let base = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name + "-\(UUID().uuidString)")
        try fm.createDirectory(at: base, withIntermediateDirectories: true)
        return base
    }

    func envOrSkip() throws -> GitEnvironment {
        if let env = try? GitEnvironment(type: .system) { return env }
        if let env = try? GitEnvironment(type: .system) { return env }
        throw XCTSkip("No git instance available (system)")
    }

    func test_init_add_commit_tag_flow() throws {
        let env = try envOrSkip()
        let git = try Git(environment: env)
        let repoDir = try makeTempDir("repo")

        // init
        try git.run(["init"], context: Shell.Context(at: repoDir))

        // set user
        try git.run(["config", "user.name", "Test User"], context: Shell.Context(at: repoDir))
        try git.run(["config", "user.email", "test@example.com"], context: Shell.Context(at: repoDir))

        // write file
        let file = repoDir.appendingPathComponent("README.md")
        try "hello\n".write(to: file, atomically: true, encoding: .utf8)

        // add and commit
        try git.run(["add", "README.md"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "initial commit"], context: Shell.Context(at: repoDir))

        // tag
        try git.run(["tag", "v1.0"], context: Shell.Context(at: repoDir))

        let tags = try git.run(["tag", "-l"], context: Shell.Context(at: repoDir))
        XCTAssertTrue(tags.split(separator: "\n").contains { $0.trimmingCharacters(in: .whitespacesAndNewlines) == "v1.0" })
    }

    func test_branch_and_checkout() throws {
        let env = try envOrSkip()
        let git = try Git(environment: env)
        let repoDir = try makeTempDir("repo-branch")
        try git.run(["init"], context: Shell.Context(at: repoDir))
        try git.run(["config", "user.name", "Test"], context: Shell.Context(at: repoDir))
        try git.run(["config", "user.email", "t@e"], context: Shell.Context(at: repoDir))
        try "x".write(to: repoDir.appendingPathComponent("a.txt"), atomically: true, encoding: .utf8)
        try git.run(["add", "a.txt"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "c"], context: Shell.Context(at: repoDir))

        try git.run(["checkout", "-b", "feature/x"], context: Shell.Context(at: repoDir))
        let branch = try git.run(["rev-parse", "--abbrev-ref", "HEAD"], context: Shell.Context(at: repoDir))
        XCTAssertEqual(branch.trimmingCharacters(in: .whitespacesAndNewlines), "feature/x")
    }

    func test_status_empty_repo() throws {
        let env = try envOrSkip()
        let git = try Git(environment: env)
        let repoDir = try makeTempDir("repo-empty")
        try git.run(["init"], context: Shell.Context(at: repoDir))
        let status = try git.run(["status", "--porcelain"], context: Shell.Context(at: repoDir))
        XCTAssertTrue(status.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

}
