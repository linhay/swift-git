public struct DescribeOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension DescribeOptions {
    
    ///  --abbrev=<n>
    static func abbrev(_ n: String) -> Self { .init("--abbrev=\(n)") }
    ///  --all
    static let all: Self = "--all"
    ///  --always
    static let always: Self = "--always"
    ///  --broken[=<mark>]
    static func broken(_ mark: [String]) -> Self { .init("--broken=\(mark.joined(separator: ","))") }
    ///  --candidates=<n>
    static func candidates(_ n: String) -> Self { .init("--candidates=\(n)") }
    ///  --contains
    static let contains: Self = "--contains"
    ///  --debug
    static let debug: Self = "--debug"
    ///  --dirty[=<mark>]
    static func dirty(_ mark: [String]) -> Self { .init("--dirty=\(mark.joined(separator: ","))") }
    ///  --exact-match
    static let exactMatch: Self = "--exact-match"
    ///  --exclude <pattern>
    static func exclude(_ pattern: String) -> Self { .init("--exclude \(pattern)") }
    ///  --first-parent
    static let firstParent: Self = "--first-parent"
    ///  --long
    static let long: Self = "--long"
    ///  --match <pattern>
    static func match(_ pattern: String) -> Self { .init("--match \(pattern)") }
    ///  --tags
    static let tags: Self = "--tags"
    
}
