//
//  File.swift
//  
//
//  Created by linhey on 2022/5/10.
//

import Foundation

public extension Repository {
    
    @discardableResult
    func add(_ options: [AddOptions], paths: [String]) async throws -> String {
        try await run(["add"] + options.map(\.rawValue) + ["--"] + paths)
    }
    
}
