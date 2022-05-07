//
//  File.swift
//  
//
//  Created by linhey on 2022/3/6.
//

import Foundation

struct VariableFormatter {
    
    /// 系统保留字
    let reservedWords = Set(["false", "true",
                             "class", "deinit", "enum", "extension", "func", "import",
                             "init", "let", "protocol", "static", "struct", "subscript", "typealias", "var",
                             "break", "case", "continue", "default", "do", "else", "fallthrough",
                             "if", "in", "for", "return", "switch", "where", "while",
                             "as", "is", "super", "self", "Self", "__COLUMN__", "__FILE__", "__FUNCTION__", "__LINE__",
                             "inout", "operator"])
    

    
    enum Style {
        /// 驼峰
        case camelCased
        /// 下划线
        case snakeCased
    }
    
    let style: Style
    /// 分割字符
    let splitChars: [String] = ["_", " ", "-"]
}

extension VariableFormatter {
    
    func firstUppercased(_ string: String) -> String {
        string.prefix(1).uppercased() + string.dropFirst()
    }
    
    func string(_ name: String) -> String {
        
        var result = ""
        switch self.style {
        case .camelCased:
            result = split(words: name)
                .enumerated()
                .map { $0.offset > 0 ? $0.element.capitalized : $0.element.lowercased() }
                .joined()
        case .snakeCased:
            result = split(words: name).joined(separator: "_")
        }
    
        if reservedWords.contains(result) {
            return "`\(result)`"
        }
        
        if result.first?.isNumber ?? false {
            return "_" + result
        }
        
        return result
    }
    
}

extension VariableFormatter {
    
    func split(words str: String) -> [String] {
        var words = [String]()
        var buffer = [String]()
        var bufferIsNumber = false
        
        for item in str {
            let char = String(item)
            
            if splitChars.contains(char) {
                words.append(buffer.joined())
                buffer.removeAll()
                continue
            }
            
            /// 切割非法字符
            guard item.isNumber || ("a"..."z").contains(item.lowercased()) else {
                words.append(buffer.joined())
                buffer.removeAll()
                continue
            }
            
            guard item.isLowercase else {
                words.append(buffer.joined())
                buffer.removeAll()
                buffer.append(char)
                continue
            }
            
            /// 切割数字/字母
            if buffer.isEmpty {
                bufferIsNumber = item.isNumber
            }
            
            if item.isNumber == bufferIsNumber {
                buffer.append(char)
            } else {
                words.append(buffer.joined())
                buffer.removeAll()
                buffer.append(char)
            }
        }
        
        words.append(buffer.joined())
        return words.filter({ $0.isEmpty == false }).map({ $0.lowercased() })
    }
    
}
