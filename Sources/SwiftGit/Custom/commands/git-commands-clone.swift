//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import Foundation

public extension Git {
    
    @discardableResult
    func clone(_ options: [CloneOptions],
               repository: URL,
               credentials: GitCredentials = .default,
               directory: String) async throws -> Repository {
        if FileManager.default.fileExists(atPath: directory) {
            throw GitError.existsDirectory(directory)
        }
        try await run(["clone"] + (options.map(\.rawValue) + [self.repository(url: repository, credentials: credentials), directory]))
        return try Repository(path: directory, environment: environment)
    }
    
    @discardableResult
    func clone(_ options: [CloneOptions],
               repository: URL,
               credentials: GitCredentials = .default,
               workDirectoryURL: URL) async throws -> Repository {
        let directory = workDirectoryURL.appendingPathComponent(repository.pathComponents.last!)
        try await clone(options, repository: repository, credentials: credentials, directory: directory.path)
        return try Repository(url: directory, environment: environment)
    }
    
    private func repository(url: URL, credentials: GitCredentials) async throws -> String {
        var repository = url
        switch credentials {
        case .default:
            break
        case .plaintext(let username, let password):
            guard var components = URLComponents(url: repository, resolvingAgainstBaseURL: true) else {
                throw GitError.unknown
            }
            components.user = username
            components.password = password
            repository = components.url ?? repository
        }
        return repository.absoluteString
    }
    
}

public extension CloneOptions {
    
    static func depth(_ depth: Int) -> Self { .init("--depth=\(depth)") }
    
    /// use IPv4 addresses only
    static let ipv4: CloneOptions = "--ipv4"
    /// use IPv6 addresses only
    static let ipv6: CloneOptions = "--ipv6"
    
}
