#if os(macOS)
import Foundation
import Combine

@available(macOS 11, *)
public struct GitShell { }

@available(macOS 11, *)
public extension GitShell {
    
    struct Context {
        
        public var environment: [String: String]?
        public var currentDirectory: URL?
        
        public let standardOutput: PassthroughSubject<Data, Never>?
        public var standardError: PassthroughSubject<Data, Never>?
        
        internal init(environment: [String : String]? = nil,
                      at currentDirectory: URL? = nil,
                      standardOutput: PassthroughSubject<Data, Never>? = .init(),
                      standardError: PassthroughSubject<Data, Never>? = .init()) {
            self.environment = environment
            self.currentDirectory = currentDirectory
            self.standardOutput = standardOutput
            self.standardError = standardError
        }
    }

    
    class Standard {
        
        let pipe = Pipe()
        let semaphore: DispatchSemaphore?
        var isRunning = true
        let publisher: PassthroughSubject<Data, Never>?
        var availableData: Data?
        
        init(semaphore: DispatchSemaphore?, publisher: PassthroughSubject<Data, Never>?) {
            self.publisher = publisher
            self.semaphore = semaphore
        }
        
        func append(to standard: inout Any?, isRecordData: Bool) -> Self {
            availableData = isRecordData ? Data() : nil
            standard = pipe
            pipe.fileHandleForReading.readabilityHandler = { [weak self] fh in
                guard let self = self else { return }
                let data = fh.availableData
                if data.isEmpty {
                    self.pipe.fileHandleForReading.readabilityHandler = nil
                    self.isRunning = false
                    self.semaphore?.signal()
                } else {
                    self.availableData?.append(data)
                    self.publisher?.send(data)
                }
            }
            return self
        }
        
    }

    
}

public extension GitShell {
    
    @discardableResult
    static func zsh(_ command: String, context: Context? = nil) throws -> Data {
        try data(URL(fileURLWithPath: "/bin/zsh"), ["-c", command], context: context)
    }
    
    @discardableResult
    static func zsh(string command: String, context: Context? = nil) throws -> String? {
        let data = try zsh(command, context: context)
        return String.init(data: data, encoding: .utf8)
    }
    
    @discardableResult
    static func string(_ exec: URL, _ commands: [String], context: Context? = nil) throws -> String {
        let data = try data(exec, commands, context: context)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    @discardableResult
    static func data(_ exec: URL, _ commands: [String], context: Context? = nil) throws -> Data {
        let process = self.setupProcess(exec, commands, context: context)
        let semaphore = DispatchSemaphore(value: 1)
        let output = Standard(semaphore: semaphore, publisher: context?.standardOutput).append(to: &process.standardOutput, isRecordData: true)
        let error  = Standard(semaphore: semaphore, publisher: context?.standardError).append(to: &process.standardError, isRecordData: true)
        try process.run()
        process.waitUntilExit()
        semaphore.wait()
        return try result(process, output: output, error: error).get()
    }
    
}

public extension GitShell {

    @discardableResult
    static func zshPublisher(_ command: String, context: Context? = nil) -> AnyPublisher<Data, GitError> {
         dataPublisher(URL(fileURLWithPath: "/bin/zsh"), ["-c", command], context: context)
    }
    
    @discardableResult
    static func zshPublisher(string command: String, context: Context? = nil) -> AnyPublisher<String?, GitError> {
        return zshPublisher(command, context: context).map { String(data: $0, encoding: .utf8) }.eraseToAnyPublisher()
    }
 
    @discardableResult
    static func stringPublisher(_ exec: URL, _ commands: [String], context: Context? = nil) -> AnyPublisher<String?, GitError> {
        return dataPublisher(exec, commands, context: context).map { String(data: $0, encoding: .utf8) }.eraseToAnyPublisher()
    }
    
    @discardableResult
    static func dataPublisher(_ exec: URL, _ commands: [String], context: Context? = nil) -> AnyPublisher<Data, GitError> {
        Future<Data, GitError> { promise in
            do {
                promise(.success(try data(exec, commands, context: context)))
            } catch let error as GitError {
                promise(.failure(error))
            } catch {
                promise(.failure(.other(error)))
            }
        }.eraseToAnyPublisher()
    }

}

public extension GitShell {

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
                continuation.resume(with: .success(try data(exec, commands, context: context)))
            } catch let error as GitError {
                continuation.resume(throwing: error)
            } catch {
                continuation.resume(throwing: GitError.other(error))
            }
        }
    }

}

private extension GitShell {
    
    static func result(_ process: Process, output: Standard, error: Standard) -> Result<Data, GitError> {
        if process.terminationStatus != .zero {
            if let data = error.availableData, let message = String(data: data, encoding: .utf8) {
                return .failure(GitError.processFatal(message))
            }
            
            var message = [String]()
            if let currentDirectory = process.currentDirectoryURL?.path {
                message.append("currentDirectory: \(currentDirectory)")
            }
            message.append("reason: \(process.terminationReason)")
            message.append("code: \(process.terminationReason.rawValue)")
            return .failure(GitError.processFatal(message.joined(separator: "\n")))
        }
        return .success(output.availableData ?? Data())
    }
    
    static func setupProcess(_ exec: URL, _ commands: [String], context: Context? = nil) -> Process {
        let process = Process()
        process.executableURL = exec
        process.arguments = commands
        process.currentDirectoryURL = context?.currentDirectory
        
        if let environment = context?.environment, !environment.isEmpty {
            process.environment = environment
        }
        return process
    }
    
}

#endif

