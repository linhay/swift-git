//
//  File.swift
//  
//
//  Created by linhey on 2022/7/13.
//

import Foundation

extension Repository {
    
    func hasPrefixAndReturn(_ item: String, prefix: String) -> String? {
        guard item.hasPrefix(prefix) else {
            return nil
        }
        
        return item
            .dropFirst(prefix.count)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
