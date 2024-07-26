import Foundation

/// Logger Queue to log in other queue
public protocol LoggerQueue: Sendable {
    /// Schedules a block for asynchronous execution on a dispatch queue and optionally associates it with a dispatch group.
    ///
    /// - Parameters:
    ///   - group: The dispatch group to associate with the submitted block. If `nil`, the block will not be associated with a group. Use a dispatch group to synchronize work among multiple queues.
    ///   - qos: The quality of service class for the block. This determines the priority of the block. Valid values are:
    ///     - `.userInteractive`: The highest priority, for tasks that must complete immediately to ensure a smooth user experience.
    ///     - `.userInitiated`: For tasks initiated by the user and requiring immediate results.
    ///     - `.default`: The default quality of service.
    ///     - `.utility`: For tasks that perform work in the background and don’t require immediate results.
    ///     - `.background`: For tasks that are not time-sensitive and can run when the system is idle.
    ///   - flags: Options that control the execution of the work item. For example:
    ///     - `.barrier`: The block is a barrier block, which prevents other blocks from executing until it is finished.
    ///     - `.detached`: The block can be executed independently of the current execution context.
    ///   - execute: The block of code to execute asynchronously. This block is marked with `@escaping` to indicate that it can outlive the lifetime of the current function and with `@Sendable` to ensure it is safe to be called from multiple threads concurrently.
    ///
    /// - Discussion:
    ///   This function submits the block for asynchronous execution on the specified dispatch queue, with the given quality of service and flags. If a dispatch group is provided, the block will be associated with the group, and the group’s count will be incremented. Once the block completes, the group’s count will be decremented.
    ///
    ///   Use this method to perform work asynchronously without blocking the current thread. By specifying a quality of service, you can influence the priority of the block relative to other system resources. The dispatch flags provide additional control over how the block is executed.
    ///
    /// - Example Usage:
    ///   ```swift
    ///   let queue = DispatchQueue.global(qos: .background)
    ///   let group = DispatchGroup()
    ///
    ///   queue.async(group: group, qos: .background, flags: []) {
    ///       // Perform some asynchronous work here
    ///       print("Work is done!")
    ///   }
    ///
    ///   group.notify(queue: DispatchQueue.main) {
    ///       print("All work is complete.")
    ///   }
    ///   ```
    ///
    /// - Note:
    ///   Ensure that the block is thread-safe, especially if it modifies shared resources. Use appropriate synchronization mechanisms to avoid race conditions.
    func async(
        group: DispatchGroup?,
        qos: DispatchQoS,
        flags: DispatchWorkItemFlags,
        execute work: @escaping @Sendable @convention(block) () -> Void
    )
}

extension DispatchQueue: LoggerQueue, @unchecked Sendable {
    func async(
        execute work: @escaping @Sendable @convention(block) () -> Void
    ) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}
