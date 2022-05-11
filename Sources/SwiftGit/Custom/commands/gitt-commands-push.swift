//
//  File.swift
//  
//
//  Created by linhey on 2022/5/11.
//

import Foundation

public extension Repository {

    func push(_ options: [PushOptions], refs: [Reference]) throws {
        try Git.run(["push"]
                    + options.map(\.rawValue)
                    + refs.map(\.name),
                    currentDirectoryURL: localURL)
    }
    
}
