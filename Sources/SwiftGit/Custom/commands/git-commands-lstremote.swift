//
//  File.swift
//  
//
//  Created by linhey on 2022/7/20.
//

import Foundation
import Combine

public extension Git {
    
    func lsRemotePublisher(_ cmd: String) -> AnyPublisher<String, GitError> {
        runPublisher("ls-remote " + cmd)
    }
    
    @discardableResult
    func lsRemotePublisher(_ options: [LsRemoteOptions], repository: String, refs: [Reference]) throws -> String {
        try run(["ls-remote"] + options.map(\.rawValue) + [repository] + refs.map(\.name))
    }
    
}

public extension Git {
    
    @discardableResult
    func lsRemote(_ cmd: String) async throws -> String {
        try await run("ls-remote " + cmd)
    }
    
    @discardableResult
    func lsRemote(_ options: [LsRemoteOptions], repository: String, refs: [Reference]) async throws -> String {
        try await run(["ls-remote"] + options.map(\.rawValue) + [repository] + refs.map(\.name))
    }
    
}

public extension Git {
    
    @discardableResult
    func lsRemote(_ cmd: String) throws -> String {
        try run("ls-remote " + cmd)
    }
    
    @discardableResult
    func lsRemote(_ options: [LsRemoteOptions], repository: String, refs: [Reference]) throws -> String {
        try run(["ls-remote"] + options.map(\.rawValue) + [repository] + refs.map(\.name))
    }
    
}

public extension Repository {
    
    struct LsRemote {
        let repository: Repository
    }
    
    var lsRemote: LsRemote { .init(repository: self) }
    
}

public extension Repository.LsRemote {
    
    func url() async throws -> URL? {
        let str = try await repository.lsRemote([.getURL], refs: [])
        return .init(string: str)
    }
    
    func tags() async throws -> [Tag] {
        try await repository
            .lsRemote([.tags], refs: [])
            .split(separator: "\n")
            .compactMap { row in
                let items = row.split(separator: "\t").map({ String($0) })
                guard items.count == 2 else  {
                    return nil
                }
                return Tag(longName: items[1], commit: items[0])
            }
            .reversed()
    }
    
    
}

/// https://git-scm.com/docs/git-ls-remote
public extension Repository {
    
    func lsRemotePublisher(_ cmd: String) -> AnyPublisher<String, GitError> {
        runPublisher("ls-remote " + cmd)
    }
    
    @discardableResult
    func lsRemotePublisher(_ options: [LsRemoteOptions], refs: [Reference]) throws -> String {
        try run(["ls-remote"] + options.map(\.rawValue) + refs.map(\.name))
    }
    
}

public extension Repository {
    
    @discardableResult
    func lsRemote(_ cmd: String) async throws -> String {
        try await run("ls-remote " + cmd)
    }
    
    @discardableResult
    func lsRemote(_ options: [LsRemoteOptions], refs: [Reference]) async throws -> String {
        try await run(["ls-remote"] + options.map(\.rawValue) + refs.map(\.name))
    }
    
}

public extension Repository {
    
    @discardableResult
    func lsRemote(_ cmd: String) throws -> String {
        try run("ls-remote " + cmd)
    }
    
    @discardableResult
    func lsRemote(_ options: [LsRemoteOptions], refs: [Reference]) throws -> String {
        try run(["ls-remote"] + options.map(\.rawValue) + refs.map(\.name))
    }
    
}

public struct LsRemoteOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension LsRemoteOptions {
    
    /// Limit to only refs/heads and refs/tags, respectively. These options are not mutually exclusive; when given both, references stored in refs/heads and refs/tags are displayed. Note that used without anything else on the command line gives help, consistent with other git subcommands.
    static var heads: LsRemoteOptions { .init("--heads") }
    static var tags: LsRemoteOptions { .init("--tags") }
    /// Do not show peeled tags or pseudorefs like in the output
    static var refs: LsRemoteOptions { .init("--refs") }
    /// Do not print remote URL to stderr.
    static var quiet: LsRemoteOptions { .init("--quiet") }
    /// Exit with status "2" when no matching refs are found in the remote repository. Usually the command exits with status "0" to indicate it successfully talked with the remote repository, whether it found any matching refs.
    static var exitCode: LsRemoteOptions { .init("--exit-code") }
    /// Expand the URL of the given remote repository taking into account any "url.<base>.insteadOf" config setting (See git-config[1]) and exit without talking to the remote
    static var getURL: LsRemoteOptions { .init("--get-url") }
    /// In addition to the object pointed by it, show the underlying ref pointed by it when showing a symbolic ref. Currently, upload-pack only shows the symref HEAD, so it will be the only one shown by ls-remote.
    static var symref: LsRemoteOptions { .init("--symref") }
    /// Specify the full path of git-upload-pack on the remote host. This allows listing references from repositories accessed via SSH and where the SSH daemon does not use the PATH configured by the user.
    static func uploadPack(_ exec: String) -> LsRemoteOptions { .init("--upload-pack=\(exec)") }
    /// Sort based on the key given. Prefix to sort in descending order of the value. Supports "version:refname" or "v:refname" (tag names are treated as versions). The "version:refname" sort order can also be affected by the "versionsort.suffix" configuration variable. See git-for-each-ref[1] for more sort options, but be aware keys like that require access to the objects themselves will not work for refs whose objects have not yet been fetched from the remote, and will give a error
    static func sort(_ key: GitSortKey) -> LsRemoteOptions { .init("--sort=\(key.rawValue)") }
    /// Transmit the given string to the server when communicating using protocol version 2. The given string must not contain a NUL or LF character. When multiple are given, they are all sent to the other side in the order listed on the command line.--server-option=<option>
    static func serverOption(_ option: String) -> LsRemoteOptions { .init("--server-option=\(option)") }
    
}
