//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import Foundation

extension Git {
    
    var version: String {
        get async throws {
            let items = try await run([.version]).split(separator: " ").filter({ !$0.isEmpty })
            guard let index = items.firstIndex(where: { $0 == "version" }) else {
                return ""
            }
            return String(items[index + 1]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    var help: String {
        get async throws {
            return try await run([.help])
        }
    }
    
}
