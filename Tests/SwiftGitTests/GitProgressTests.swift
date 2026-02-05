//
//  GitProgressTests.swift
//  SwiftGit
//
//  Created by linhey on 2026/2/5.
//

import Foundation

import Testing

@testable import SwiftGit

final class ProgressCollector: @unchecked Sendable {
    private let lock = NSLock()
    private var values: [GitProgress] = []

    func append(_ value: GitProgress) {
        lock.lock()
        values.append(value)
        lock.unlock()
    }

    func snapshot() -> [GitProgress] {
        lock.lock()
        defer { lock.unlock() }
        return values
    }
}

struct GitProgressParserTests {

    @Test func test_parse_network_progress() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Receiving objects:  42% (42/100), 1.23 MiB | 1.23 MiB/s\n"
        parser.handle(Data(line.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        let value = values[0]
        #expect(value.stage == .network)
        #expect(value.receivedObjects == 42)
        #expect(value.totalObjects == 100)
        #expect(value.indexedObjects == 0)
        let expectedBytes = Int64(1.23 * 1_024 * 1_024)
        let delta = value.receivedBytes - expectedBytes
        #expect(abs(delta) <= 1)
    }

    @Test func test_parse_indexing_progress() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Resolving deltas:  10% (10/100)\n"
        parser.handle(Data(line.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        let value = values[0]
        #expect(value.stage == .indexing)
        #expect(value.indexedObjects == 10)
        #expect(value.totalObjects == 100)
    }

    @Test func test_parse_checkout_progress() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Checking out files:  50% (5/10)\n"
        parser.handle(Data(line.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        let value = values[0]
        #expect(value.stage == .checkout)
        #expect(value.receivedObjects == 5)
        #expect(value.totalObjects == 10)
    }

    @Test func test_monotonic_progress_ignores_decrease() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let first = "Receiving objects:  10% (10/100), 10 KiB | 10 KiB/s\n"
        let second = "Receiving objects:   5% (5/100), 5 KiB | 5 KiB/s\n"
        parser.handle(Data(first.utf8))
        parser.handle(Data(second.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        #expect(values[0].receivedObjects == 10)
        #expect(values[0].totalObjects == 100)
    }

    @Test func test_cancel_requested_from_callback() {
        let parser = GitProgressParser { _ in
            return .cancel
        }

        let line = "Receiving objects:   1% (1/100), 1 KiB | 1 KiB/s\n"
        parser.handle(Data(line.utf8))

        #expect(parser.isCancelRequested == true)
    }

    @Test func test_parse_updating_files_progress() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Updating files:  20% (2/10)\n"
        parser.handle(Data(line.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        let value = values[0]
        #expect(value.stage == .checkout)
        #expect(value.receivedObjects == 2)
        #expect(value.totalObjects == 10)
    }

    @Test func test_handle_multiple_lines_single_chunk() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let chunk = "Receiving objects:  10% (10/100), 10 KiB | 10 KiB/s\n"
            + "Resolving deltas:  20% (20/100)\n"
        parser.handle(Data(chunk.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 2)
        #expect(values.first?.stage == .network)
        #expect(values.last?.stage == .indexing)
    }

    @Test func test_handle_partial_line_buffering() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let partial = "Receiving objects:  1% (1/100)"
        parser.handle(Data(partial.utf8))
        #expect(snapshots.snapshot().isEmpty)

        let remainder = ", 1 KiB | 1 KiB/s\n"
        parser.handle(Data(remainder.utf8))
        #expect(snapshots.snapshot().count == 1)
    }

    @Test func test_handle_carriage_returns() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let chunk = "Receiving objects:  1% (1/100), 1 KiB | 1 KiB/s\rResolving deltas:  2% (2/100)\r"
        parser.handle(Data(chunk.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 2)
        #expect(values.first?.stage == .network)
        #expect(values.last?.stage == .indexing)
    }

    @Test func test_stage_change_emits_even_without_counts() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let network = "Receiving objects:  10% (10/100), 1 KiB | 1 KiB/s\n"
        let indexing = "Resolving deltas:  0%\n"
        parser.handle(Data(network.utf8))
        parser.handle(Data(indexing.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 2)
        #expect(values[0].stage == .network)
        #expect(values[1].stage == .indexing)
    }

    @Test func test_finish_emits_done_stage() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Receiving objects:  50% (50/100), 1 KiB | 1 KiB/s\n"
        parser.handle(Data(line.utf8))
        parser.finish()

        let values = snapshots.snapshot()
        #expect(values.count == 2)
        let done = values.last
        #expect(done?.stage == .done)
        #expect(done?.stagePercent == 1.0)
    }

    @Test func test_finish_without_progress_emits_done() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        parser.finish()

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        #expect(values[0].stage == .done)
    }

    @Test func test_parse_bytes_in_bytes_unit() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Receiving objects:  5% (5/100), 512 B | 1 B/s\n"
        parser.handle(Data(line.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        #expect(values[0].receivedBytes == 512)
    }

    @Test func test_parse_bytes_in_bytes_word_unit() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Receiving objects:  5% (5/100), 12 bytes | 1 bytes/s\n"
        parser.handle(Data(line.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        #expect(values[0].receivedBytes == 12)
    }

    @Test func test_unknown_lines_are_ignored() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "remote: Counting objects: 10% (1/10)\n"
        parser.handle(Data(line.utf8))

        #expect(snapshots.snapshot().isEmpty)
    }

    @Test func test_counts_without_bytes_emits_snapshot() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Receiving objects: 100% (10/10)\n"
        parser.handle(Data(line.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        #expect(values[0].receivedObjects == 10)
        #expect(values[0].totalObjects == 10)
        #expect(values[0].receivedBytes == 0)
    }

    @Test func test_invalid_counts_do_not_emit_new_snapshot() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let valid = "Receiving objects:  1% (1/100), 1 KiB | 1 KiB/s\n"
        let invalid = "Receiving objects:  1% (n/a)\n"
        parser.handle(Data(valid.utf8))
        parser.handle(Data(invalid.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
    }

    @Test func test_parse_bytes_in_mb_unit() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Receiving objects:  5% (5/100), 1.5 MB | 1 MB/s\n"
        parser.handle(Data(line.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        let expected = Int64(1.5 * 1_000_000)
        let delta = values[0].receivedBytes - expected
        #expect(abs(delta) <= 1)
    }

    @Test func test_stage_percent_network() {
        let progress = GitProgress(
            receivedObjects: 25,
            totalObjects: 50,
            indexedObjects: 0,
            receivedBytes: 0,
            stage: .network
        )
        let percent = progress.stagePercent ?? 0
        #expect(abs(percent - 0.5) < 0.0001)
    }

    @Test func test_stage_percent_indexing_uses_indexed_objects() {
        let progress = GitProgress(
            receivedObjects: 5,
            totalObjects: 10,
            indexedObjects: 7,
            receivedBytes: 0,
            stage: .indexing
        )
        let percent = progress.stagePercent ?? 0
        #expect(abs(percent - 0.7) < 0.0001)
    }

    @Test func test_stage_percent_checkout_uses_received_objects() {
        let progress = GitProgress(
            receivedObjects: 3,
            totalObjects: 12,
            indexedObjects: 0,
            receivedBytes: 0,
            stage: .checkout
        )
        let percent = progress.stagePercent ?? 0
        #expect(abs(percent - 0.25) < 0.0001)
    }

    @Test func test_stage_percent_done_is_one() {
        let progress = GitProgress(
            receivedObjects: 0,
            totalObjects: 1,
            indexedObjects: 0,
            receivedBytes: 0,
            stage: .done
        )
        #expect(progress.stagePercent == 1.0)
    }

    @Test func test_stage_percent_nil_when_total_zero() {
        let progress = GitProgress(
            receivedObjects: 0,
            totalObjects: 0,
            indexedObjects: 0,
            receivedBytes: 0,
            stage: .network
        )
        #expect(progress.stagePercent == nil)
    }

    @Test func test_duplicate_line_does_not_emit() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Receiving objects:  10% (10/100), 10 KiB | 10 KiB/s\n"
        parser.handle(Data(line.utf8))
        parser.handle(Data(line.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
    }

    @Test func test_monotonic_indexing_ignores_decrease() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let first = "Resolving deltas:  10% (10/100)\n"
        let second = "Resolving deltas:   5% (5/100)\n"
        parser.handle(Data(first.utf8))
        parser.handle(Data(second.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        #expect(values[0].indexedObjects == 10)
    }

    @Test func test_received_bytes_increase_emits_snapshot() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let first = "Receiving objects:  10% (10/100), 1 KiB | 1 KiB/s\n"
        let second = "Receiving objects:  10% (10/100), 2 KiB | 1 KiB/s\n"
        parser.handle(Data(first.utf8))
        parser.handle(Data(second.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 2)
        #expect(values[1].receivedBytes > values[0].receivedBytes)
    }

    @Test func test_received_bytes_decrease_is_ignored() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let first = "Receiving objects:  10% (10/100), 10 KiB | 1 KiB/s\n"
        let second = "Receiving objects:  10% (10/100), 9 KiB | 1 KiB/s\n"
        parser.handle(Data(first.utf8))
        parser.handle(Data(second.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        #expect(values[0].receivedBytes == 10 * 1024)
    }

    @Test func test_parse_bytes_in_kib_unit() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Receiving objects:  5% (5/100), 2 KiB | 1 KiB/s\n"
        parser.handle(Data(line.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        #expect(values[0].receivedBytes == 2_048)
    }

    @Test func test_parse_bytes_in_gb_unit() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Receiving objects:  5% (5/100), 1 GB | 1 GB/s\n"
        parser.handle(Data(line.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        #expect(values[0].receivedBytes == 1_000_000_000)
    }

    @Test func test_parse_bytes_in_tb_unit() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let line = "Receiving objects:  5% (5/100), 1 TB | 1 TB/s\n"
        parser.handle(Data(line.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
        #expect(values[0].receivedBytes == 1_000_000_000_000)
    }

    @Test func test_unknown_bytes_unit_does_not_emit() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let valid = "Receiving objects:  5% (5/100), 1 KiB | 1 KiB/s\n"
        let invalid = "Receiving objects:  5% (5/100), 1 XB | 1 XB/s\n"
        parser.handle(Data(valid.utf8))
        parser.handle(Data(invalid.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
    }

    @Test func test_missing_counts_does_not_emit() {
        let snapshots = ProgressCollector()
        let parser = GitProgressParser { progress in
            snapshots.append(progress)
            return .proceed
        }

        let valid = "Receiving objects:  5% (5/100), 1 KiB | 1 KiB/s\n"
        let missing = "Receiving objects:  5%\n"
        parser.handle(Data(valid.utf8))
        parser.handle(Data(missing.utf8))

        let values = snapshots.snapshot()
        #expect(values.count == 1)
    }

}
