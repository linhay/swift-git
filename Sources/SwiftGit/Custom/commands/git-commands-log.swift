//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation

public extension Repository {
    
    struct User: Equatable {
        public var name: String = ""
        public var email: String = ""
    }
    
    struct UserRecord: Equatable {
        public var user: User = .init()
        public var date: String = .init()
    }
    
    struct LogResult: Equatable {
        public var ID: String
        public var message: String = ""
        
        public var author: UserRecord = .init()
        public var commit: UserRecord = .init()
        
        public var hash: String { ID }
    }
    
    private var executableURL: URL? { Git.bundle.url(forAuxiliaryExecutable: "libexec/git-core/git-log") }
    
    func log(options: [LogOptions] = []) throws -> [LogResult] {
        return try log(options + [.pretty(.fuller)])
            .split(separator: "\n")
            .reduce([LogResult](), { result, item in
                var result = result
                if item.hasPrefix("commit ") {
                    let ID = item.dropFirst("commit ".count)
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .prefix(40)
                    let new = LogResult(ID: String(ID))
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
                        old.author.date = item.dropFirst("AuthorDate:".count).trimmingCharacters(in: .whitespacesAndNewlines)
                    } else if item.hasPrefix("CommitDate:") {
                        old.commit.date = item.dropFirst("CommitDate:".count).trimmingCharacters(in: .whitespacesAndNewlines)
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
    
    /// https://git-scm.com/docs/git-log
    func log(_ options: [LogOptions] = [], refspecs: [Reference] = []) throws -> String {
        try run(options.map(\.rawValue) + refspecs.map(\.name), executable: .log)
    }
    
    @discardableResult
    func log(_ cmd: String) throws -> String {
        try run(cmd.split(separator: " ").map(\.description), executable: .log)
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
