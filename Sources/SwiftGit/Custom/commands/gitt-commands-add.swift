//
//  File.swift
//  
//
//  Created by linhey on 2022/5/10.
//

import Foundation


public extension Repository {

    func add(_ options: [AddOptions], paths: [String]) throws {
        try Git.run(["add"] + options.map(\.rawValue) + ["--"] + paths,
                    currentDirectoryURL: localURL)
    }
    
}
