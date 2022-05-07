//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import Foundation

public extension Git {
    
    @discardableResult
    static func `init`(_ options: InitOptions..., directory: String) throws -> String {
        try self.`init`(options, directory: directory)
    }
    
    @discardableResult
    static func `init`(_ options: [InitOptions] = [], directory: String) throws -> String {
        try run(["init"] + options.map(\.rawValue) + [directory])
    }
    
}


public extension InitOptions {
    
    static let defaultTemplate = template(Git.bundle.bundlePath + "/share/git-core/templates")
    
}
