import Foundation
import SwiftGit

public enum SwiftGitResourcesX86_64 {
    public static let bundle = Bundle.module
}

public extension GitEnvironment.EmbeddedResource {
    static var x86_64: GitEnvironment.EmbeddedResource {
        GitEnvironment.EmbeddedResource(bundle: SwiftGitResourcesX86_64.bundle)
    }
}
