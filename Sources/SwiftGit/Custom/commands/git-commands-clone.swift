//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import Foundation

public extension Git {
    
    @discardableResult
    static func clone(_ options: [CloneOptions] = [], repository: String, directory: String) throws -> Repository {
        try run((options.map(\.rawValue) + [repository, directory]),
                executable: .clone)
        return try Repository(path: directory)
    }

    @discardableResult
    static func clone(_ options: CloneOptions..., repository: String, directory: String) throws -> Repository {
        try clone(options, repository: repository, directory: directory)
    }
    
}

public extension CloneOptions {
    
    static let defaultTemplate = template(Git.bundle.bundlePath + "/share/git-core/templates")

    /// use IPv4 addresses only
    static let ipv4: CloneOptions = "--ipv4"
    /// use IPv6 addresses only
    static let ipv6: CloneOptions = "--ipv6"

}
