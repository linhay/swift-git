//
//  File.swift
//  
//
//  Created by linhey on 2022/5/10.
//

import Foundation

public extension Repository {

    @discardableResult
    func add(_ options: [AddOptions], paths: [String]) throws -> String {
        try Git.run(["add"] + options.map(\.rawValue) + ["--"] + paths,
                    currentDirectoryURL: localURL)
    }
    
}
