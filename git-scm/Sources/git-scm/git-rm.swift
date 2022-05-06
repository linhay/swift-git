public struct RmOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension RmOptions {

    ///  --cached
static let cached: Self = "--cached"
    ///  --dry-run
static let dryRun: Self = "--dry-run"
    ///  --force
static let force: Self = "--force"
    ///  --ignore-unmatch
static let ignoreUnmatch: Self = "--ignore-unmatch"
    ///  --pathspec-file-nul
static let pathspecFileNul: Self = "--pathspec-file-nul"
    ///  --pathspec-from-file=<file>
    static func pathspecFromFile(file: String) -> Self { .init("--pathspec-from-file=\(file)") }
    ///  --quiet
static let quiet: Self = "--quiet"
    ///  --sparse
static let sparse: Self = "--sparse"

}