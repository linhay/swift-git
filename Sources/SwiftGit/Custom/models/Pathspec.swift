//
//  File.swift
//  
//
//  Created by linhey on 2022/5/11.
//

import Foundation

public struct Pathspec: ExpressibleByStringLiteral {
    
    public static let all: Pathspec = "."
    
    public let value: String
    
    public init(stringLiteral value: StringLiteralType) {
        self.value = value
    }
    
    public init(_ value: StringLiteralType) {
        self.value = value
    }
    
}

public extension Array where Element == Pathspec {
    
    static let all: [Pathspec] = ["."]
    
}

