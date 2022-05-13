//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation

public enum GitError: Error, LocalizedError {
    
    case existsDirectory(String)
    case processFatal(String)
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .existsDirectory(let string):
            return "destination path '\(string)' already exists and is not an empty directory."
        case .processFatal(let string):
            return string
        case .unknown:
            return "unkonwn"
        }
    }
    
    public var code: Int {
        switch self {
        case .existsDirectory(let string):
            return 401
        case .processFatal(let string):
            return 402
        case .unknown:
            return 403
        }
    }
    
}
