public struct InitOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension InitOptions {
    
    ///  --bare
    static let bare: Self = "--bare"
    ///  --initial-branch=<branch-name>
    static func initialBranch(_ branchName: String) -> Self { .init("--initial-branch=\(branchName)") }
    ///  --object-format=<format>
    static func objectFormat(_ format: String) -> Self { .init("--object-format=\(format)") }
    ///  --quiet
    static let quiet: Self = "--quiet"
    ///  --separate-git-dir=<git-dir>
    static func separateGitDir(_ gitDir: String) -> Self { .init("--separate-git-dir=\(gitDir)") }
    ///  --template=<template-directory>
    static func template(_ templateDirectory: String) -> Self { .init("--template=\(templateDirectory)") }
    enum Shared: String {
        case `false` = "false"
        case `true` = "true"
        case umask
        case group
        case all
        case world
        case everybody
        case perm = "<perm>"
    }
    ///  --shared[=(false|true|umask|group|all|world|everybody|<perm>)]
    static func shared(_ shared: Shared) -> Self { .init("--shared=\(shared.rawValue)") }
    
}
