//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation
import Combine

/// https://git-scm.com/docs/git-show
public extension Repository {
    
    func showPublisher(commit ID: String) -> AnyPublisher<ShowCommitResult, GitError> {
        showPublisher([.pretty(.fuller)], objects: [ID])
            .map(formatter(string:))
            .eraseToAnyPublisher()
    }
    
    func showPublisher(_ options: [ShowOptions] = [], objects: [String] = []) -> AnyPublisher<String, GitError> {
        runPublisher(["show"] + options.map(\.rawValue) + objects)
    }
    
    func showPublisher(_ options: [ShowOptions] = [], objects: [String] = []) -> AnyPublisher<Data, GitError> {
        dataPublisher(["show"] + options.map(\.rawValue) + objects)
    }
    
    func showPublisher(_ cmd: String) -> AnyPublisher<String, GitError> {
        runPublisher(["show"] + cmd.split(separator: " ").map(\.description))
    }
    
    func showPublisher(data cmd: String) -> AnyPublisher<Data, GitError> {
        dataPublisher("show " + cmd)
    }
    
}

/// https://git-scm.com/docs/git-show
public extension Repository {
    
    @discardableResult
    func show(commit ID: String) async throws -> ShowCommitResult {
        formatter(string: try await self.show([.pretty(.fuller)], objects: [ID]))
    }
    
    @discardableResult
    func show(_ options: [ShowOptions] = [], objects: [String] = []) async throws -> String {
        try await run(["show"] + options.map(\.rawValue) + objects)
    }
    
    @discardableResult
    func show(data options: [ShowOptions] = [], objects: [String] = []) async throws -> Data {
        try await data(["show"] + options.map(\.rawValue) + objects)
    }
    
    @discardableResult
    func show(_ cmd: String) async throws -> String {
        try await run(["show"] + cmd.split(separator: " ").map(\.description))
    }
    
    @discardableResult
    func show(data cmd: String) async throws -> Data {
        try await data("show " + cmd)
    }
    
}

/// https://git-scm.com/docs/git-show
public extension Repository {
    
    @discardableResult
    func show(commit ID: String) throws -> ShowCommitResult {
        formatter(string: try self.show([.pretty(.fuller)], objects: [ID]))
    }
    
    @discardableResult
    func show(_ options: [ShowOptions] = [], objects: [String] = []) throws -> String {
        try run(["show"] + options.map(\.rawValue) + objects)
    }
    
    @discardableResult
    func show(data options: [ShowOptions] = [], objects: [String] = []) throws -> Data {
        try data(["show"] + options.map(\.rawValue) + objects)
    }
    
    @discardableResult
    func show(_ cmd: String) throws -> String {
        try run(["show"] + cmd.split(separator: " ").map(\.description))
    }
    
    @discardableResult
    func show(data cmd: String) throws -> Data {
        try data("show " + cmd)
    }
    
}

public extension Repository {
    
    struct ShowCommitResult: Equatable, Codable {
        public var ID: String
        public var message: String = ""
        
        public var author: UserRecord = .init()
        public var commit: UserRecord = .init()
        
        public var hash: String { ID }
        
        public var items = [ShowCommitResultItem]()
    }
    
    struct ShowCommitResultItem: Equatable, Codable {
        
        public struct Diff: Equatable, Codable {
            public var a: String = ""
            public var b: String = ""
        }
        
        public struct Index: Equatable, Codable {
            public var from: String = ""
            public var to: String = ""
            // var mode: String
        }
        
        public enum Action: Equatable, Codable {
            case deleted(mode: Int)
            case new(mode: Int)
            case old(mode: Int)
            case file(mode: Int)
            case copyFrom(String)
            case copyTo(String)
            case renameFrom(String)
            case renameTo(String)
            case similarity(Double)
            case dissimilarity(Double)
            case index(Index)
            
            public var type: ActionType {
                switch self {
                case .deleted:       return .deleted
                case .new:           return .new
                case .old:           return .old
                case .file:          return .file
                case .copyFrom:      return .copyFrom
                case .copyTo:        return .copyTo
                case .renameFrom:    return .renameFrom
                case .renameTo:      return .renameTo
                case .similarity:    return .similarity
                case .dissimilarity: return .dissimilarity
                case .index:         return .index
                    
                }
            }
        }
        
        public enum ActionType: Int, Equatable, Codable {
            case deleted
            case new
            case old
            case file
            case copyFrom
            case copyTo
            case renameFrom
            case renameTo
            case similarity
            case dissimilarity
            case index
        }
        
        public var diff = Diff()
        public var actions: [Action] = []
    }
    
}

extension Repository {
    
    func hasPrefixAndReturn(_ item: String, prefix: String) -> String? {
        guard item.hasPrefix(prefix) else {
            return nil
        }
        
        return item
            .dropFirst(prefix.count)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func formatter(string: String) -> ShowCommitResult {
        
        var commit = ShowCommitResult(ID: "")
        var record: ShowCommitResultItem? = nil
        
        for item in string.split(separator: "\n").map({ String($0) }) {
            if let item = hasPrefixAndReturn(item, prefix: "commit") {
                let ID = item.prefix(40)
                commit.ID = String(ID)
            }
            else if let item = hasPrefixAndReturn(item, prefix: "Author:") {
                let list = item
                    .replacingOccurrences(of: ">", with: "")
                    .split(separator: "<")
                    .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                commit.author.user.name = list.first ?? ""
                commit.author.user.email = list.last ?? ""
            }
            else if let item = hasPrefixAndReturn(item, prefix: "AuthorDate:") {
                commit.author.set(date: item)
            }
            else if let item = hasPrefixAndReturn(item, prefix: "Commit:") {
                let list = item
                    .replacingOccurrences(of: ">", with: "")
                    .split(separator: "<")
                    .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                commit.commit.user.name = list.first ?? ""
                commit.commit.user.email = list.last ?? ""
            }
            else if let item = hasPrefixAndReturn(item, prefix: "CommitDate:") {
                commit.commit.set(date: item)
            }
            else if item.hasPrefix("---") || item.hasPrefix("+++") {
                if let record = record {
                    commit.items.append(record)
                }
                record = nil
            }
            else if let item = hasPrefixAndReturn(item, prefix: "diff --git") {
                if let record = record {
                    commit.items.append(record)
                }
                record = .init()
                let diff = item
                    .split(separator: " ")
                if let a = diff.first?.dropFirst(2) {
                    record?.diff.a = String(a)
                }
                if let b = diff.last?.dropFirst(2) {
                    record?.diff.b = String(b)
                }
            }
            else if let item = hasPrefixAndReturn(item, prefix: "deleted file mode") {
                if let mode = Int(item, radix: 8) {
                    record?.actions.append(.deleted(mode: mode))
                }
            }
            else if let item = hasPrefixAndReturn(item, prefix: "new file mode") {
                if let mode = Int(item, radix: 8) {
                    record?.actions.append(.new(mode: mode))
                }
            }
            else if let item = hasPrefixAndReturn(item, prefix: "old file mode") {
                if let mode = Int(item, radix: 8) {
                    record?.actions.append(.old(mode: mode))
                }
            }
            else if let item = hasPrefixAndReturn(item, prefix: "file mode") {
                if let mode = Int(item, radix: 8) {
                    record?.actions.append(.file(mode: mode))
                }
            }
            else if let item = hasPrefixAndReturn(item, prefix: "index") {
                let index = item
                    .components(separatedBy: "..")
                
                if let from = index.first, let to = index.last {
                    record?.actions.append(.index(.init(from: String(from), to: String(to))))
                }
            }
            else if let item = hasPrefixAndReturn(item, prefix: "similarity index") {
                let index = item
                    .replacingOccurrences(of: "%", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                if let number = Double(index) {
                    record?.actions.append(.similarity(number / 100))
                }
            }
            else if let item = hasPrefixAndReturn(item, prefix: "dissimilarity index") {
                let index = item
                    .replacingOccurrences(of: "%", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                if let number = Double(index) {
                    record?.actions.append(.similarity(number / 100))
                }
            }
            else if let item = hasPrefixAndReturn(item, prefix: "rename from") {
                record?.actions.append(.renameFrom(item))
            }
            else if let item = hasPrefixAndReturn(item, prefix: "rename to") {
                record?.actions.append(.renameTo(item))
            }
            else if let item = hasPrefixAndReturn(item, prefix: "copy from") {
                record?.actions.append(.copyFrom(item))
            }
            else if let item = hasPrefixAndReturn(item, prefix: "copy to") {
                record?.actions.append(.copyTo(item))
            }
            else if commit.items.isEmpty, record == nil {
                var item = item
                if !commit.message.isEmpty {
                    commit.message.append("\n")
                } else {
                    item = item.trimmingCharacters(in: .whitespaces)
                }
                commit.message.append(item)
            }
        }
        
        if let item = record {
            commit.items.append(item)
        }
        
        return commit
    }
    
}

public extension ShowOptions {
    
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
    
    
    static func pretty(_ format: Format) -> ShowOptions { .init("--pretty=\(format)") }
    static func format(_ format: Format) -> ShowOptions { .init("--format=\(format)") }
    static func limit(_ number: Int) -> ShowOptions { .init("-\(number)") }
    
}
