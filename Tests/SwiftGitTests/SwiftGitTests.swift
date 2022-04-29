import XCTest
@testable import SwiftGit

final class SwiftGitTests: XCTestCase {
    
    func testExample() throws {
        print(try Git.create(at: "/Users/linhey/Desktop/asset-template").run("log"))
    }
    
}
