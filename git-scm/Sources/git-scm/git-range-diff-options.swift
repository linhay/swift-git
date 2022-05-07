public struct RangeDiffOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension RangeDiffOptions {

    ///  --creation-factor=<percent>
    static func creationFactor(percent: String) -> Self { .init("--creation-factor=\(percent)") }
    ///  --left-only
static let leftOnly: Self = "--left-only"
    ///  --no-dual-color
static let noDualColor: Self = "--no-dual-color"
    ///  --no-notes[=<ref>]
    static func noNotes(ref: [String]) -> Self { .init("--no-notes=\(ref.joined(separator: ","))") }
    ///  --notes[=<ref>]
    static func notes(ref: [String]) -> Self { .init("--notes=\(ref.joined(separator: ","))") }
    ///  --right-only
static let rightOnly: Self = "--right-only"

}