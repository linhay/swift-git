public struct TagOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension TagOptions {
    
    ///  --annotate
    static let annotate: Self = "--annotate"
    ///  --cleanup=<mode>
    static func cleanup(_ mode: String) -> Self { .init("--cleanup=\(mode)") }
    ///  --color[=<when>]
    static func color(_ when: [String]) -> Self { .init("--color=\(when.joined(separator: ","))") }
    ///  --column[=<options>]
    static func column(_ options: [String]) -> Self { .init("--column=\(options.joined(separator: ","))") }
    ///  --contains [<commit>]
    static func contains(_ commit: [String]) -> Self { .init("--contains \(commit.joined(separator: ","))") }
    ///  --create-reflog
    static let createReflog: Self = "--create-reflog"
    ///  --delete
    static let delete: Self = "--delete"
    ///  --edit
    static let edit: Self = "--edit"
    ///  --file=<file>
    static func file(_ file: String) -> Self { .init("--file=\(file)") }
    ///  --force
    static let force: Self = "--force"
    ///  --format=<format>
    static func format(_ format: String) -> Self { .init("--format=\(format)") }
    ///  --ignore-case
    static let ignoreCase: Self = "--ignore-case"
    ///  --list
    static let list: Self = "--list"
    ///  --local-user=<keyid>
    static func localUser(_ keyid: String) -> Self { .init("--local-user=\(keyid)") }
    ///  --merged [<commit>]
    static func merged(_ commit: [String]) -> Self { .init("--merged \(commit.joined(separator: ","))") }
    ///  --message=<msg>
    static func message(_ msg: String) -> Self { .init("--message=\(msg)") }
    ///  --no-column
    static let noColumn: Self = "--no-column"
    ///  --no-contains [<commit>]
    static func noContains(_ commit: [String]) -> Self { .init("--no-contains \(commit.joined(separator: ","))") }
    ///  --no-merged [<commit>]
    static func noMerged(_ commit: [String]) -> Self { .init("--no-merged \(commit.joined(separator: ","))") }
    ///  --no-sign
    static let noSign: Self = "--no-sign"
    ///  --points-at <object>
    static func pointsAt(_ object: String) -> Self { .init("--points-at \(object)") }
    ///  --sign
    static let sign: Self = "--sign"
    ///  --sort=<key>
    static func sort(_ key: String) -> Self { .init("--sort=\(key)") }
    ///  --verify
    static let verify: Self = "--verify"
    
}
