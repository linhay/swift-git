//
//  File.swift
//  
//
//  Created by linhey on 2022/7/13.
//

import Foundation

public extension Repository {
    
    struct User: Equatable, Codable {
        public var name: String = ""
        public var email: String = ""
    }
    
    struct UserRecord: Equatable, Codable {
        public var user: User = .init()
        public var date: Date = .init()
        
        public init() {}
        
        static private let formatter: DateFormatter = {
            let item = DateFormatter()
            item.locale = Locale(identifier: "en_US_POSIX")
            item.dateFormat = "EEE MMM dd HH:mm:ss yyyy Z"
            return item
        }()
        
        public mutating func set(date string: String) {
            if let date = Self.formatter.date(from: string) {
                self.date = date
            } else {
                fatalError("Date string format error: \(string)")
            }
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

public extension Repository {
    
    func logResults(from string: String) -> [LogResult] {
        string
            .split(separator: "\n")
            .reduce([LogResult](), { result, item in
                let item = String(item)
                var result = result
                if let item = hasPrefixAndReturn(item, prefix: "commit") {
                    let ID = String(item.prefix(40))
                    result.append(LogResult(id: ID))
                    return result
                }
                else if var old = result.last {
                    if let item = hasPrefixAndReturn(item, prefix: "Author:") {
                        let list = item
                            .replacingOccurrences(of: ">", with: "")
                            .split(separator: "<")
                            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                        old.author.user.name = list.first ?? ""
                        old.author.user.email = list.last ?? ""
                    }
                    else if let item = hasPrefixAndReturn(item, prefix: "Commit:") {
                        let list = item
                            .replacingOccurrences(of: ">", with: "")
                            .split(separator: "<")
                            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                        old.commit.user.name = list.first ?? ""
                        old.commit.user.email = list.last ?? ""
                    }
                    else if let item = hasPrefixAndReturn(item, prefix: "AuthorDate:") {
                        old.author.set(date: item)
                    }
                    else if let item = hasPrefixAndReturn(item, prefix: "CommitDate:") {
                        old.commit.set(date: item)
                    }
                    else if old.message.isEmpty == false {
                        old.message.append("\n")
                        old.message.append(String(item))
                    }
                    else if item.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                        old.message.append(item.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                    result[result.count - 1] = old
                }
                return result
            })
    }
    
}
