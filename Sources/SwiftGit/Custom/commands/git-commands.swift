//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import Foundation
import Combine

extension Git {
    
    func versionPublisher() -> AnyPublisher<String, Error> {
        runPublisher([.version])
            .map(formatter(version:))
            .eraseToAnyPublisher()
    }
    
    func helpPublisher() -> AnyPublisher<String, Error> {
        return runPublisher([.help])
    }
    
}

extension Git {
    
    func version() async throws -> String {
        return formatter(version: try await run([.version]))
    }
    
    func help() async throws -> String {
        return try await run([.help])
    }
    
}

extension Git {
    
    func version() throws -> String {
        return formatter(version: try run([.version]))
    }
    
    func help() throws -> String {
        return try run([.help])
    }
    
}

private extension Git {

    func formatter(version: String) -> String {
        let items = version.split(separator: " ").filter({ !$0.isEmpty })
        guard let index = items.firstIndex(where: { $0 == "version" }) else {
            return ""
        }
        return String(items[index + 1]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

