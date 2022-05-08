public struct StatusOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension StatusOptions {
    
    ///  --ahead-behind
    static let aheadBehind: Self = "--ahead-behind"
    ///  --branch
    static let branch: Self = "--branch"
    ///  --column[=<options>]
    static func column(_ options: [String]) -> Self { .init("--column=\(options.joined(separator: ","))") }
    ///  --find-renames[=<n>]
    static func findRenames(_ n: [String]) -> Self { .init("--find-renames=\(n.joined(separator: ","))") }
    ///  --ignore-submodules[=<when>]
    static func ignoreSubmodules(_ when: [String]) -> Self { .init("--ignore-submodules=\(when.joined(separator: ","))") }
    ///  --ignored[=<mode>]
    static func ignored(_ mode: [String]) -> Self { .init("--ignored=\(mode.joined(separator: ","))") }
    ///  --long
    static let long: Self = "--long"
    ///  --no-ahead-behind
    static let noAheadBehind: Self = "--no-ahead-behind"
    ///  --no-column
    static let noColumn: Self = "--no-column"
    ///  --no-renames
    static let noRenames: Self = "--no-renames"
    ///  --porcelain[=<version>]
    static func porcelain(_ version: [String]) -> Self { .init("--porcelain=\(version.joined(separator: ","))") }
    ///  --renames
    static let renames: Self = "--renames"
    ///  --short
    static let short: Self = "--short"
    ///  --show-stash
    static let showStash: Self = "--show-stash"
    ///  --untracked-files[=<mode>]
    static func untrackedFiles(_ mode: [String]) -> Self { .init("--untracked-files=\(mode.joined(separator: ","))") }
    ///  --verbose
    static let verbose: Self = "--verbose"
    
}
