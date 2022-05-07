public struct SubmoduleOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension SubmoduleOptions {

    ///  --all
static let all: Self = "--all"
    ///  --branch <branch>
    static func branch(_ branch: String) -> Self { .init("--branch \(branch)") }
    ///  --cached
static let cached: Self = "--cached"
    ///  --checkout
static let checkout: Self = "--checkout"
    ///  --depth
static let depth: Self = "--depth"
    ///  --dissociate
static let dissociate: Self = "--dissociate"
    ///  --files
static let files: Self = "--files"
    ///  --force
static let force: Self = "--force"
    ///  --init
static let `init`: Self = "--init"
    ///  --jobs <n>
    static func jobs(_ n: String) -> Self { .init("--jobs \(n)") }
    ///  --merge
static let merge: Self = "--merge"
    ///  --name
static let name: Self = "--name"
    ///  --no-fetch
static let noFetch: Self = "--no-fetch"
    ///  --no-recommend-shallow
static let noRecommendShallow: Self = "--no-recommend-shallow"
    ///  --no-single-branch
static let noSingleBranch: Self = "--no-single-branch"
    ///  --progress
static let progress: Self = "--progress"
    ///  --quiet
static let quiet: Self = "--quiet"
    ///  --rebase
static let rebase: Self = "--rebase"
    ///  --recommend-shallow
static let recommendShallow: Self = "--recommend-shallow"
    ///  --recursive
static let recursive: Self = "--recursive"
    ///  --reference <repository>
    static func reference(_ repository: String) -> Self { .init("--reference \(repository)") }
    ///  --remote
static let remote: Self = "--remote"
    ///  --single-branch
static let singleBranch: Self = "--single-branch"
    ///  --summary-limit
static let summaryLimit: Self = "--summary-limit"

}