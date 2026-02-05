//
//  GitProgress.swift
//
//
//  Created by linhey on 2026/2/5.
//

/// Progress snapshot for long-running Git operations like clone and pull.
public struct GitProgress: Sendable {

    /// Number of received objects for network progress. During checkout, this reflects
    /// the checkout item count (files) for the current stage.
    public let receivedObjects: Int
    /// Total objects/items for the current stage when known.
    public let totalObjects: Int
    /// Number of indexed objects during the indexing stage.
    public let indexedObjects: Int
    /// Total received bytes (best effort; may be zero when not reported).
    public let receivedBytes: Int64
    /// Current progress stage.
    public let stage: GitProgressStage

    public init(
        receivedObjects: Int,
        totalObjects: Int,
        indexedObjects: Int,
        receivedBytes: Int64,
        stage: GitProgressStage
    ) {
        self.receivedObjects = receivedObjects
        self.totalObjects = totalObjects
        self.indexedObjects = indexedObjects
        self.receivedBytes = receivedBytes
        self.stage = stage
    }

    /// Percent complete for the current stage when total is available.
    /// This value is stage-specific and resets when the stage changes.
    public var stagePercent: Double? {
        guard totalObjects > 0 else { return nil }
        switch stage {
        case .network, .checkout:
            return Double(receivedObjects) / Double(totalObjects)
        case .indexing:
            return Double(indexedObjects) / Double(totalObjects)
        case .done:
            return 1.0
        }
    }
}

/// High-level progress stage reported by Git.
public enum GitProgressStage: Sendable {
    case network
    case indexing
    case checkout
    case done
}

/// Progress callback decision. Returning `.cancel` requests cancellation of the operation.
/// The operation throws `CancellationError` when cancellation is honored.
public enum GitProgressAction: Sendable {
    case proceed
    case cancel
}
