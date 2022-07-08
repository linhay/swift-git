//
//  File.swift
//  
//
//  Created by linhey on 2022/5/8.
//

import Foundation
import Combine

public extension Git {
    
    func clonePublisher(_ options: [CloneOptions],
                        repository: URL,
                        credentials: GitCredentials = .default,
                        directory: String) -> AnyPublisher<Repository, GitError> {
        if FileManager.default.fileExists(atPath: directory) {
            return Future<Repository, GitError> { promise in
                promise(.failure(GitError.existsDirectory(directory)))
            }.eraseToAnyPublisher()
        }
        
        do {
            let url = try self.repository(url: repository, credentials: credentials)
            return runPublisher(["clone"] + (options.map(\.rawValue) + [url, directory]))
                .tryMap { _ in
                    try Repository(path: directory, environment: self.environment)
                }
                .mapError({ error in
                    if let gitError = error as? GitError {
                        return gitError
                    } else {
                        return GitError.other(error)
                    }
                })
                .eraseToAnyPublisher()
        } catch let error as GitError {
            return Future<Repository, GitError> { promise in
                promise(.failure(error))
            }.eraseToAnyPublisher()
        } catch {
            return Future<Repository, GitError> { promise in
                promise(.failure(.other(error)))
            }.eraseToAnyPublisher()
        }
    }
    
    func clonePublisher(_ options: [CloneOptions],
                        repository: URL,
                        credentials: GitCredentials = .default,
                        workDirectoryURL: URL) -> AnyPublisher<Repository, GitError> {
        let directory = workDirectoryURL.appendingPathComponent(repository.pathComponents.last!)
        return clonePublisher(options, repository: repository, credentials: credentials, directory: directory.path)
    }
    
}

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
        return Repository(url: directory, environment: environment)
    }
    
}

public extension Git {
    
    @discardableResult
    func clone(_ options: [CloneOptions],
               repository: URL,
               credentials: GitCredentials = .default,
               directory: String) throws -> Repository {
        if FileManager.default.fileExists(atPath: directory) {
            throw GitError.existsDirectory(directory)
        }
        try run(["clone"] + (options.map(\.rawValue) + [self.repository(url: repository, credentials: credentials), directory]))
        return try Repository(path: directory, environment: environment)
    }
    
    @discardableResult
    func clone(_ options: [CloneOptions],
               repository: URL,
               credentials: GitCredentials = .default,
               workDirectoryURL: URL) throws -> Repository {
        let directory = workDirectoryURL.appendingPathComponent(repository.pathComponents.last!)
        try clone(options, repository: repository, credentials: credentials, directory: directory.path)
        return Repository(url: directory, environment: environment)
    }
    
    
}

private extension Git {
    
    func repository(url: URL, credentials: GitCredentials) throws -> String {
        var repository = url
        switch credentials {
        case .default:
            break
        case .plaintext(let username, let password):
            guard var components = URLComponents(url: repository, resolvingAgainstBaseURL: true) else {
                throw GitError.parser(nil)
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
