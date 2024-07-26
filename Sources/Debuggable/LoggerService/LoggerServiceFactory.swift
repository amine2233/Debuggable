import Foundation

public enum LoggerServiceFactory {
    public static func build(
        name: String,
        enable: Bool = false,
        minLoggerLevel: LoggerLevel = .disable,
        queue: any LoggerQueue = DispatchQueue.global(),
        bundleIdentifier: String? = Bundle.main.bundleIdentifier
    ) -> any LoggerService {
        LoggerServiceDefault(
            name: name,
            enable: enable,
            minLoggerLevel: minLoggerLevel,
            queue: queue,
            bundleIdentifier: bundleIdentifier
        )
    }
}
