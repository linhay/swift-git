public struct RestoreOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension RestoreOptions {
    
    ///  --conflict=<style>
    static func conflict(_ style: String) -> Self { .init("--conflict=\(style)") }
    ///  --ignore-skip-worktree-bits
    static let ignoreSkipWorktreeBits: Self = "--ignore-skip-worktree-bits"
    ///  --ignore-unmerged
    static let ignoreUnmerged: Self = "--ignore-unmerged"
    ///  --merge
    static let merge: Self = "--merge"
    ///  --no-overlay
    static let noOverlay: Self = "--no-overlay"
    ///  --no-progress
    static let noProgress: Self = "--no-progress"
    ///  --no-recurse-submodules
    static let noRecurseSubmodules: Self = "--no-recurse-submodules"
    ///  --ours
    static let ours: Self = "--ours"
    ///  --overlay
    static let overlay: Self = "--overlay"
    ///  --patch
    static let patch: Self = "--patch"
    ///  --pathspec-file-nul
    static let pathspecFileNul: Self = "--pathspec-file-nul"
    ///  --pathspec-from-file=<file>
    static func pathspecFromFile(_ file: String) -> Self { .init("--pathspec-from-file=\(file)") }
    ///  --progress
    static let progress: Self = "--progress"
    ///  --quiet
    static let quiet: Self = "--quiet"
    ///  --recurse-submodules
    static let recurseSubmodules: Self = "--recurse-submodules"
    ///  --source=<tree>
    static func source(_ tree: String) -> Self { .init("--source=\(tree)") }
    ///  --staged
    static let staged: Self = "--staged"
    ///  --theirs
    static let theirs: Self = "--theirs"
    ///  --worktree
    static let worktree: Self = "--worktree"
    
}
