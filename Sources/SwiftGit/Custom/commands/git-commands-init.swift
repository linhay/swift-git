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
        try run(options.map(\.rawValue) + [directory], executable: .`init`)
    }
    
}


public extension InitOptions {
    
    static let defaultTemplate = template(Git.Resource.templates.url.absoluteString)

}
