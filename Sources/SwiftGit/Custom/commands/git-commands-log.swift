//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation
import Combine

/// https://git-scm.com/docs/git-log
public extension Repository {
    
    func logPublisher(options: [LogOptions] = []) -> AnyPublisher<[LogResult], GitError> {
        logPublisher(options + [.pretty(.fuller)])
            .map(formatter(string:))
            .eraseToAnyPublisher()
    }
    
    func logPublisher(_ options: [LogOptions] = [], refspecs: [Reference] = []) -> AnyPublisher<String, GitError> {
        runPublisher(["log"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    func logPublisher(_ cmd: String) -> AnyPublisher<String, GitError> {
        runPublisher("log " + cmd)
    }
    
}

public extension Repository {
    
    func log(options: [LogOptions] = []) async throws -> [LogResult] {
        let str = try await log(options + [.pretty(.fuller)])
        return formatter(string: str)
    }
    
    /// https://git-scm.com/docs/git-log
    func log(_ options: [LogOptions] = [], refspecs: [Reference] = []) async throws -> String {
        try await run(["log"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func log(_ cmd: String) async throws -> String {
        try await run("log " + cmd)
    }
    
}

public extension Repository {
    
    func log(options: [LogOptions] = []) throws -> [LogResult] {
        let str = try log(options + [.pretty(.fuller)])
        return formatter(string: str)
    }
    
    /// https://git-scm.com/docs/git-log
    func log(_ options: [LogOptions] = [], refspecs: [Reference] = []) throws -> String {
        try run(["log"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func log(_ cmd: String) throws -> String {
        try run("log " + cmd)
    }
    
}

public extension Repository {
    
    struct User: Equatable, Codable {
        public var name: String = ""
        public var email: String = ""
    }
    
    struct UserRecord: Equatable, Codable {
        public var user: User = .init()
        public var date: Date = .init()
        
        static private let formatter: DateFormatter = {
            let item = DateFormatter()
            item.dateFormat = "EEE MMM dd HH:mm:ss yyyy Z"
            return item
        }()
        
        mutating func set(date string: String) {
            guard let date = Self.formatter.date(from: string) else {
                return
            }
            
            self.date = date
        }
        
    }
    
    struct LogResult: Equatable, Codable, Identifiable {
        public var id: String
        public var message: String = ""
        
        public var author: UserRecord = .init()
        public var commit: UserRecord = .init()
        
        public var hash: String { id }
    }
    
}

private extension Repository {
    
    func formatter(string: String) -> [LogResult] {
        string
            .split(separator: "\n")
            .reduce([LogResult](), { result, item in
                var result = result
                if item.hasPrefix("commit ") {
                    let ID = item.dropFirst("commit ".count)
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .prefix(40)
                    let new = LogResult(id: String(ID))
                    result.append(new)
                    return result
                } else if var old = result.last {
                    if item.hasPrefix("Author:") {
                        let list = item
                            .dropFirst("Author:".count)
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .replacingOccurrences(of: ">", with: "")
                            .split(separator: "<")
                            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                        old.author.user.name = list.first ?? ""
                        old.author.user.email = list.last ?? ""
                    } else if item.hasPrefix("Commit:") {
                        let list = item
                            .dropFirst("Commit:".count)
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .replacingOccurrences(of: ">", with: "")
                            .split(separator: "<")
                            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                        old.commit.user.name = list.first ?? ""
                        old.commit.user.email = list.last ?? ""
                    } else if item.hasPrefix("AuthorDate:") {
                        old.author.set(date: item.dropFirst("AuthorDate:".count).trimmingCharacters(in: .whitespacesAndNewlines))
                    } else if item.hasPrefix("CommitDate:") {
                        old.commit.set(date: item.dropFirst("CommitDate:".count).trimmingCharacters(in: .whitespacesAndNewlines))
                    } else if old.message.isEmpty == false {
                        old.message.append("\n")
                        old.message.append(String(item))
                    } else if item.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                        old.message.append(item.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                    result[result.count - 1] = old
                }
                return result
            })
    }
    
}

public extension LogOptions {
    
    enum Format {
        case oneline
        case short
        case medium
        case full
        case fuller
        case reference
        case email
        case raw
        case format(String)
        case tformat(String)
        
        var name: String {
            switch self {
            case .oneline:
                return "oneline"
            case .short:
                return "short"
            case .medium:
                return "medium"
            case .full:
                return "full"
            case .fuller:
                return "fuller"
            case .reference:
                return "reference"
            case .email:
                return "email"
            case .raw:
                return "raw"
            case .format(let string):
                return "format:\(string)"
            case .tformat(let string):
                return "tformat:\(string)"
            }
        }
    }
    
    
    static func pretty(_ format: Format) -> LogOptions { .init("--pretty=\(format)") }
    static func format(_ format: Format) -> LogOptions { .init("--format=\(format)") }
    static func limit(_ number: Int) -> LogOptions { .init("-\(number)") }
    
}
