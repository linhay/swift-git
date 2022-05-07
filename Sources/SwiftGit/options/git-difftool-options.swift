public struct DifftoolOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension DifftoolOptions {

    ///  --dir-diff
static let dirDiff: Self = "--dir-diff"
    ///  --extcmd=<command>
    static func extcmd(_ command: String) -> Self { .init("--extcmd=\(command)") }
    ///  --gui
static let gui: Self = "--gui"
    ///  --no-gui
static let noGui: Self = "--no-gui"
    ///  --no-prompt
static let noPrompt: Self = "--no-prompt"
    ///  --no-symlinks
static let noSymlinks: Self = "--no-symlinks"
    ///  --no-trust-exit-code
static let noTrustExitCode: Self = "--no-trust-exit-code"
    ///  --prompt
static let prompt: Self = "--prompt"
    ///  --rotate-to=<file>
    static func rotateTo(_ file: String) -> Self { .init("--rotate-to=\(file)") }
    ///  --skip-to=<file>
    static func skipTo(_ file: String) -> Self { .init("--skip-to=\(file)") }
    ///  --symlinks
static let symlinks: Self = "--symlinks"
    ///  --tool-help
static let toolHelp: Self = "--tool-help"
    ///  --tool=<tool>
    static func tool(_ tool: String) -> Self { .init("--tool=\(tool)") }
    ///  --trust-exit-code
static let trustExitCode: Self = "--trust-exit-code"

}