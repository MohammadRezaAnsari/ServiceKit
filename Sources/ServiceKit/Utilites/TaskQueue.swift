//
//  TaskQueue.swift
//
//
//  Created by Mohammad Reza Ansary on 12/22/1402 AP.
//

import Foundation

public actor TaskQueue {
    private let concurrency: Int
    private var running: Int = 0
    private var queue: [CheckedContinuation<Void, Error>] = []
    private var suspended = false

    public init(concurrency: Int) {
        self.concurrency = concurrency
    }

    public func suspend() {
        Task {
            await self.modifySuspend(true)
        }
    }

    public func resume() {
        Task {
            await self.modifySuspend(false)
        }
    }

    private func modifySuspend(_ value: Bool) async {
        suspended = value
        tryRunEnqueued()
    }

    deinit {
        for continuation in queue {
            continuation.resume(throwing: CancellationError())
        }
    }

    public func enqueue<T>(operation: @escaping @Sendable () async throws -> T) async throws -> T {
        try Task.checkCancellation()

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            queue.append(continuation)
            tryRunEnqueued()
        }

        defer {
            running -= 1
            tryRunEnqueued()
        }

        try Task.checkCancellation()

        // Wait until not suspended
        while suspended {
            // 5 minute for timeout
            try await Task.sleep(nanoseconds: 300 * 1_000_000_000)
        }

        return try await operation()
    }

    private func tryRunEnqueued() {
        guard !queue.isEmpty else { return }
        guard running < concurrency && !suspended else { return }

        running += 1
        let continuation = queue.removeFirst()
        continuation.resume()
    }
}
