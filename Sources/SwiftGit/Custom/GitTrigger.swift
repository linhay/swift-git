//
//  File.swift
//  
//
//  Created by linhey on 2022/6/24.
//

import Foundation

public struct GitTrigger {
    
    public enum Event: Int {
        case beforeRun
        case afterRun
    }
    
    public struct Content {
        public let commands: [String]
        public let data: Data
    }
    
    public struct Error: Swift.Error {
        public let commands: [String]
        public let message: String
    }
    
    public let event: Event
    public let action: (Result<Content, Error>) -> Void
    
    public init(on event: Event, action: @escaping (_ result: Result<Content, Error>) -> Void) {
        self.event = event
        self.action = action
    }
    
    
    public static func failure(on event: Event, action: @escaping (_ error: Error) -> Void) -> GitTrigger {
        .init(on: event) { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                action(error)
            }
        }
    }
    
    public static func success(on event: Event, action: @escaping (_ content: Content) -> Void) -> GitTrigger {
        .init(on: event) { result in
            switch result {
            case .success(let value):
                action(value)
            case .failure:
                break
            }
        }
    }
    
}
