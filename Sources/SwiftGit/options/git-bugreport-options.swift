public struct BugreportOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension BugreportOptions {

    ///  --output-directory <path>
    static func outputDirectory(_ path: String) -> Self { .init("--output-directory \(path)") }
    ///  --suffix <format>
    static func suffix(_ format: String) -> Self { .init("--suffix \(format)") }

}