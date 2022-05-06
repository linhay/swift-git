public struct ResetOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension ResetOptions {

    ///  --hard
static let hard: Self = "--hard"
    ///  --keep
static let keep: Self = "--keep"
    ///  --merge
static let merge: Self = "--merge"
    ///  --mixed
static let mixed: Self = "--mixed"
    ///  --no-recurse-submodules
static let noRecurseSubmodules: Self = "--no-recurse-submodules"
    ///  --no-refresh
static let noRefresh: Self = "--no-refresh"
    ///  --pathspec-file-nul
static let pathspecFileNul: Self = "--pathspec-file-nul"
    ///  --pathspec-from-file=<file>
    static func pathspecFromFile(file: String) -> Self { .init("--pathspec-from-file=\(file)") }
    ///  --quiet
static let quiet: Self = "--quiet"
    ///  --recurse-submodules
static let recurseSubmodules: Self = "--recurse-submodules"
    ///  --refresh
static let refresh: Self = "--refresh"
    ///  --soft
static let soft: Self = "--soft"

}