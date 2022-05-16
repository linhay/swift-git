public struct StashOptions: ExpressibleByStringLiteral {
    
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension StashOptions {
    
    struct DropSet {
        let options: StashOptions
        public static let quiet: Self = .init(options: .quiet)
    }
    
    struct PopSet {
        let options: StashOptions
        public static let quiet: Self = .init(options: .quiet)
        public static let index: Self = .init(options: .index)
    }
    
    struct ShowSet {
        let options: StashOptions
        public static let onlyUntracked: Self    = .init(options: .onlyUntracked)
        public static let includeUntracked: Self = .init(options: .includeUntracked)
    }
    
    struct StoreSet {
        let options: StashOptions
        public static let quiet: Self = .init(options: .quiet)
        public static func message(_ msg: String) -> Self { .init(options: .message(msg)) }
    }
    
    struct PushSet {
        let options: StashOptions
        public static let staged: Self = .init(options: .staged)
        public static let patch: Self  = .init(options: .patch)
        public static let keepIndex: Self   = .init(options: .keepIndex)
        public static let noKeepIndex: Self = .init(options: .noKeepIndex)
        public static let includeUntracked: Self   = .init(options: .includeUntracked)
        public static let noIncludeUntracked: Self = .init(options: .noIncludeUntracked)
        public static let all: Self   = .init(options: .all)
        public static let quiet: Self = .init(options: .quiet)
        public static func message(_ msg: String) -> Self { .init(options: .message(msg)) }
        public static func pathspecFromFile(_ file: String) -> Self { .init(options: .pathspecFromFile(file)) }
        public static let pathspecFileNul: Self = .init(options: .pathspecFileNul)
    }
    
    ///  --message=<msg>
    static func message(_ msg: String) -> Self { .init("--message=\(msg)") }
    ///  --all
    static let all: Self = "--all"
    ///  --include-untracked
    static let includeUntracked: Self = "--include-untracked"
    ///  --index
    static let index: Self = "--index"
    ///  --keep-index
    static let keepIndex: Self = "--keep-index"
    ///  --no-include-untracked
    static let noIncludeUntracked: Self = "--no-include-untracked"
    ///  --no-keep-index
    static let noKeepIndex: Self = "--no-keep-index"
    ///  --only-untracked
    static let onlyUntracked: Self = "--only-untracked"
    ///  --patch
    static let patch: Self = "--patch"
    ///  --pathspec-file-nul
    static let pathspecFileNul: Self = "--pathspec-file-nul"
    ///  --pathspec-from-file=<file>
    static func pathspecFromFile(_ file: String) -> Self { .init("--pathspec-from-file=\(file)") }
    ///  --quiet
    static let quiet: Self = "--quiet"
    ///  --staged
    static let staged: Self = "--staged"
    
}
