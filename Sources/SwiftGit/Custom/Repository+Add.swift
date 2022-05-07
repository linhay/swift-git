//
//  File.swift
//  
//
//  Created by linhey on 2022/5/2.
//

import Foundation

public extension Repository {
    
    func add(options: [AddOptions] = [], _ paths: [String]) throws {
        try run(["add"] + options.map(\.rawValue) + paths)
    }
    
    func add(options: [AddOptions] = [], _ paths: String...) throws {
        try add(options: options, paths)
    }
    
}
