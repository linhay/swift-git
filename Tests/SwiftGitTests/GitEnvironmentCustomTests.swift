import Foundation
import XCTest

@testable import SwiftGit

final class GitEnvironmentCustomTests: XCTestCase {

    func testCustomEnvironment_injects_exec_path_and_no_system_config() throws {
        let fm = FileManager.default
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("swiftgit-env-\(UUID().uuidString)")
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

        let env = try GitEnvironment(type: .custom(tmp), variables: [], triggers: [])
        XCTAssertEqual(env.resource.executableURL.lastPathComponent, "git")
        XCTAssertTrue(env.resource.envExecPath?.hasSuffix("/libexec/git-core") ?? false)

        let vars = Dictionary(uniqueKeysWithValues: env.variables.map { ($0.key, $0.value) })
        XCTAssertEqual(vars["GIT_CONFIG_NOSYSTEM"], "true")
        XCTAssertEqual(vars["GIT_EXEC_PATH"], exec.path)
    }

}
