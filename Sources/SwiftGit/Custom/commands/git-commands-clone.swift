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
                        directory: String) -> AnyPublisher<Repository, Error> {
        if FileManager.default.fileExists(atPath: directory) {
            return Future<Repository, Error> { promise in
                promise(.failure(GitError.existsDirectory(directory)))
            }.eraseToAnyPublisher()
        }
        
        do {
            let url = try self.repository(url: repository, credentials: credentials)
            return runPublisher(["clone"] + (options.map(\.rawValue) + [url, directory]))
                .tryMap { _ in
                    Repository(git: self, path: directory)
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
            return Future<Repository, Error> { promise in
                promise(.failure(error))
            }.eraseToAnyPublisher()
        } catch {
            return Future<Repository, Error> { promise in
                promise(.failure(GitError.other(error)))
            }.eraseToAnyPublisher()
        }
    }
    
    func clonePublisher(_ options: [CloneOptions],
                        repository: URL,
                        credentials: GitCredentials = .default,
                        workDirectoryURL: URL) -> AnyPublisher<Repository, Error> {
        let last = repository.lastPathComponent
        if last.isEmpty {
            return Future<Repository, Error> { promise in
                promise(.failure(GitError.parser("invalid repository url")))
            }.eraseToAnyPublisher()
        }
        let directory = workDirectoryURL.appendingPathComponent(last)
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
        return Repository(git: self, path: directory)
    }
    
    @discardableResult
    func clone(_ options: [CloneOptions],
               repository: URL,
               credentials: GitCredentials = .default,
               workDirectoryURL: URL) async throws -> Repository {
        let last = repository.lastPathComponent
        guard !last.isEmpty else { throw GitError.parser("invalid repository url") }
        let directory = workDirectoryURL.appendingPathComponent(last)
        try await clone(options, repository: repository, credentials: credentials, directory: directory.path)
        return Repository(git: self, url: directory)
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
        return Repository(git: self, path: directory)
    }
    
    @discardableResult
    func clone(_ options: [CloneOptions],
               repository: URL,
               credentials: GitCredentials = .default,
               workDirectoryURL: URL) throws -> Repository {
        let last = repository.lastPathComponent
        guard !last.isEmpty else { throw GitError.parser("invalid repository url") }
        let directory = workDirectoryURL.appendingPathComponent(last)
        try clone(options, repository: repository, credentials: credentials, directory: directory.path)
        return Repository(git: self, url: directory)
    }
    
    
}

extension Git {
    
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
