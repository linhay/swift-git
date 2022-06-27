public struct HelpOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension HelpOptions {
    
    ///  --all
    static let all: Self = "--all"
    ///  --config
    static let config: Self = "--config"
    ///  --guides
    static let guides: Self = "--guides"
    ///  --info
    static let info: Self = "--info"
    ///  --man
    static let man: Self = "--man"
    ///  --no-aliases
    static let noAliases: Self = "--no-aliases"
    ///  --no-external-commands
    static let noExternalCommands: Self = "--no-external-commands"
    ///  --verbose
    static let verbose: Self = "--verbose"
    ///  --web
    static let web: Self = "--web"
    
}
