public struct MergetoolOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension MergetoolOptions {
    
    ///  --gui
    static let gui: Self = "--gui"
    ///  --no-gui
    static let noGui: Self = "--no-gui"
    ///  --no-prompt
    static let noPrompt: Self = "--no-prompt"
    ///  --prompt
    static let prompt: Self = "--prompt"
    ///  --tool-help
    static let toolHelp: Self = "--tool-help"
    ///  --tool=<tool>
    static func tool(_ tool: String) -> Self { .init("--tool=\(tool)") }
    
}
