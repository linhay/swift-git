//
//  File.swift
//  
//
//  Created by linhey on 2022/5/12.
//

import Foundation

public struct GitError: LocalizedError {
    
    let message: String
    public var errorDescription: String? { message }
    
}
