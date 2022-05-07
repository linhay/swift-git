public struct CheckoutOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension CheckoutOptions {

    ///  --conflict=<style>
    static func conflict(_ style: String) -> Self { .init("--conflict=\(style)") }
    ///  --detach
static let detach: Self = "--detach"
    ///  --force
static let force: Self = "--force"
    ///  --guess
static let guess: Self = "--guess"
    ///  --ignore-other-worktrees
static let ignoreOtherWorktrees: Self = "--ignore-other-worktrees"
    ///  --ignore-skip-worktree-bits
static let ignoreSkipWorktreeBits: Self = "--ignore-skip-worktree-bits"
    ///  --merge
static let merge: Self = "--merge"
    ///  --no-guess
static let noGuess: Self = "--no-guess"
    ///  --no-overlay
static let noOverlay: Self = "--no-overlay"
    ///  --no-overwrite-ignore
static let noOverwriteIgnore: Self = "--no-overwrite-ignore"
    ///  --no-progress
static let noProgress: Self = "--no-progress"
    ///  --no-recurse-submodules
static let noRecurseSubmodules: Self = "--no-recurse-submodules"
    ///  --no-track
static let noTrack: Self = "--no-track"
    ///  --orphan <new-branch>
    static func orphan(_ newBranch: String) -> Self { .init("--orphan \(newBranch)") }
    ///  --ours
static let ours: Self = "--ours"
    ///  --overlay
static let overlay: Self = "--overlay"
    ///  --overwrite-ignore
static let overwriteIgnore: Self = "--overwrite-ignore"
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
    ///  --theirs
static let theirs: Self = "--theirs"
enum Track: String {
case direct
case inherit
}
    ///  --track[=(direct|inherit)]
    static func track(_ track: Track) -> Self { .init("--track=\(track.rawValue)") }

}