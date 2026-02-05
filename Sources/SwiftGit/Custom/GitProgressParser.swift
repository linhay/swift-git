//
//  GitProgressParser.swift
//
//
//  Created by linhey on 2026/2/5.
//

import Foundation

final class GitProgressParser {

    private struct State {
        var receivedObjects: Int = 0
        var totalObjects: Int = 0
        var indexedObjects: Int = 0
        var receivedBytes: Int64 = 0
        var stage: GitProgressStage = .network
    }

    private struct Snapshot: Equatable {
        let receivedObjects: Int
        let totalObjects: Int
        let indexedObjects: Int
        let receivedBytes: Int64
    }

    private let lock = NSLock()
    private var buffer = ""
    private var state = State()
    private var lastEmitted: [GitProgressStage: Snapshot] = [:]
    private let callbackQueue = DispatchQueue(label: "SwiftGit.GitProgress")
    private let progress: @Sendable (GitProgress) -> GitProgressAction
    private var cancelRequested = false

    init(progress: @escaping @Sendable (GitProgress) -> GitProgressAction) {
        self.progress = progress
    }

    func handle(_ data: Data) {
        guard let chunk = String(data: data, encoding: .utf8), !chunk.isEmpty else { return }
        lock.lock()
        buffer.append(chunk)
        buffer = buffer.replacingOccurrences(of: "\r", with: "\n")
        var lines = buffer.split(separator: "\n", omittingEmptySubsequences: false)
        if buffer.hasSuffix("\n") {
            buffer = ""
        } else if let last = lines.last {
            buffer = String(last)
            lines = lines.dropLast()
        }
        for line in lines {
            processLine(String(line))
        }
        lock.unlock()
    }

    func finish() {
        lock.lock()
        defer { lock.unlock() }
        state.stage = .done
        emit(stageChanged: true)
    }

    var isCancelRequested: Bool {
        lock.lock()
        defer { lock.unlock() }
        return cancelRequested
    }

    private func processLine(_ line: String) {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard let stage = stage(for: trimmed) else { return }

        let stageChanged = stage != state.stage
        state.stage = stage

        switch stage {
        case .network:
            if let counts = parseCounts(from: trimmed) {
                state.receivedObjects = counts.current
                state.totalObjects = counts.total
            }
            if let bytes = parseBytes(from: trimmed) {
                state.receivedBytes = bytes
            }
        case .indexing:
            if let counts = parseCounts(from: trimmed) {
                state.indexedObjects = counts.current
                state.totalObjects = counts.total
            }
        case .checkout:
            if let counts = parseCounts(from: trimmed) {
                state.receivedObjects = counts.current
                state.totalObjects = counts.total
            }
        case .done:
            break
        }

        emit(stageChanged: stageChanged)
    }

    private func emit(stageChanged: Bool) {
        let snapshot = Snapshot(
            receivedObjects: state.receivedObjects,
            totalObjects: state.totalObjects,
            indexedObjects: state.indexedObjects,
            receivedBytes: state.receivedBytes
        )

        if let last = lastEmitted[state.stage], !stageChanged {
            guard isMonotonic(snapshot, last: last, stage: state.stage) else { return }
            guard snapshot != last else { return }
        }

        lastEmitted[state.stage] = snapshot
        let value = GitProgress(
            receivedObjects: state.receivedObjects,
            totalObjects: state.totalObjects,
            indexedObjects: state.indexedObjects,
            receivedBytes: state.receivedBytes,
            stage: state.stage
        )
        let action = callbackQueue.sync { [progress] in
            progress(value)
        }
        if action == .cancel {
            cancelRequested = true
        }
    }

    private func isMonotonic(_ current: Snapshot, last: Snapshot, stage: GitProgressStage) -> Bool {
        switch stage {
        case .network:
            if current.receivedObjects < last.receivedObjects { return false }
            if current.totalObjects < last.totalObjects { return false }
            if current.receivedBytes < last.receivedBytes { return false }
            return true
        case .indexing:
            if current.indexedObjects < last.indexedObjects { return false }
            if current.totalObjects < last.totalObjects { return false }
            return true
        case .checkout:
            if current.receivedObjects < last.receivedObjects { return false }
            if current.totalObjects < last.totalObjects { return false }
            return true
        case .done:
            return true
        }
    }

    private func stage(for line: String) -> GitProgressStage? {
        if line.hasPrefix("Receiving objects:") {
            return .network
        }
        if line.hasPrefix("Resolving deltas:") {
            return .indexing
        }
        if line.hasPrefix("Checking out files:") || line.hasPrefix("Updating files:") {
            return .checkout
        }
        return nil
    }

    private func parseCounts(from line: String) -> (current: Int, total: Int)? {
        guard let openParen = line.firstIndex(of: "("),
              let closeParen = line[openParen...].firstIndex(of: ")") else { return nil }
        let inside = line[line.index(after: openParen)..<closeParen]
        let parts = inside.split(separator: "/")
        guard parts.count == 2,
              let current = parseInt(parts[0]),
              let total = parseInt(parts[1]) else { return nil }
        return (current, total)
    }

    private func parseBytes(from line: String) -> Int64? {
        guard let commaRange = line.range(of: ",") else { return nil }
        let afterComma = line[commaRange.upperBound...]
        guard let token = afterComma.split(separator: "|", maxSplits: 1, omittingEmptySubsequences: true)
            .first else { return nil }
        let trimmed = token.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = trimmed.split(separator: " ")
        guard parts.count >= 2,
              let value = parseDouble(parts[0]) else { return nil }
        let unit = parts[1].trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        let multiplier: Double
        switch unit {
        case "b", "byte", "bytes":
            multiplier = 1
        case "kb":
            multiplier = 1_000
        case "mb":
            multiplier = 1_000_000
        case "gb":
            multiplier = 1_000_000_000
        case "tb":
            multiplier = 1_000_000_000_000
        case "kib":
            multiplier = 1_024
        case "mib":
            multiplier = 1_024 * 1_024
        case "gib":
            multiplier = 1_024 * 1_024 * 1_024
        case "tib":
            multiplier = 1_024 * 1_024 * 1_024 * 1_024
        default:
            return nil
        }
        return Int64(value * multiplier)
    }

    private func parseInt(_ value: Substring) -> Int? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let digits = trimmed.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
        return Int(digits)
    }

    private func parseDouble(_ value: Substring) -> Double? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let allowed = CharacterSet(charactersIn: "0123456789.")
        let cleaned = trimmed.unicodeScalars.filter { allowed.contains($0) }
        return Double(String(String.UnicodeScalarView(cleaned)))
    }

}
