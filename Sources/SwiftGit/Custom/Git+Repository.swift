//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

import Foundation

public extension Git {
    
    class Repo {
        /// Clone the repository from a given URL.
        ///
        /// remoteURL        - The URL of the remote repository
        /// localURL         - The URL to clone the remote repository into
        /// localClone       - Will not bypass the git-aware transport, even if remote is local.
        /// bare             - Clone remote as a bare repository.
        /// credentials      - Credentials to be used when connecting to the remote.
        /// checkoutStrategy - The checkout strategy to use, if being checked out.
        /// checkoutProgress - A block that's called with the progress of the checkout.
        ///
        /// Returns a `Result` with a `Repository` or an error.
        public class func clone(from remoteURL: URL,
                                to localURL: URL,
                                localClone: Bool = false,
                                bare: Bool = false,
                                credentials: Credentials = .default,
                                checkoutStrategy: CheckoutStrategy = .Safe,
                                checkoutProgress: CheckoutProgressBlock? = nil) async throws -> Repository {
            try await withUnsafeThrowingContinuation { continuation in
                let result = Repository.clone(from: remoteURL,
                                              to: localURL,
                                              localClone: localClone,
                                              bare: bare,
                                              credentials: credentials,
                                              checkoutStrategy: checkoutStrategy,
                                              checkoutProgress: checkoutProgress)
                switch result {
                case .success(let repo):
                    continuation.resume(returning: repo)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    var repository: Repository.Type { Repository.self }
    var repo: Repo.Type { Repo.self }
    
}
