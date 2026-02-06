import Foundation
import SwiftGit

public enum SwiftGitResourcesArm64 {
    public static let bundle = Bundle.module
}

public extension GitEnvironment.EmbeddedResource {
    static var arm64: GitEnvironment.EmbeddedResource {
        GitEnvironment.EmbeddedResource(bundle: SwiftGitResourcesArm64.bundle)
    }
}
