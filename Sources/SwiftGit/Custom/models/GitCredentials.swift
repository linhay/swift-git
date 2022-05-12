//
//  File.swift
//  
//
//  Created by linhey on 2022/5/13.
//

import Foundation

public enum GitCredentials {
    case `default`
    case plaintext(username: String, password: String)
}
