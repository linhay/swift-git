public struct ConfigOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension ConfigOptions {

    ///  --add
static let add: Self = "--add"
    ///  --blob <blob>
    static func blob(_ blob: String) -> Self { .init("--blob \(blob)") }
    ///  --bool
static let bool: Self = "--bool"
    ///  --bool-or-int
static let boolOrInt: Self = "--bool-or-int"
    ///  --default <value>
    static func `default`(_ value: String) -> Self { .init("--default \(value)") }
    ///  --edit
static let edit: Self = "--edit"
    ///  --expiry-date
static let expiryDate: Self = "--expiry-date"
    ///  --file <configFile>
    static func file(_ configFile: String) -> Self { .init("--file \(configFile)") }
    ///  --fixed-value
static let fixedValue: Self = "--fixed-value"
    ///  --get
static let get: Self = "--get"
    ///  --get-all
static let getAll: Self = "--get-all"
    ///  --get-color <name> [<default>]
    static func getColor(_ name: String, _ `default`: [String]) -> Self { .init("--get-color \(name) \(`default`.joined(separator: ","))") }
    ///  --get-colorbool <name> [<stdout-is-tty>]
    static func getColorbool(_ name: String, _ stdoutIsTty: [String]) -> Self { .init("--get-colorbool \(name) \(stdoutIsTty.joined(separator: ","))") }
    ///  --get-regexp
static let getRegexp: Self = "--get-regexp"
    ///  --get-urlmatch <name> <URL>
    static func getUrlmatch(_ name: String, _ uRL: String) -> Self { .init("--get-urlmatch \(name) \(uRL)") }
    ///  --global
static let global: Self = "--global"
    ///  --includes
static let includes: Self = "--includes"
    ///  --int
static let int: Self = "--int"
    ///  --list
static let list: Self = "--list"
    ///  --local
static let local: Self = "--local"
    ///  --name-only
static let nameOnly: Self = "--name-only"
    ///  --no-includes
static let noIncludes: Self = "--no-includes"
    ///  --no-type
static let noType: Self = "--no-type"
    ///  --null
static let null: Self = "--null"
    ///  --path
static let path: Self = "--path"
    ///  --remove-section
static let removeSection: Self = "--remove-section"
    ///  --rename-section
static let renameSection: Self = "--rename-section"
    ///  --replace-all
static let replaceAll: Self = "--replace-all"
    ///  --show-origin
static let showOrigin: Self = "--show-origin"
    ///  --show-scope
static let showScope: Self = "--show-scope"
    ///  --system
static let system: Self = "--system"
    ///  --type <type>
    static func type(_ type: String) -> Self { .init("--type \(type)") }
    ///  --unset
static let unset: Self = "--unset"
    ///  --unset-all
static let unsetAll: Self = "--unset-all"
    ///  --worktree
static let worktree: Self = "--worktree"

}