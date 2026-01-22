import XCTest
@testable import SwiftGit

final class CredentialHelperTests: XCTestCase {

    func makeTempFile() throws -> URL {
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("cred-\(UUID().uuidString).txt")
        return path
    }

    func envOrSkip() throws -> GitEnvironment {
        if let env = try? GitEnvironment(type: .embed) { return env }
        if let env = try? GitEnvironment(type: .system) { return env }
        throw XCTSkip("No git instance available (embed or system)")
    }

    func test_credential_store_helper_roundtrip() throws {
        let env = try envOrSkip()
        let exec = env.resource.executableURL
        let binDir = exec.deletingLastPathComponent()

        // look for git-credential-store helper
        let helper = binDir.appendingPathComponent("git-credential-store")
        guard FileManager.default.isExecutableFile(atPath: helper.path) else {
            throw XCTSkip("git-credential-store helper not available; skipping credential-store test")
        }

        let shell = Shell.Instance()
        let credFile = try makeTempFile()

        // store credential
        let storeInput = "protocol=https\nhost=example.com\nusername=testuser\npassword=secret\n\n"
        let argsStore = Shell.Arguments(exec: helper, commands: ["--file", credFile.path, "store"], context: nil)
        _ = try shell.data(argsStore, input: Data(storeInput.utf8))

        // now get credential
        let getInput = "protocol=https\nhost=example.com\n\n"
        let argsGet = Shell.Arguments(exec: helper, commands: ["--file", credFile.path, "get"], context: nil)
        let out = try shell.data(argsGet, input: Data(getInput.utf8))
        let result = String(data: out, encoding: .utf8) ?? ""
        XCTAssertTrue(result.contains("username=testuser"))
        XCTAssertTrue(result.contains("password=secret"))
    }

}
