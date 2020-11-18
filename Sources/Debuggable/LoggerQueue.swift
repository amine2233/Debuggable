import Foundation

public protocol LoggerQueue {
    func async(group: DispatchGroup?, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute work: @escaping @convention(block) () -> Void)
}

public extension LoggerQueue {
    func async(execute work: @escaping () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}

extension DispatchQueue: LoggerQueue {}
