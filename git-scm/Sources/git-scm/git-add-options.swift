public struct AddOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension AddOptions {

    ///  --all
static let all: Self = "--all"
    ///  --dry-run
static let dryRun: Self = "--dry-run"
    ///  --edit
static let edit: Self = "--edit"
    ///  --force
static let force: Self = "--force"
    ///  --ignore-errors
static let ignoreErrors: Self = "--ignore-errors"
    ///  --ignore-missing
static let ignoreMissing: Self = "--ignore-missing"
    ///  --ignore-removal
static let ignoreRemoval: Self = "--ignore-removal"
    ///  --intent-to-add
static let intentToAdd: Self = "--intent-to-add"
    ///  --interactive
static let interactive: Self = "--interactive"
    ///  --no-all
static let noAll: Self = "--no-all"
    ///  --no-ignore-removal
static let noIgnoreRemoval: Self = "--no-ignore-removal"
    ///  --no-warn-embedded-repo
static let noWarnEmbeddedRepo: Self = "--no-warn-embedded-repo"
    ///  --patch
static let patch: Self = "--patch"
    ///  --pathspec-file-nul
static let pathspecFileNul: Self = "--pathspec-file-nul"
    ///  --pathspec-from-file=<file>
    static func pathspecFromFile(file: String) -> Self { .init("--pathspec-from-file=\(file)") }
    ///  --refresh
static let refresh: Self = "--refresh"
    ///  --renormalize
static let renormalize: Self = "--renormalize"
    ///  --sparse
static let sparse: Self = "--sparse"
    ///  --update
static let update: Self = "--update"
    ///  --verbose
static let verbose: Self = "--verbose"

}