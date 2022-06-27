//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import Foundation

public extension Git {
    
    @discardableResult
    func `init`(_ options: [InitOptions] = [], directory: String) throws -> String {
        try run(["init"] + options.map(\.rawValue) + [directory])
    }
    
}
