import Foundation
import XCTest

@testable import SwiftGit

#if os(macOS)
@available(macOS 11, *)
final class ShellTests: XCTestCase {

    func testContext_merges_path_and_custom_env() {
        let customPath = "/custom/bin"
        let key = "SWIFTGIT_TEST_ENV_\(UUID().uuidString)"
        let context = Shell.Context(environment: ["PATH": customPath, key: "1"])

        XCTAssertEqual(context.environment[key], "1")

        let path = context.environment["PATH"] ?? ""
        XCTAssertTrue(path.contains(customPath))
    }

    func testShellArguments_builds_exec_and_commands() {
        let args = Shell.ShellArguments(kind: .zsh, command: "echo hi")
        let built = args.arguments
        XCTAssertEqual(built.exec?.path, "/bin/zsh")
        XCTAssertEqual(built.commands, ["-c", "echo hi"])
    }

    func testArguments_preserves_context_and_commands() {
        let context = Shell.Context(environment: ["FOO": "BAR"])
        let exec = URL(fileURLWithPath: "/usr/bin/true")
        let args = Shell.Arguments(exec: exec, commands: ["--version"], context: context)
        let built = args.arguments
        XCTAssertEqual(built.exec, exec)
        XCTAssertEqual(built.commands, ["--version"])
        XCTAssertEqual(built.context?.environment["FOO"], "BAR")
    }

    func testResult_success_returns_output() throws {
        let instance = Shell.Instance()
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/true")
        process.arguments = []
        try process.run()
        process.waitUntilExit()

        let result = instance.result(process, output: Data("ok".utf8), error: nil)
        switch result {
        case .success(let data):
            XCTAssertEqual(String(data: data, encoding: .utf8), "ok")
        case .failure:
            XCTFail("Expected success")
        }
    }

    func testResult_failure_includes_code() throws {
        let instance = Shell.Instance()
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/false")
        process.arguments = []
        try process.run()
        process.waitUntilExit()

        let result = instance.result(process, output: nil, error: nil)
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertTrue(error.localizedDescription.contains("code:"))
        }
    }

}
#endif
