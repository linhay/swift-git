//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation
import Cgit2

public class Git {
    
    public static let shared = Git()
    
    let pointer = git_libgit2_init()
    
    deinit {
        git_libgit2_shutdown()
    }
    
}
