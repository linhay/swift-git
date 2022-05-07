public struct CloneOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension CloneOptions {

    ///  --also-filter-submodules
static let alsoFilterSubmodules: Self = "--also-filter-submodules"
    ///  --bare
static let bare: Self = "--bare"
    ///  --branch <name>
    static func branch(_ name: String) -> Self { .init("--branch \(name)") }
    ///  --config <key>=<value>
    static func configKey(_ value: String) -> Self { .init("--config <key>=\(value)") }
    ///  --depth <depth>
    static func depth(_ depth: String) -> Self { .init("--depth \(depth)") }
    ///  --dissociate
static let dissociate: Self = "--dissociate"
    ///  --filter=<filter-spec>
    static func filter(_ filterSpec: String) -> Self { .init("--filter=\(filterSpec)") }
    ///  --jobs <n>
    static func jobs(_ n: String) -> Self { .init("--jobs \(n)") }
    ///  --local
static let local: Self = "--local"
    ///  --mirror
static let mirror: Self = "--mirror"
    ///  --no-checkout
static let noCheckout: Self = "--no-checkout"
    ///  --no-hardlinks
static let noHardlinks: Self = "--no-hardlinks"
    ///  --no-reject-shallow
static let noRejectShallow: Self = "--no-reject-shallow"
    ///  --no-remote-submodules
static let noRemoteSubmodules: Self = "--no-remote-submodules"
    ///  --no-shallow-submodules
static let noShallowSubmodules: Self = "--no-shallow-submodules"
    ///  --no-single-branch
static let noSingleBranch: Self = "--no-single-branch"
    ///  --no-tags
static let noTags: Self = "--no-tags"
    ///  --origin <name>
    static func origin(_ name: String) -> Self { .init("--origin \(name)") }
    ///  --progress
static let progress: Self = "--progress"
    ///  --quiet
static let quiet: Self = "--quiet"
    ///  --recurse-submodules[=<pathspec>]
    static func recurseSubmodules(_ pathspec: [String]) -> Self { .init("--recurse-submodules=\(pathspec.joined(separator: ","))") }
    ///  --reference <repository>
    static func reference(_ repository: String) -> Self { .init("--reference \(repository)") }
    ///  --reference-if-able <repository>
    static func referenceIfAble(_ repository: String) -> Self { .init("--reference-if-able \(repository)") }
    ///  --reject-shallow
static let rejectShallow: Self = "--reject-shallow"
    ///  --remote-submodules
static let remoteSubmodules: Self = "--remote-submodules"
    ///  --separate-git-dir=<git-dir>
    static func separateGitDir(_ gitDir: String) -> Self { .init("--separate-git-dir=\(gitDir)") }
    ///  --server-option=<option>
    static func serverOption(_ option: String) -> Self { .init("--server-option=\(option)") }
    ///  --shallow-exclude=<revision>
    static func shallowExclude(_ revision: String) -> Self { .init("--shallow-exclude=\(revision)") }
    ///  --shallow-since=<date>
    static func shallowSince(_ date: String) -> Self { .init("--shallow-since=\(date)") }
    ///  --shallow-submodules
static let shallowSubmodules: Self = "--shallow-submodules"
    ///  --shared
static let shared: Self = "--shared"
    ///  --single-branch
static let singleBranch: Self = "--single-branch"
    ///  --sparse
static let sparse: Self = "--sparse"
    ///  --template=<template-directory>
    static func template(_ templateDirectory: String) -> Self { .init("--template=\(templateDirectory)") }
    ///  --upload-pack <upload-pack>
    static func uploadPack(_ uploadPack: String) -> Self { .init("--upload-pack \(uploadPack)") }
    ///  --verbose
static let verbose: Self = "--verbose"

}