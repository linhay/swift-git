import XCTest

@testable import SwiftGit

final class StatusParsingTests: XCTestCase {

    func makeTempDir(_ name: String = "swiftgit-status") throws -> URL {
        let fm = FileManager.default
        let base = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name + "-\(UUID().uuidString)")
        try fm.createDirectory(at: base, withIntermediateDirectories: true)
        return base
    }

    func envOrSkip() throws -> GitEnvironment {
        if let env = try? GitEnvironment(type: .embed) { return env }
        if let env = try? GitEnvironment(type: .system) { return env }
        throw XCTSkip("No git instance available (embed or system)")
    }

    func configureUser(_ git: Git, at repoDir: URL) throws {
        try git.run(["config", "user.name", "Test User"], context: Shell.Context(at: repoDir))
        try git.run(["config", "user.email", "test@example.com"], context: Shell.Context(at: repoDir))
    }

    func test_status_parses_branch_head_and_oid() throws {
        let env = try envOrSkip()
        let git = Git(environment: env)
        let repoDir = try makeTempDir("repo-branch-info")

        try git.run(["init"], context: Shell.Context(at: repoDir))
        try configureUser(git, at: repoDir)

        let file = repoDir.appendingPathComponent("README.md")
        try "hello\n".write(to: file, atomically: true, encoding: .utf8)
        try git.run(["add", "README.md"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "initial commit"], context: Shell.Context(at: repoDir))

        let status = try git.status(repoDir.path)
        let head = try git.run(["rev-parse", "--abbrev-ref", "HEAD"], context: Shell.Context(at: repoDir))
        let oid = try git.run(["rev-parse", "HEAD"], context: Shell.Context(at: repoDir))

        XCTAssertEqual(status.branch.head, head.trimmingCharacters(in: .whitespacesAndNewlines))
        XCTAssertEqual(status.branch.oid, oid.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    func test_status_parses_untracked_files() throws {
        let env = try envOrSkip()
        let git = Git(environment: env)
        let repoDir = try makeTempDir("repo-untracked")

        try git.run(["init"], context: Shell.Context(at: repoDir))
        let file = repoDir.appendingPathComponent("untracked.txt")
        try "hello\n".write(to: file, atomically: true, encoding: .utf8)

        let status = try git.status(repoDir.path)
        XCTAssertTrue(status.untracked.contains { $0.path == "untracked.txt" })
    }

    func test_status_parses_changed_files() throws {
        let env = try envOrSkip()
        let git = Git(environment: env)
        let repoDir = try makeTempDir("repo-changed")

        try git.run(["init"], context: Shell.Context(at: repoDir))
        try configureUser(git, at: repoDir)

        let file = repoDir.appendingPathComponent("tracked.txt")
        try "hello\n".write(to: file, atomically: true, encoding: .utf8)
        try git.run(["add", "tracked.txt"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "initial commit"], context: Shell.Context(at: repoDir))

        try "hello world\n".write(to: file, atomically: true, encoding: .utf8)

        let status = try git.status(repoDir.path)
        XCTAssertTrue(status.changed.contains { $0.path == "tracked.txt" })
    }

    func test_status_parses_branch_ahead_behind_counts() throws {
        let env = try envOrSkip()
        let git = Git(environment: env)
        let repoDir = try makeTempDir("repo-ahead-behind")
        let remoteDir = try makeTempDir("repo-ahead-behind-remote")

        try git.run(["init", "--bare"], context: Shell.Context(at: remoteDir))
        try git.run(["init", "-b", "main"], context: Shell.Context(at: repoDir))
        try configureUser(git, at: repoDir)
        try git.run(["remote", "add", "origin", remoteDir.path], context: Shell.Context(at: repoDir))

        let file = repoDir.appendingPathComponent("README.md")
        try "hello\n".write(to: file, atomically: true, encoding: .utf8)
        try git.run(["add", "README.md"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "initial"], context: Shell.Context(at: repoDir))
        try git.run(["push", "-u", "origin", "main"], context: Shell.Context(at: repoDir))

        // ahead by 1
        try "hello world\n".write(to: file, atomically: true, encoding: .utf8)
        try git.run(["add", "README.md"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "local change"], context: Shell.Context(at: repoDir))

        let statusAhead = try git.status(repoDir.path)
        XCTAssertEqual(statusAhead.branch.ab?.ahead, "+1")
        XCTAssertEqual(statusAhead.branch.ab?.behind, "-0")

        // behind by 1
        let otherDir = try makeTempDir("repo-ahead-behind-other")
        try git.run(["clone", "-b", "main", remoteDir.path, otherDir.path])
        try configureUser(git, at: otherDir)

        let otherFile = otherDir.appendingPathComponent("REMOTE.md")
        try "remote\n".write(to: otherFile, atomically: true, encoding: .utf8)
        try git.run(["add", "REMOTE.md"], context: Shell.Context(at: otherDir))
        try git.run(["commit", "-m", "remote change"], context: Shell.Context(at: otherDir))
        try git.run(["push", "origin", "main"], context: Shell.Context(at: otherDir))

        try git.run(["fetch", "origin"], context: Shell.Context(at: repoDir))
        let statusBehind = try git.status(repoDir.path)
        XCTAssertEqual(statusBehind.branch.ab?.ahead, "+1")
        XCTAssertEqual(statusBehind.branch.ab?.behind, "-1")
    }

    func test_status_parses_unmerged_entries() throws {
        let env = try envOrSkip()
        let git = Git(environment: env)
        let repoDir = try makeTempDir("repo-conflict")

        try git.run(["init", "-b", "main"], context: Shell.Context(at: repoDir))
        try configureUser(git, at: repoDir)

        let file = repoDir.appendingPathComponent("conflict.txt")
        try "base\n".write(to: file, atomically: true, encoding: .utf8)
        try git.run(["add", "conflict.txt"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "base"], context: Shell.Context(at: repoDir))

        try git.run(["checkout", "-b", "feature"], context: Shell.Context(at: repoDir))
        try "feature\n".write(to: file, atomically: true, encoding: .utf8)
        try git.run(["add", "conflict.txt"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "feature change"], context: Shell.Context(at: repoDir))

        try git.run(["checkout", "main"], context: Shell.Context(at: repoDir))
        try "main\n".write(to: file, atomically: true, encoding: .utf8)
        try git.run(["add", "conflict.txt"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "main change"], context: Shell.Context(at: repoDir))

        _ = try? git.run(["merge", "feature"], context: Shell.Context(at: repoDir))

        let status = try git.status(repoDir.path)
        XCTAssertTrue(status.unmerged.contains { $0.path == "conflict.txt" })
        XCTAssertTrue(status.unmerged.contains { $0.XY == "UU" })
    }

}
