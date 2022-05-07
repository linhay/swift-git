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


public extension CloneOptions {
    
    /// use IPv4 addresses only
    static let ipv4: CloneOptions = "--ipv4"
    /// use IPv6 addresses only
    static let ipv6: CloneOptions = "--ipv6"

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
