//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import Foundation

extension Git {
    
    func version() async throws -> String {
        let items = try await run([.version]).split(separator: " ").filter({ !$0.isEmpty })
        guard let index = items.firstIndex(where: { $0 == "version" }) else {
            return ""
        }
        return String(items[index + 1]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func help() async throws -> String {
        return try await run([.help])
    }
    
}

extension Git {
    
    func version() throws -> String {
        let items = try run([.version]).split(separator: " ").filter({ !$0.isEmpty })
        guard let index = items.firstIndex(where: { $0 == "version" }) else {
            return ""
        }
        return String(items[index + 1]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func help() throws -> String {
        return try run([.help])
    }
    
}

