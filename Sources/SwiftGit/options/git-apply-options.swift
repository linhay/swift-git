public struct ApplyOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension ApplyOptions {
    
    ///  --3way
    static let _3way: Self = "--3way"
    ///  --allow-binary-replacement
    static let allowBinaryReplacement: Self = "--allow-binary-replacement"
    ///  --allow-empty
    static let allowEmpty: Self = "--allow-empty"
    ///  --apply
    static let apply: Self = "--apply"
    ///  --binary
    static let binary: Self = "--binary"
    ///  --build-fake-ancestor=<file>
    static func buildFakeAncestor(_ file: String) -> Self { .init("--build-fake-ancestor=\(file)") }
    ///  --cached
    static let cached: Self = "--cached"
    ///  --check
    static let check: Self = "--check"
    ///  --directory=<root>
    static func directory(_ root: String) -> Self { .init("--directory=\(root)") }
    ///  --exclude=<path-pattern>
    static func exclude(_ pathPattern: String) -> Self { .init("--exclude=\(pathPattern)") }
    ///  --ignore-space-change
    static let ignoreSpaceChange: Self = "--ignore-space-change"
    ///  --ignore-whitespace
    static let ignoreWhitespace: Self = "--ignore-whitespace"
    ///  --inaccurate-eof
    static let inaccurateEof: Self = "--inaccurate-eof"
    ///  --include=<path-pattern>
    static func include(_ pathPattern: String) -> Self { .init("--include=\(pathPattern)") }
    ///  --index
    static let index: Self = "--index"
    ///  --intent-to-add
    static let intentToAdd: Self = "--intent-to-add"
    ///  --no-add
    static let noAdd: Self = "--no-add"
    ///  --numstat
    static let numstat: Self = "--numstat"
    ///  --quiet
    static let quiet: Self = "--quiet"
    ///  --recount
    static let recount: Self = "--recount"
    ///  --reject
    static let reject: Self = "--reject"
    ///  --reverse
    static let reverse: Self = "--reverse"
    ///  --stat
    static let stat: Self = "--stat"
    ///  --summary
    static let summary: Self = "--summary"
    ///  --unidiff-zero
    static let unidiffZero: Self = "--unidiff-zero"
    ///  --unsafe-paths
    static let unsafePaths: Self = "--unsafe-paths"
    ///  --verbose
    static let verbose: Self = "--verbose"
    ///  --whitespace=<action>
    static func whitespace(_ action: String) -> Self { .init("--whitespace=\(action)") }
    
}
