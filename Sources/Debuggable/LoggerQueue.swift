import Foundation

public protocol LoggerQueue: Sendable {
    func async(group: DispatchGroup?, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute work: @escaping @Sendable @convention(block) () -> Void)
}

extension DispatchQueue: LoggerQueue {
    func async(execute work: @escaping @Sendable @convention(block) () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}
