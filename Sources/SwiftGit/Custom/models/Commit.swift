//
//  File.swift
//  
//
//  Created by linhey on 2022/5/11.
//

import Foundation


public enum Commit {
    
    public enum Mnemonics {
        /// ~<n>
        case tilde(Int)
        /// ^<n>
        case caret(Int)
        
        public var name: String {
            switch self {
            case .tilde(let int):
                return "~\(int)"
            case .caret(let int):
                return "^\(int)"
            }
        }
    }
    
    case head([Mnemonics] = [])
    
    public var name: String {
        switch self {
        case .head(let array):
            return "HEAD\(array.map(\.name).joined())"
        }
    }
    
}
