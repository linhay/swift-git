//
//  File.swift
//  
//
//  Created by linhey on 2022/5/2.
//

import Foundation

public extension Repository {

    func diff(options: [DiffOptions] = [], commands: [String]) throws -> String {
        return try run(["diff"] + options.map(\.rawValue) + commands)
    }
    
}


public extension DiffOptions {
    
    /// Enable the heuristic that shifts diff hunk boundaries to make patches easier to read. This is the default.
    static func indentHeuristic(_ flag: Bool) -> DiffOptions { .init(stringLiteral: flag ? "--indent-heuristic" : "--no-indent-heuristic") }

    
    /// Generate patch (see section on generating patches). This is the default.
    /// Suppress diff output. Useful for commands like git show that show the patch by default, or to cancel the effect of --patch.
    static func patch(_ flag: Bool) -> DiffOptions { .init(stringLiteral: flag ? "--patch" : "--no-patch") }

    /// Generate diffs with <n> lines of context instead of the usual three. Implies --patch.
    static func unified(_ n: Int) -> DiffOptions { .init(stringLiteral: "--unified=\(n)") }
 
    enum OutputIndicator: String {
        case new
        case old
        case context
    }
    
    /// Specify the character used to indicate new, old or context lines in the generated patch. Normally they are +, - and ' ' respectively.
    static func outputIndicator(_ char: String, for: OutputIndicator) -> DiffOptions {
        .init(stringLiteral: "--output-indicator-\(`for`.rawValue)=\(char)")
    }
    
    enum DiffAlgorithm: String {
        case `default`
        case myers
        case minimal
        case patience
        case histogram
    }
    
    /**
     Choose a diff algorithm. The variants are as follows:

     - myers, default: The basic greedy diff algorithm. Currently, this is the default.
     - minimal: Spend extra time to make sure the smallest possible diff is produced.
     - patience: Use "patience diff" algorithm when generating patches.
     - histogram: This algorithm extends the patience algorithm to "support low-occurrence common elements".

     For instance, if you configured the diff.algorithm variable to a non-default value and want to use the default one, then you have to use --diff-algorithm=default option.
    */
    static func diffAlgorithm(_ algorithm: DiffAlgorithm) -> DiffOptions {
        .init(stringLiteral: "--diff-algorithm=\(algorithm.rawValue)")
    }
        
}
