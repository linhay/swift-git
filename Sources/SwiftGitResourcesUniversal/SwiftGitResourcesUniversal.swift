import Foundation
import SwiftGit

public enum SwiftGitResourcesUniversal {
    public static let bundle = Bundle.module
}

public extension GitEnvironment.EmbeddedResource {
    static var universal: GitEnvironment.EmbeddedResource {
        GitEnvironment.EmbeddedResource(bundle: SwiftGitResourcesUniversal.bundle)
    }
}
