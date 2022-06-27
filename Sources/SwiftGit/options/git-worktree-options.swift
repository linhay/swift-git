public struct WorktreeOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension WorktreeOptions {
    
    ///  --checkout
    static let checkout: Self = "--checkout"
    ///  --detach
    static let detach: Self = "--detach"
    ///  --dry-run
    static let dryRun: Self = "--dry-run"
    ///  --expire <time>
    static func expire(_ time: String) -> Self { .init("--expire \(time)") }
    ///  --force
    static let force: Self = "--force"
    ///  --guess-remote
    static let guessRemote: Self = "--guess-remote"
    ///  --lock
    static let lock: Self = "--lock"
    ///  --no-checkout
    static let noCheckout: Self = "--no-checkout"
    ///  --no-guess-remote
    static let noGuessRemote: Self = "--no-guess-remote"
    ///  --no-track
    static let noTrack: Self = "--no-track"
    ///  --porcelain
    static let porcelain: Self = "--porcelain"
    ///  --quiet
    static let quiet: Self = "--quiet"
    ///  --reason <string>
    static func reason(_ string: String) -> Self { .init("--reason \(string)") }
    ///  --track
    static let track: Self = "--track"
    ///  --verbose
    static let verbose: Self = "--verbose"
    
}
