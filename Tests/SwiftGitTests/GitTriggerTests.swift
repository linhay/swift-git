import Foundation
import XCTest

@testable import SwiftGit

final class GitTriggerTests: XCTestCase {

    func testSuccessTrigger_onlyRunsOnSuccess() {
        var successCount = 0
        let trigger = GitTrigger.success(on: .afterRun) { content in
            successCount += 1
            XCTAssertEqual(content.commands, ["status"])
        }

        let content = GitTrigger.Content(commands: ["status"], data: Data())
        trigger.action(.success(content))
        XCTAssertEqual(successCount, 1)

        let error = GitTrigger.Error(commands: ["status"], message: "boom")
        trigger.action(.failure(error))
        XCTAssertEqual(successCount, 1)
    }

    func testFailureTrigger_onlyRunsOnFailure() {
        var failureCount = 0
        let trigger = GitTrigger.failure(on: .beforeRun) { error in
            failureCount += 1
            XCTAssertEqual(error.commands, ["clone"])
            XCTAssertEqual(error.message, "fatal: boom")
        }

        let content = GitTrigger.Content(commands: ["clone"], data: Data())
        trigger.action(.success(content))
        XCTAssertEqual(failureCount, 0)

        let error = GitTrigger.Error(commands: ["clone"], message: "fatal: boom")
        trigger.action(.failure(error))
        XCTAssertEqual(failureCount, 1)
    }

}
