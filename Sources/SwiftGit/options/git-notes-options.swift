public struct NotesOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension NotesOptions {

    ///  --abort
static let abort: Self = "--abort"
    ///  --allow-empty
static let allowEmpty: Self = "--allow-empty"
    ///  --commit
static let commit: Self = "--commit"
    ///  --dry-run
static let dryRun: Self = "--dry-run"
    ///  --file=<file>
    static func file(_ file: String) -> Self { .init("--file=\(file)") }
    ///  --force
static let force: Self = "--force"
    ///  --ignore-missing
static let ignoreMissing: Self = "--ignore-missing"
    ///  --message=<msg>
    static func message(_ msg: String) -> Self { .init("--message=\(msg)") }
    ///  --quiet
static let quiet: Self = "--quiet"
    ///  --reedit-message=<object>
    static func reeditMessage(_ object: String) -> Self { .init("--reedit-message=\(object)") }
    ///  --ref <ref>
    static func ref(_ ref: String) -> Self { .init("--ref \(ref)") }
    ///  --reuse-message=<object>
    static func reuseMessage(_ object: String) -> Self { .init("--reuse-message=\(object)") }
    ///  --stdin
static let stdin: Self = "--stdin"
    ///  --strategy=<strategy>
    static func strategy(_ strategy: String) -> Self { .init("--strategy=\(strategy)") }
    ///  --verbose
static let verbose: Self = "--verbose"

}