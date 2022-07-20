
/// A reference to a git object.
public protocol ReferenceType {
    var longName: String { get }
}

public extension ReferenceType {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.longName == rhs.longName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(longName)
    }
}


public enum Reference: ExpressibleByStringLiteral {
    
    case branch(Branch)
    case tag(Tag)
    case other(String)
    
    case head
    case fetchHead
    case origHead
    
    public init(stringLiteral string: String) {
        if string == "HEAD" {
            self = .head
        } else if string == "FETCH_HEAD" {
            self = .fetchHead
        } else if string == "ORIG_HEAD" {
            self = .origHead
        } else if let value = Branch(longName: string) {
            self = .branch(value)
        } else if let value = Tag(longName: string) {
            self = .tag(value)
        } else {
            self = .other(string)
        }
    }
    
    public var name: String {
        switch self {
        case .branch(let branch):
            return branch.longName
        case .tag(let tag):
            return tag.longName
        case .other(let string):
            return string
        case .head:
            return "HEAD"
        case .fetchHead:
            return "FETCH_HEAD"
        case .origHead:
            return "ORIG_HEAD"
        }
    }
    
}

/// A git branch.

public struct Branch: ReferenceType, Hashable {
    
    public enum State: String, CaseIterable {
        
        case local  = "refs/heads/"
        case remote = "refs/remotes/"
        
        public init?(rawValue: String) {
            if rawValue.hasPrefix(State.local.rawValue) {
                self = .local
            } else if rawValue.hasPrefix(State.remote.rawValue) {
                self = .remote
            } else {
                return nil
            }
        }
        
    }
    
    public let longName: String
    public let type: State
    
    public init?(longName: String) {
        guard let type = State.init(rawValue: longName) else {
            return nil
        }
        self.type = type
        self.longName = longName
    }
    
}

public struct Tag: ReferenceType, Hashable, ExpressibleByStringLiteral {
    
    static let prefix = "refs/tags/"
    
    public let longName: String
    public var commit: String?
    
    public var shortName: String { String(longName.dropFirst(Tag.prefix.count)) }
    
    public init?(longName: String, commit: String? = nil) {
        guard longName.hasPrefix(Tag.prefix) else {
            return nil
        }
        self.longName = longName
        self.commit = commit
    }
    
    public init(stringLiteral value: String) {
        self.longName = "\(Tag.prefix)\(value)"
    }
    
    public init(_ shortName: String) {
        self.longName = "\(Tag.prefix)\(shortName)"
    }
    
}
