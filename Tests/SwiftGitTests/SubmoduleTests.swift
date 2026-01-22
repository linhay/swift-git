import XCTest
@testable import SwiftGit

final class SubmoduleTests: XCTestCase {

    func makeTempDir(_ name: String = "swiftgit-sub") throws -> URL {
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

    func test_add_init_and_update_submodule() throws {
        let env = try envOrSkip()
        let git = Git(environment: env)

        // create main repo
        let main = try makeTempDir("main-repo")
        try git.run(["init"], context: Shell.Context(at: main))
        try git.run(["config", "user.name", "Sub"], context: Shell.Context(at: main))
        try git.run(["config", "user.email", "s@e"], context: Shell.Context(at: main))

        // create submodule repo
        let sub = try makeTempDir("sub-repo")
        try git.run(["init"], context: Shell.Context(at: sub))
        try git.run(["config", "user.name", "Sub"], context: Shell.Context(at: sub))
        try git.run(["config", "user.email", "s@e"], context: Shell.Context(at: sub))
        try "s".write(to: sub.appendingPathComponent("f.txt"), atomically: true, encoding: .utf8)
        try git.run(["add", "f.txt"], context: Shell.Context(at: sub))
        try git.run(["commit", "-m", "sub commit"], context: Shell.Context(at: sub))

        // add submodule to main
        let subUrl = sub.path
        try git.run(["submodule", "add", subUrl, "sub"], context: Shell.Context(at: main))
        try git.run(["commit", "-am", "add submodule"], context: Shell.Context(at: main))

        // update submodule
        try git.run(["submodule", "update", "--init", "--recursive"], context: Shell.Context(at: main))

        // check submodule content
        let subFile = main.appendingPathComponent("sub").appendingPathComponent("f.txt")
        XCTAssertTrue(FileManager.default.fileExists(atPath: subFile.path))
    }

}
