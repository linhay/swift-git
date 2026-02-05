import Foundation
import XCTest

@testable import SwiftGit

final class ParseTests: XCTestCase {

    func testChangedEntryIndex_valid() {
        let entry = GitStatus.ChangedEntry(
            XY: "MM",
            sub: "----",
            mH: "000",
            mI: "000",
            mW: "000",
            hH: "h",
            hI: "i",
            path: "path"
        )
        let index = entry.index
        XCTAssertEqual(index.staged, .modified)
        XCTAssertEqual(index.unStaged, .modified)
    }

    func testRenamedCopiedEntryIndex_valid() {
        let entry = GitStatus.RenamedCopiedEntry(
            XY: "A.",
            sub: "----",
            mH: "000",
            mI: "000",
            mW: "000",
            hH: "h",
            hI: "i",
            X: "R100",
            path: "to",
            score: "100",
            sep: "\t",
            origPath: "from"
        )
        let index = entry.index
        // staged 'A' (added) and unstaged '.' (unmodified)
        XCTAssertEqual(index.staged, .added)
        XCTAssertEqual(index.unStaged, .unmodified)
    }

    func testUnmergedEntryIndex_valid() {
        let entry = GitStatus.UnmergedEntry(
            XY: "UU",
            sub: "----",
            m1: "000",
            m2: "000",
            m3: "000",
            mW: "000",
            h1: "h1",
            h2: "h2",
            h3: "h3",
            path: "p"
        )
        let index = entry.index
        XCTAssertEqual(index.staged, .updatedButUnmerged)
        XCTAssertEqual(index.unStaged, .updatedButUnmerged)
    }

    func testResource_init_folder_missing_binaries_returns_nil() {
        // create a temporary folder without git binaries
        let fm = FileManager.default
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("swiftgit-test-\(UUID().uuidString)")
        try? fm.createDirectory(at: tmp, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tmp) }

        let resource = GitEnvironment.Resource(folder: tmp)
        XCTAssertNil(resource)
    }

    func testResource_init_folder_with_executables_returns_resource() throws {
        let fm = FileManager.default
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("swiftgit-test-\(UUID().uuidString)")
        let bin = tmp.appendingPathComponent("bin")
        let exec = tmp.appendingPathComponent("libexec/git-core")
        try fm.createDirectory(at: bin, withIntermediateDirectories: true)
        try fm.createDirectory(at: exec, withIntermediateDirectories: true)

        let git = bin.appendingPathComponent("git")
        let execPath = exec.appendingPathComponent("git")
        let script = "#!/bin/sh\nexit 0\n"
        try script.write(to: git, atomically: true, encoding: .utf8)
        try script.write(to: execPath, atomically: true, encoding: .utf8)
        try fm.setAttributes([.posixPermissions: 0o755], ofItemAtPath: git.path)
        try fm.setAttributes([.posixPermissions: 0o755], ofItemAtPath: execPath.path)
        defer { try? fm.removeItem(at: tmp) }

        let resource = GitEnvironment.Resource(folder: tmp)
        XCTAssertNotNil(resource)
        XCTAssertEqual(resource?.executableURL.lastPathComponent, "git")
        XCTAssertTrue(resource?.envExecPath?.hasSuffix("/libexec/git-core") ?? false)
    }

    func testResource_init_folder_with_non_executable_returns_nil() throws {
        let fm = FileManager.default
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("swiftgit-test-\(UUID().uuidString)")
        let bin = tmp.appendingPathComponent("bin")
        let exec = tmp.appendingPathComponent("libexec/git-core")
        try fm.createDirectory(at: bin, withIntermediateDirectories: true)
        try fm.createDirectory(at: exec, withIntermediateDirectories: true)

        let git = bin.appendingPathComponent("git")
        let execPath = exec.appendingPathComponent("git")
        let script = "#!/bin/sh\nexit 0\n"
        try script.write(to: git, atomically: true, encoding: .utf8)
        try script.write(to: execPath, atomically: true, encoding: .utf8)
        try fm.setAttributes([.posixPermissions: 0o644], ofItemAtPath: git.path)
        try fm.setAttributes([.posixPermissions: 0o644], ofItemAtPath: execPath.path)
        defer { try? fm.removeItem(at: tmp) }

        let resource = GitEnvironment.Resource(folder: tmp)
        XCTAssertNil(resource)
    }

    func testVariable_execPath_home_prefix_key_and_value() {
        let execPath = GitEnvironment.Variable.execPath("/tmp/git-core")
        XCTAssertEqual(execPath.key, "GIT_EXEC_PATH")
        XCTAssertEqual(execPath.value, "/tmp/git-core")

        let home = GitEnvironment.Variable.home("/tmp/home")
        XCTAssertEqual(home.key, "HOME")
        XCTAssertEqual(home.value, "/tmp/home")

        let prefix = GitEnvironment.Variable.prefix("/tmp/prefix")
        XCTAssertEqual(prefix.key, "PREFIX")
        XCTAssertEqual(prefix.value, "/tmp/prefix")
    }

    func testVariable_configNoSysyem_key_and_value() {
        let v = GitEnvironment.Variable.configNoSysyem(true)
        XCTAssertEqual(v.key, "GIT_CONFIG_NOSYSTEM")
        XCTAssertEqual(v.value, "true")
    }

    func testVariable_configNoSystem_key_and_value() {
        let v = GitEnvironment.Variable.configNoSystem(false)
        XCTAssertEqual(v.key, "GIT_CONFIG_NOSYSTEM")
        XCTAssertEqual(v.value, "false")
    }

    func testChangedEntryIndex_malformed_XY_returns_unmodified() {
        let entry = GitStatus.ChangedEntry(
            XY: "",
            sub: "----",
            mH: "000",
            mI: "000",
            mW: "000",
            hH: "h",
            hI: "i",
            path: "path"
        )
        let index = entry.index
        XCTAssertEqual(index.staged, .unmodified)
        XCTAssertEqual(index.unStaged, .unmodified)
    }

    func testHasEntry_various_types() {
        var status = GitStatus()
        XCTAssertFalse(status.hasEntry())
        status.changed.append(.init(XY: "MM", sub: "", mH: "", mI: "", mW: "", hH: "", hI: "", path: "p"))
        XCTAssertTrue(status.hasEntry())
        XCTAssertTrue(status.hasEntry(in: [.changed]))
        XCTAssertFalse(status.hasEntry(in: [.untracked]))
    }

    func testSplitCommandLine_basic_and_quoted() {
        let s1 = "git commit -m \"hello world\""
        let parts1 = splitCommandLine(s1)
        XCTAssertEqual(parts1, ["git", "commit", "-m", "hello world"]) 

        let s2 = "echo 'single quoted arg' plain"
        let parts2 = splitCommandLine(s2)
        XCTAssertEqual(parts2, ["echo", "single quoted arg", "plain"]) 

        let s3 = "cmd escaped\\ space"
        let parts3 = splitCommandLine(s3)
        XCTAssertEqual(parts3, ["cmd", "escaped space"]) 
    }

    func testSplitCommandLine_escaped_quotes() {
        let s1 = "git commit -m \"hello \\\"world\\\"\""
        let parts1 = splitCommandLine(s1)
        XCTAssertEqual(parts1, ["git", "commit", "-m", "hello \"world\""])
    }

    func testSplitCommandLine_multiple_spaces() {
        let s1 = "git   status   -sb"
        let parts1 = splitCommandLine(s1)
        XCTAssertEqual(parts1, ["git", "status", "-sb"])
    }

    func testSplitCommandLine_empty_string_returns_empty() {
        let parts = splitCommandLine("")
        XCTAssertTrue(parts.isEmpty)
    }

    func testSplitCommandLine_only_spaces_returns_empty() {
        let parts = splitCommandLine("     ")
        XCTAssertTrue(parts.isEmpty)
    }

    func testSplitCommandLine_trailing_escape_is_ignored() {
        let s1 = "cmd trailing\\"
        let parts1 = splitCommandLine(s1)
        XCTAssertEqual(parts1, ["cmd", "trailing"])
    }

    func testSplitCommandLine_tabs_are_not_split() {
        let cmd = "git\tstatus -sb"
        let parts = splitCommandLine(cmd)
        XCTAssertEqual(parts, ["git\tstatus", "-sb"])
    }

    func testSplitCommandLine_newlines_are_not_split() {
        let cmd = "git\nstatus"
        let parts = splitCommandLine(cmd)
        XCTAssertEqual(parts, ["git\nstatus"])
    }

    func testLogResults_parses_commit_metadata_and_message() {
        let env = GitEnvironment(
            resource: .init(executableURL: URL(fileURLWithPath: "/usr/bin/true")),
            variables: [],
            triggers: []
        )
        let repo = Repository(git: Git(environment: env), path: "/tmp")
        let commitID = "0123456789abcdef0123456789abcdef01234567"
        let log = """
        commit \(commitID)
        Author: Alice <alice@example.com>
        AuthorDate: Mon Nov 17 18:21:25 2025 +0800
        Commit: Bob <bob@example.com>
        CommitDate: Mon Nov 17 19:21:25 2025 +0800

        Initial commit
        Second line
        """

        let results = repo.logResults(from: log)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].id, commitID)
        XCTAssertEqual(results[0].author.user.name, "Alice")
        XCTAssertEqual(results[0].author.user.email, "alice@example.com")
        XCTAssertEqual(results[0].commit.user.name, "Bob")
        XCTAssertEqual(results[0].commit.user.email, "bob@example.com")
        XCTAssertEqual(results[0].message, "Initial commit\nSecond line")
    }

    func testLogResults_parses_multiple_commits() {
        let env = GitEnvironment(
            resource: .init(executableURL: URL(fileURLWithPath: "/usr/bin/true")),
            variables: [],
            triggers: []
        )
        let repo = Repository(git: Git(environment: env), path: "/tmp")
        let commit1 = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        let commit2 = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
        let log = """
        commit \(commit1)
        Author: Alice <alice@example.com>
        AuthorDate: Mon Nov 17 18:21:25 2025 +0800
        Commit: Alice <alice@example.com>
        CommitDate: Mon Nov 17 18:21:25 2025 +0800

        First commit
        commit \(commit2)
        Author: Bob <bob@example.com>
        AuthorDate: Tue Nov 18 10:11:12 2025 +0800
        Commit: Bob <bob@example.com>
        CommitDate: Tue Nov 18 10:11:12 2025 +0800

        Second commit
        """

        let results = repo.logResults(from: log)
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results[0].id, commit1)
        XCTAssertEqual(results[0].message, "First commit")
        XCTAssertEqual(results[1].id, commit2)
        XCTAssertEqual(results[1].message, "Second commit")
    }

    func testLogResults_empty_input_returns_empty_array() {
        let env = GitEnvironment(
            resource: .init(executableURL: URL(fileURLWithPath: "/usr/bin/true")),
            variables: [],
            triggers: []
        )
        let repo = Repository(git: Git(environment: env), path: "/tmp")
        let results = repo.logResults(from: "")
        XCTAssertTrue(results.isEmpty)
    }

    func testLogResults_message_trims_first_line_only() {
        let env = GitEnvironment(
            resource: .init(executableURL: URL(fileURLWithPath: "/usr/bin/true")),
            variables: [],
            triggers: []
        )
        let repo = Repository(git: Git(environment: env), path: "/tmp")
        let commitID = "cccccccccccccccccccccccccccccccccccccccc"
        let log = """
        commit \(commitID)
        Author: Alice <alice@example.com>
        AuthorDate: Mon Nov 17 18:21:25 2025 +0800
        Commit: Alice <alice@example.com>
        CommitDate: Mon Nov 17 18:21:25 2025 +0800

            First line
          Second line
        """

        let results = repo.logResults(from: log)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].message, "First line\n  Second line")
    }

    func testSplitCommandLine_mixed_quotes() {
        let cmd = "cmd \"a 'b'\" 'c \"d\"'"
        let parts = splitCommandLine(cmd)
        XCTAssertEqual(parts, ["cmd", "a 'b'", "c \"d\""])
    }

    func testSplitCommandLine_unterminated_quotes_are_treated_as_literal() {
        let cmd = "git commit -m \"unterminated"
        let parts = splitCommandLine(cmd)
        XCTAssertEqual(parts, ["git", "commit", "-m", "unterminated"])
    }

    func testSplitCommandLine_multiple_escapes() {
        let cmd = "cmd a\\\\ b"
        let parts = splitCommandLine(cmd)
        XCTAssertEqual(parts, ["cmd", "a\\", "b"])
    }

    func testSplitCommandLine_leading_and_trailing_spaces() {
        let cmd = "   git status   "
        let parts = splitCommandLine(cmd)
        XCTAssertEqual(parts, ["git", "status"])
    }

    func testLogResults_handles_missing_metadata() {
        let env = GitEnvironment(
            resource: .init(executableURL: URL(fileURLWithPath: "/usr/bin/true")),
            variables: [],
            triggers: []
        )
        let repo = Repository(git: Git(environment: env), path: "/tmp")
        let commitID = "dddddddddddddddddddddddddddddddddddddddd"
        let log = """
        commit \(commitID)

        Message only
        """

        let results = repo.logResults(from: log)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].id, commitID)
        XCTAssertEqual(results[0].author.user.name, "")
        XCTAssertEqual(results[0].commit.user.name, "")
        XCTAssertEqual(results[0].message, "Message only")
    }

    func testLogResults_handles_out_of_order_metadata() {
        let env = GitEnvironment(
            resource: .init(executableURL: URL(fileURLWithPath: "/usr/bin/true")),
            variables: [],
            triggers: []
        )
        let repo = Repository(git: Git(environment: env), path: "/tmp")
        let commitID = "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
        let log = """
        commit \(commitID)
        Commit: Bob <bob@example.com>
        CommitDate: Mon Nov 17 18:21:25 2025 +0800
        Author: Alice <alice@example.com>
        AuthorDate: Mon Nov 17 17:21:25 2025 +0800

        Message
        """

        let results = repo.logResults(from: log)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].author.user.name, "Alice")
        XCTAssertEqual(results[0].commit.user.name, "Bob")
        XCTAssertEqual(results[0].message, "Message")
    }

    func testLogResults_omits_blank_lines_in_message() {
        let env = GitEnvironment(
            resource: .init(executableURL: URL(fileURLWithPath: "/usr/bin/true")),
            variables: [],
            triggers: []
        )
        let repo = Repository(git: Git(environment: env), path: "/tmp")
        let commitID = "ffffffffffffffffffffffffffffffffffffffff"
        let log = """
        commit \(commitID)
        Author: Alice <alice@example.com>
        AuthorDate: Mon Nov 17 18:21:25 2025 +0800
        Commit: Alice <alice@example.com>
        CommitDate: Mon Nov 17 18:21:25 2025 +0800

        First line

        Third line
        """

        let results = repo.logResults(from: log)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].message, "First line\nThird line")
    }

}
