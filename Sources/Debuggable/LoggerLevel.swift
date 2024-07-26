import Foundation

public struct LoggerColorConfiguration: Sendable, CustomStringConvertible {

    public var description: String

    let disable: @Sendable (String) -> String
    let debug: @Sendable (String) -> String
    let info: @Sendable (String) -> String
    let warning: @Sendable (String) -> String
    let error: @Sendable (String) -> String
    let fatalError: @Sendable (String) -> String
    let verbose: @Sendable (String) -> String

    public init(
        disable: @escaping @Sendable (String) -> String,
        debug: @escaping @Sendable (String) -> String,
        info: @escaping @Sendable (String) -> String,
        warning: @escaping @Sendable (String) -> String,
        error: @escaping @Sendable (String) -> String,
        fatalError: @escaping @Sendable (String) -> String,
        verbose: @escaping @Sendable (String) -> String,
        description: String = String(describing: Self.self)
    ) {
        self.disable = disable
        self.debug = debug
        self.info = info
        self.warning = warning
        self.error = error
        self.fatalError = fatalError
        self.verbose = verbose
        self.description = description
    }
}

public extension LoggerColorConfiguration {
    static let linux: LoggerColorConfiguration = LoggerColorConfiguration(
        disable: { "\u{001B}[0;30m\($0)"},
        debug: { "\u{001B}[0;33m\($0)"},
        info: { "\u{001B}[0;34m\($0)"},
        warning: { "\u{001B}[0;33m\($0)"},
        error: { "\u{001B}[0;31m\($0)"},
        fatalError: { "\u{001B}[0;35m\($0)"},
        verbose: { "\u{001B}[0;32m\($0)" },
        description: "linux"
    )
    
    static let `default`: LoggerColorConfiguration = LoggerColorConfiguration(
        disable: { $0 },
        debug: { $0 },
        info: { $0 },
        warning: { $0 },
        error: { $0 },
        fatalError: { $0 },
        verbose: { $0 },
        description: "default"
    )
}

public struct LoggerDescriptionConfiguration: Sendable {
    let configuration: [LoggerLevel: String]
    
    public init(configuration: [LoggerLevel : String]) {
        self.configuration = configuration
    }
}

extension LoggerDescriptionConfiguration {
    static let `default`: LoggerDescriptionConfiguration = LoggerDescriptionConfiguration(
        configuration: [
            .disable: "⛔️",
            .error: "‼️", // error
            .info: "ℹ️", // info
            .debug: "💬", // debug
            .verbose: "🔬", // verbose
            .warning: "⚠️", // warning
            .fatalError: "🔥" // service
        ]
    )
}

/// Log level
public enum LoggerLevel: Int, CaseIterable, Equatable, Sendable {
    case disable
    case debug
    case info
    case warning
    case error
    case fatalError
    case verbose
}

extension LoggerLevel {
    public func description(
        using loggerDescriptionConfiguration: LoggerDescriptionConfiguration?
    ) -> String {
        guard let loggerDescriptionConfiguration,
              let value = loggerDescriptionConfiguration.configuration[self]
        else { return "" }
        return value
    }
}
