public struct GitOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension GitOptions {
    
    ///  --bare
    static let bare: Self = "--bare"
    ///  --exec-path[=<path>]
    static func execPath(_ path: [String]) -> Self { .init("--exec-path=\(path.joined(separator: ","))") }
    ///  --git-dir=<path>
    static func gitDir(_ path: String) -> Self { .init("--git-dir=\(path)") }
    ///  --glob-pathspecs
    static let globPathspecs: Self = "--glob-pathspecs"
    ///  --help
    static let help: Self = "--help"
    ///  --html-path
    static let htmlPath: Self = "--html-path"
    ///  --icase-pathspecs
    static let icasePathspecs: Self = "--icase-pathspecs"
    ///  --info-path
    static let infoPath: Self = "--info-path"
    ///  --literal-pathspecs
    static let literalPathspecs: Self = "--literal-pathspecs"
    ///  --man-path
    static let manPath: Self = "--man-path"
    ///  --namespace=<path>
    static func namespace(_ path: String) -> Self { .init("--namespace=\(path)") }
    ///  --no-optional-locks
    static let noOptionalLocks: Self = "--no-optional-locks"
    ///  --no-pager
    static let noPager: Self = "--no-pager"
    ///  --no-replace-objects
    static let noReplaceObjects: Self = "--no-replace-objects"
    ///  --noglob-pathspecs
    static let noglobPathspecs: Self = "--noglob-pathspecs"
    ///  --paginate
    static let paginate: Self = "--paginate"
    ///  --super-prefix=<path>
    static func superPrefix(_ path: String) -> Self { .init("--super-prefix=\(path)") }
    ///  --version
    static let version: Self = "--version"
    ///  --work-tree=<path>
    static func workTree(_ path: String) -> Self { .init("--work-tree=\(path)") }
    
}
