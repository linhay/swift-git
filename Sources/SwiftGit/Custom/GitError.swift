//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation

public enum GitError: Error, LocalizedError {
    
    case unableLoadEmbeddGitInstance
    case unableLoadCustomGitInstance
    case noGitInstanceFoundOnSystem
    case existsDirectory(String)
    case processFatal(String)
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .unableLoadEmbeddGitInstance:
            return "Unable to load the embedd git instance"
        case .unableLoadCustomGitInstance:
            return "Unable to load the custom git instance"
        case .noGitInstanceFoundOnSystem:
            return "no git instance found on the system"
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
        case .noGitInstanceFoundOnSystem:
            return 101
        case .unableLoadEmbeddGitInstance:
            return 102
        case .unableLoadCustomGitInstance:
            return 103
        case .existsDirectory:
            return 401
        case .processFatal:
            return 402
        case .unknown:
            return 403
        }
    }
    
}
