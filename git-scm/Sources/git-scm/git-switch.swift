public struct SwitchOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension SwitchOptions {

    ///  --create <new-branch>
    static func create(newBranch: String) -> Self { .init("--create \(newBranch)") }
    ///  --detach
static let detach: Self = "--detach"
    ///  --force-create <new-branch>
    static func forceCreate(newBranch: String) -> Self { .init("--force-create \(newBranch)") }

}