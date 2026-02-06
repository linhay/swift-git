import XCTest
@testable import SwiftGit

final class PlumbingTests: XCTestCase {

    func makeTempDir(_ name: String = "swiftgit-plumb") throws -> URL {
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

    func test_update_index_add_and_write_tree() throws {
        let env = try envOrSkip()
        let git = try Git(environment: env)
        let dir = try makeTempDir()
        try git.run(["init"], context: Shell.Context(at: dir))
        try git.run(["config", "user.name", "P"], context: Shell.Context(at: dir))
        try git.run(["config", "user.email", "p@e"], context: Shell.Context(at: dir))

        // create files
        try "one".write(to: dir.appendingPathComponent("one.txt"), atomically: true, encoding: .utf8)
        try "two".write(to: dir.appendingPathComponent("two.txt"), atomically: true, encoding: .utf8)

        // use update-index to add paths to index
        try git.run(["update-index", "--add", "one.txt"], context: Shell.Context(at: dir))
        try git.run(["update-index", "--add", "two.txt"], context: Shell.Context(at: dir))

        // write-tree should produce a tree object
        let tree = try git.run(["write-tree"], context: Shell.Context(at: dir))
        let t = tree.trimmingCharacters(in: .whitespacesAndNewlines)
        XCTAssertFalse(t.isEmpty)
        let typ = try git.run(["cat-file", "-t", t], context: Shell.Context(at: dir))
        XCTAssertEqual(typ.trimmingCharacters(in: .whitespacesAndNewlines), "tree")
    }

    func test_ls_files_ls_tree_rev_list_and_show_ref() throws {
        let env = try envOrSkip()
        let git = try Git(environment: env)
        let dir = try makeTempDir()
        try git.run(["init"], context: Shell.Context(at: dir))
        try git.run(["config", "user.name", "Q"], context: Shell.Context(at: dir))
        try git.run(["config", "user.email", "q@e"], context: Shell.Context(at: dir))

        try "alpha".write(to: dir.appendingPathComponent("a.txt"), atomically: true, encoding: .utf8)
        try git.run(["add", "a.txt"], context: Shell.Context(at: dir))
        try git.run(["commit", "-m", "c1"], context: Shell.Context(at: dir))

        // ls-files should include a.txt
        let ls = try git.run(["ls-files"], context: Shell.Context(at: dir))
        XCTAssertTrue(ls.contains("a.txt"))

        // rev-list count should be >= 1
        let count = try git.run(["rev-list", "--count", "HEAD"], context: Shell.Context(at: dir))
        XCTAssertTrue((Int(count.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0) >= 1)

        // ls-tree should show the file in HEAD
        let lst = try git.run(["ls-tree", "HEAD"], context: Shell.Context(at: dir))
        XCTAssertTrue(lst.contains("a.txt"))

        // show-ref should include HEAD's branch ref
        let branch = try git.run(["rev-parse", "--abbrev-ref", "HEAD"], context: Shell.Context(at: dir))
        let refs = try git.run(["show-ref"], context: Shell.Context(at: dir))
        XCTAssertTrue(refs.contains(branch.trimmingCharacters(in: .whitespacesAndNewlines)))
    }

    func test_update_ref_creates_new_ref() throws {
        let env = try envOrSkip()
        let git = try Git(environment: env)
        let dir = try makeTempDir()
        try git.run(["init"], context: Shell.Context(at: dir))
        try git.run(["config", "user.name", "U"], context: Shell.Context(at: dir))
        try git.run(["config", "user.email", "u@e"], context: Shell.Context(at: dir))

        try "x".write(to: dir.appendingPathComponent("x.txt"), atomically: true, encoding: .utf8)
        try git.run(["add", "x.txt"], context: Shell.Context(at: dir))
        try git.run(["commit", "-m", "c"], context: Shell.Context(at: dir))
        let head = try git.run(["rev-parse", "HEAD"], context: Shell.Context(at: dir))
        let commitHash = head.trimmingCharacters(in: .whitespacesAndNewlines)

        try git.run(["update-ref", "refs/heads/testref", commitHash], context: Shell.Context(at: dir))
        let refs = try git.run(["for-each-ref", "--format=%(refname)"], context: Shell.Context(at: dir))
        XCTAssertTrue(refs.contains("refs/heads/testref"))
    }

}
