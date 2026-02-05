//
//  File.swift
//  
//
//  Created by linhey on 2022/5/16.
//

import Foundation
import Combine

public extension Repository {
    
    /// https://git-scm.com/docs/git-pull
    func pullPublisher(_ options: [PullOptions] = [], refspecs: [Reference]) -> AnyPublisher<String, Error> {
        runPublisher(["pull"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    func pullPublisher(_ options: [PullOptions] = []) -> AnyPublisher<String, Error> {
        runPublisher(["pull"] + options.map(\.rawValue))
    }
    
    func pullPublisher(_ cmd: String) -> AnyPublisher<String, Error> {
        runPublisher("pull " + cmd)
    }
    
}

public extension Repository {
    
    /// https://git-scm.com/docs/git-pull
    @discardableResult
    func pull(_ options: [PullOptions] = [], refspecs: [Reference]) async throws -> String {
        try await run(["pull"] + options.map(\.rawValue) + refspecs.map(\.name))
    }

    /// https://git-scm.com/docs/git-pull
    /// Pull updates with progress reporting.
    @discardableResult
    func pull(
        _ options: [PullOptions] = [],
        refspecs: [Reference],
        progress: @escaping @Sendable (GitProgress) -> Void
    ) async throws -> String {
        try await pull(
            options,
            refspecs: refspecs,
            progress: { value in
                progress(value)
                return .proceed
            }
        )
    }

    /// https://git-scm.com/docs/git-pull
    /// Pull updates with progress reporting that can request cancellation.
    @discardableResult
    func pull(
        _ options: [PullOptions] = [],
        refspecs: [Reference],
        progress: @escaping @Sendable (GitProgress) -> GitProgressAction
    ) async throws -> String {
        let progressOptions = pullOptionsWithProgress(options)
        return try await git.runWithProgress(
            ["pull"] + progressOptions.map(\.rawValue) + refspecs.map(\.name),
            context: .init(at: localURL),
            progress: progress
        )
    }
    
    @discardableResult
    func pull(_ options: [PullOptions] = []) async throws -> String {
        try await run(["pull"] + options.map(\.rawValue))
    }

    /// Pull updates with progress reporting.
    @discardableResult
    func pull(
        _ options: [PullOptions] = [],
        progress: @escaping @Sendable (GitProgress) -> Void
    ) async throws -> String {
        try await pull(
            options,
            progress: { value in
                progress(value)
                return .proceed
            }
        )
    }

    /// Pull updates with progress reporting that can request cancellation.
    @discardableResult
    func pull(
        _ options: [PullOptions] = [],
        progress: @escaping @Sendable (GitProgress) -> GitProgressAction
    ) async throws -> String {
        let progressOptions = pullOptionsWithProgress(options)
        return try await git.runWithProgress(
            ["pull"] + progressOptions.map(\.rawValue),
            context: .init(at: localURL),
            progress: progress
        )
    }
    
    @discardableResult
    func pull(_ cmd: String) async throws -> String {
        try await run("pull " + cmd)
    }
    
}

public extension Repository {
    
    /// https://git-scm.com/docs/git-pull
    @discardableResult
    func pull(_ options: [PullOptions] = [], refspecs: [Reference]) throws -> String {
        try run(["pull"] + options.map(\.rawValue) + refspecs.map(\.name))
    }
    
    @discardableResult
    func pull(_ options: [PullOptions] = []) throws -> String {
        try run(["pull"] + options.map(\.rawValue))
    }
    
    @discardableResult
    func pull(_ cmd: String) throws -> String {
        try run("pull " + cmd)
    }
    
}

private func pullOptionsWithProgress(_ options: [PullOptions]) -> [PullOptions] {
    if options.contains(where: { $0.rawValue == PullOptions.progress.rawValue }) {
        return options
    }
    return options + [.progress]
}
