import XCTest
@testable import SwiftGit

final class IntegrationMoreTests: XCTestCase {

    func makeTempDir(_ name: String = "swiftgit-int") throws -> URL {
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

    func test_revparse_and_cat_file() throws {
        let env = try envOrSkip()
        let git = try Git(environment: env)
        let repoDir = try makeTempDir("repo-rev")
        try git.run(["init"], context: Shell.Context(at: repoDir))
        try git.run(["config", "user.name", "X"], context: Shell.Context(at: repoDir))
        try git.run(["config", "user.email", "x@e"], context: Shell.Context(at: repoDir))
        let file = repoDir.appendingPathComponent("f.txt")
        try "hello-rev\n".write(to: file, atomically: true, encoding: .utf8)
        try git.run(["add", "f.txt"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "commit for cat-file"], context: Shell.Context(at: repoDir))

        let hash = try git.run(["rev-parse", "HEAD"], context: Shell.Context(at: repoDir))
        let cat = try git.run(["cat-file", "-p", hash.trimmingCharacters(in: .whitespacesAndNewlines)], context: Shell.Context(at: repoDir))
        XCTAssertTrue(cat.contains("commit for cat-file"))
    }

    func test_stash_push_and_pop() throws {
        let env = try envOrSkip()
        let git = try Git(environment: env)
        let repoDir = try makeTempDir("repo-stash")
        try git.run(["init"], context: Shell.Context(at: repoDir))
        try git.run(["config", "user.name", "S"], context: Shell.Context(at: repoDir))
        try git.run(["config", "user.email", "s@e"], context: Shell.Context(at: repoDir))
        let file = repoDir.appendingPathComponent("s.txt")
        try "base\n".write(to: file, atomically: true, encoding: .utf8)
        try git.run(["add", "s.txt"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "base"], context: Shell.Context(at: repoDir))

        // modify and stash
        try "modified\n".write(to: file, atomically: true, encoding: .utf8)
        try git.run(["stash", "push", "-m", "stash1"], context: Shell.Context(at: repoDir))
        let list = try git.run(["stash", "list"], context: Shell.Context(at: repoDir))
        XCTAssertTrue(list.contains("stash@{0}"))

        // pop
        try git.run(["stash", "pop"], context: Shell.Context(at: repoDir))
        // after pop stash list should be empty or not contain stash@{0}
        let list2 = try git.run(["stash", "list"], context: Shell.Context(at: repoDir))
        XCTAssertFalse(list2.contains("stash@{0}"))
    }

    func test_hash_object_and_cat_blob() throws {
        let env = try envOrSkip()
        let git = try Git(environment: env)
        let repoDir = try makeTempDir("repo-blob")
        try git.run(["init"], context: Shell.Context(at: repoDir))
        let file = repoDir.appendingPathComponent("blob.txt")
        try "blob-content\n".write(to: file, atomically: true, encoding: .utf8)
        // hash-object -w writes blob and returns hash
        let hash = try git.run(["hash-object", "-w", "blob.txt"], context: Shell.Context(at: repoDir))
        let trimmed = hash.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = try git.run(["cat-file", "-p", trimmed], context: Shell.Context(at: repoDir))
        XCTAssertTrue(content.contains("blob-content"))
    }

    func test_rebase_basic() throws {
        let env = try envOrSkip()
        let git = try Git(environment: env)
        let repoDir = try makeTempDir("repo-rebase")
        try git.run(["init"], context: Shell.Context(at: repoDir))
        try git.run(["config", "user.name", "R"], context: Shell.Context(at: repoDir))
        try git.run(["config", "user.email", "r@e"], context: Shell.Context(at: repoDir))

        try "0\n".write(to: repoDir.appendingPathComponent("n.txt"), atomically: true, encoding: .utf8)
        try git.run(["add", "n.txt"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "base"], context: Shell.Context(at: repoDir))

        try git.run(["checkout", "-b", "feature"], context: Shell.Context(at: repoDir))
        try "1\n".write(to: repoDir.appendingPathComponent("n.txt"), atomically: true, encoding: .utf8)
        try git.run(["commit", "-am", "feat1"], context: Shell.Context(at: repoDir))

        try git.run(["checkout", "master"], context: Shell.Context(at: repoDir))
        try "2\n".write(to: repoDir.appendingPathComponent("m.txt"), atomically: true, encoding: .utf8)
        try git.run(["add", "m.txt"], context: Shell.Context(at: repoDir))
        try git.run(["commit", "-m", "master change"], context: Shell.Context(at: repoDir))

        try git.run(["checkout", "feature"], context: Shell.Context(at: repoDir))
        try git.run(["rebase", "master"], context: Shell.Context(at: repoDir))

        let log = try git.run(["log", "--oneline", "-n", "5"], context: Shell.Context(at: repoDir))
        XCTAssertTrue(log.contains("feat1") || log.contains("feat1"))
    }

}
