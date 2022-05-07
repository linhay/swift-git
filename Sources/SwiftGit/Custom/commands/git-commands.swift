//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import Foundation

extension Git {
    
    static var version: String {
        get throws {
            return try Git.run([.version])
                .split(separator: " ")
                .last!
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    static var help: String {
        get throws {
            return try Git.run([.help])
        }
    }
    
}
