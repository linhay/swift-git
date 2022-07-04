#if os(macOS)
import Foundation

@available(macOS 11, *)
public struct GitShell { }

@available(macOS 11, *)
public extension GitShell {
    
    struct Context {
        
        public var environment: [String: String]?
        public var currentDirectory: URL?
        
        public var standardOutput: ((String) -> Void)?
        public var standardError: ((String) -> Void)?
        
        public init(environment: [String : String]? = nil,
                    at currentDirectory: URL? = nil,
                    standardOutput: ((String) -> Void)? = nil,
                    standardError: ((String) -> Void)? = nil) {
            self.environment = environment
            self.currentDirectory = currentDirectory
            self.standardOutput = standardOutput
            self.standardError = standardError
        }
        
    }
    
    @discardableResult
    static func zsh(_ command: String, context: Context? = nil) async throws -> Data {
        try await data(URL(fileURLWithPath: "/bin/zsh"), ["-c", command], context: context)
    }
    
    @discardableResult
    static func zsh(string command: String, context: Context? = nil) async throws -> String? {
        let data = try await zsh(command, context: context)
        return String.init(data: data, encoding: .utf8)
    }
    
    @discardableResult
    static func string(_ exec: URL, _ commands: [String], context: Context? = nil) async throws -> String {
        let data = try await data(exec, commands, context: context)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    @discardableResult
    static func data(_ exec: URL, _ commands: [String], context: Context? = nil) async throws -> Data {
       try await withUnsafeThrowingContinuation { continuation in
           do {
               let process = Process()
               process.executableURL = exec
               process.arguments = commands
               process.currentDirectoryURL = context?.currentDirectory
               
               if let environment = context?.environment, !environment.isEmpty {
                   process.environment = environment
               }
               
               let outputPipe = pipe(for: &process.standardOutput, callback: context?.standardOutput)
               let errorPipe  = pipe(for: &process.standardError, callback: context?.standardError)
               
               process.terminationHandler = { process in
                   if process.terminationStatus != .zero {
                       if let message = String(data: errorPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) {
                           continuation.resume(throwing: GitError.processFatal(message))
                       }
                       
                       var message = [String]()
                       if let currentDirectory = process.currentDirectoryURL?.path {
                           message.append("currentDirectory: \(currentDirectory)")
                       }
                       message.append("reason: \(process.terminationReason)")
                       message.append("code: \(process.terminationReason.rawValue)")
                       continuation.resume(throwing: GitError.processFatal(message.joined(separator: "\n")))
                   }
                   
                   let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
                   continuation.resume(with: .success(data))
               }
               try process.run()
           } catch {
               continuation.resume(throwing: error)
           }
        }
    }
    
}


private extension GitShell {
    
    static func pipe(for standard: inout Any?, callback: ((String) -> Void)?) -> Pipe {
        let pipe = Pipe()
        standard = pipe
        guard let callback = callback else {
            return pipe
        }
        pipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            guard !handle.availableData.isEmpty,
                  let line = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !line.isEmpty else {
                return
            }
            callback(line)
        }
        return pipe
    }
    
}

#endif

