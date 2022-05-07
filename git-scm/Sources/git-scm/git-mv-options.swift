public struct MvOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension MvOptions {

    ///  --dry-run
static let dryRun: Self = "--dry-run"
    ///  --force
static let force: Self = "--force"
    ///  --verbose
static let verbose: Self = "--verbose"

}