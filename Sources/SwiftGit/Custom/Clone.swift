// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

public struct CloneOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
}

public extension CloneOptions {
    
    /// be more verbose
    static let verbose: CloneOptions = "--verbose"
    /// be more quiet
    static let quiet: CloneOptions = "--quiet"
    /// force progress reporting
    static let progress: CloneOptions = "--progress"
    /// don't clone shallow repository
    static let rejectShallow: CloneOptions = "--reject-shallow"
    /// don't create a checkout
    static let noCheckout: CloneOptions = "--no-checkout"
    /// create a bare repository
    static let bare: CloneOptions = "--bare"
    /// create a mirror repository (implies bare)
    static let mirror: CloneOptions = "--mirror"
    /// to clone from a local repository
    static let local: CloneOptions = "--local"
    /// don't use local hardlinks, always copy
    static let noHardlinks: CloneOptions = "--no-hardlinks"
    /// setup as shared repository
    static let shared: CloneOptions = "--shared"
    /// use --reference only while cloning
    static let dissociate: CloneOptions = "--dissociate"
    /// clone only one branch, HEAD or --branch
    static let singleBranch: CloneOptions = "--single-branch"
    /// don't clone any tags, and make later fetches not to follow them
    static let noTags: CloneOptions = "--no-tags"
    /// any cloned submodules will be shallow
    static let shallowSubmodules: CloneOptions = "--shallow-submodules"
    /// use IPv4 addresses only
    static let ipv4: CloneOptions = "--ipv4"
    /// use IPv6 addresses only
    static let ipv6: CloneOptions = "--ipv6"
    /// any cloned submodules will use their remote-tracking branch
    static let remoteSubmodules: CloneOptions = "--remote-submodules"
    /// initialize sparse-checkout file to include only files at root
    static let sparse: CloneOptions = "--sparse"
    
    /// checkout <branch> instead of the remote's HEAD
    static func branch(_ branch: String) -> CloneOptions { .init(stringLiteral: "--branch \(branch)") }
    
    //    /// initialize submodules in the clone
    //    static func recurseSubmodules(_ pathspec: String) -> CloneOptions { .init(stringLiteral: "--recurse-submodules=\(pathspec)") }
    //    /// number of submodules cloned in parallel
    //    static func jobs(_ value: Int) -> CloneOptions { .init(stringLiteral: "--jobs \(value)") }
    //    /// directory from which templates will be used
    //    static func template(_ value: String) -> CloneOptions { .init(stringLiteral: "--template \(value)") }
    //    /// reference repository
    //    static func reference(_ value: String) -> CloneOptions { .init(stringLiteral: "--reference \(value)") }
    //    /// reference repository
    //    static func referenceIfAble(_ value: String) -> CloneOptions { .init(stringLiteral: "--reference-if-able \(value)") }
    //    /// use <name> instead of 'origin' to track upstream
    //    static func origin(_ name: String) -> CloneOptions { .init(stringLiteral: "--origin \(name)") }
    //    /// path to git-upload-pack on the remote
    //    static func uploadPack(_ value: String) -> CloneOptions { .init(stringLiteral: "--upload-pack \(value)") }
    //    /// create a shallow clone of that depth
    //    static func depth(_ value: String) -> CloneOptions { .init(stringLiteral: "--depth \(value)") }
    //    /// create a shallow clone since a specific time
    //    static func shallowSince(_ value: String) -> CloneOptions { .init(stringLiteral: "--shallow-since \(value)") }
    //    /// deepen history of shallow clone, excluding rev
    //    static func shallowExclude(_ value: String) -> CloneOptions { .init(stringLiteral: "--shallow-exclude \(value)") }
    //    /// separate git dir from working tree
    //    static func separateGitDir(_ value: String) -> CloneOptions { .init(stringLiteral: "--separate-git-dir \(value)") }
    //    /// set config inside the new repository
    //    static func config(_ value: String) -> CloneOptions { .init(stringLiteral: "--config \(value)") }
    //    /// option to transmit
    //    static func serverOption(_ value: String) -> CloneOptions { .init(stringLiteral: "--server-option \(value)") }
    //    /// object filtering
    //    static func filter(_ value: String) -> CloneOptions { .init(stringLiteral: "--filter \(value)") }
    
}

// MARK: - clone https://git-scm.com/docs/git-clone
public extension Git {
    
    @discardableResult
    static func clone(repo: String, dir path: String, options: [CloneOptions] = []) throws -> Repository {
        try Git.run((["clone"] + options.map(\.rawValue) + [repo, path]))
        return try Repository(path: path)
    }
    
    @discardableResult
    static func clone(repo: String, parentFolder path: String, options: [CloneOptions] = []) throws -> Repository {
        try Git.run((["clone"] + options.map(\.rawValue) + [repo]), processBuilder: { process in
            process.currentDirectoryURL = .init(fileURLWithPath: path)
        })
        return try Repository(path: path)
    }
    
}
