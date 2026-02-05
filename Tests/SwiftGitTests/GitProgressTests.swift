//
//  GitProgressTests.swift
//  SwiftGit
//
//  Created by linhey on 2026/2/5.
//

import Foundation

import Testing

@testable import SwiftGit

struct GitProgressParserTests {

    @Test func test_parse_network_progress() {
        var snapshots: [GitProgress] = []
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Receiving objects:  42% (42/100), 1.23 MiB | 1.23 MiB/s\n"
        parser.handle(Data(line.utf8))

        #expect(snapshots.count == 1)
        let value = snapshots[0]
        #expect(value.stage == .network)
        #expect(value.receivedObjects == 42)
        #expect(value.totalObjects == 100)
        #expect(value.indexedObjects == 0)
        let expectedBytes = Int64(1.23 * 1_024 * 1_024)
        let delta = value.receivedBytes - expectedBytes
        #expect(abs(delta) <= 1)
    }

    @Test func test_parse_indexing_progress() {
        var snapshots: [GitProgress] = []
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Resolving deltas:  10% (10/100)\n"
        parser.handle(Data(line.utf8))

        #expect(snapshots.count == 1)
        let value = snapshots[0]
        #expect(value.stage == .indexing)
        #expect(value.indexedObjects == 10)
        #expect(value.totalObjects == 100)
    }

    @Test func test_parse_checkout_progress() {
        var snapshots: [GitProgress] = []
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Checking out files:  50% (5/10)\n"
        parser.handle(Data(line.utf8))

        #expect(snapshots.count == 1)
        let value = snapshots[0]
        #expect(value.stage == .checkout)
        #expect(value.receivedObjects == 5)
        #expect(value.totalObjects == 10)
    }

    @Test func test_monotonic_progress_ignores_decrease() {
        var snapshots: [GitProgress] = []
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let first = "Receiving objects:  10% (10/100), 10 KiB | 10 KiB/s\n"
        let second = "Receiving objects:   5% (5/100), 5 KiB | 5 KiB/s\n"
        parser.handle(Data(first.utf8))
        parser.handle(Data(second.utf8))

        #expect(snapshots.count == 1)
        #expect(snapshots[0].receivedObjects == 10)
        #expect(snapshots[0].totalObjects == 100)
    }

    @Test func test_cancel_requested_from_callback() {
        let parser = GitProgressParser { _ in
            return .cancel
        }

        let line = "Receiving objects:   1% (1/100), 1 KiB | 1 KiB/s\n"
        parser.handle(Data(line.utf8))

        #expect(parser.isCancelRequested == true)
    }

}
