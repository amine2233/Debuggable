import Foundation

public struct LoggerColorConfiguration: Sendable {
    public let configuration: [LoggerLevel: String]
    
    public init(configuration: [LoggerLevel : String]) {
        self.configuration = configuration
    }
}

public extension LoggerColorConfiguration {
    static let `default`: LoggerColorConfiguration = LoggerColorConfiguration(
        configuration: [
            .didabled: "\u{001B}[0;30m",
            .debug: "\u{001B}[0;33m",
            .info: "\u{001B}[0;34m",
            .warning: "\u{001B}[0;33m",
            .error: "\u{001B}[0;31m",
            .fatalError: "\u{001B}[0;35m",
            .verbose: "\u{001B}[0;32m"
        ]
    )

    static let macos: LoggerColorConfiguration = LoggerColorConfiguration(
        configuration: [
            .didabled: "\u{fe07}",
            .debug: "\u{fe07}",
            .info: "\u{fe07}",
            .warning: "\u{fe08}",
            .error: "\u{fe06}",
            .fatalError: "\u{fe06}",
            .verbose: "\u{fe07}"
        ]
    )
}

/// Log level
public enum LoggerLevel: Int, CaseIterable, Equatable, Sendable {
    case didabled
    case debug
    case info
    case warning
    case error
    case fatalError
    case verbose

    public func color(loggerColorConfiguration: LoggerColorConfiguration) -> String {
        loggerColorConfiguration.configuration[self] ?? ""
    }
}

extension LoggerLevel: CustomStringConvertible {
    public var description: String {
        switch self {
        case .didabled: return "⛔️"
        case .error: return "‼️" // error
        case .info: return "ℹ️" // info
        case .debug: return "💬" // debug
        case .verbose: return "🔬" // verbose
        case .warning: return "⚠️" // warning
        case .fatalError: return "🔥" // service
        }
    }
}

/// Context for debugging
public protocol ContextProtocol: Sendable {
    var name: String { get }    
}

extension ContextProtocol where Self: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}

/// The logger service protocol
public protocol LoggerService: Sendable {
    /// Minimum loggger level by default is error
    var minLoggerLevel: LoggerLevel { get }
    /**
     The name of logger
     */
    var name: String { get }
    
    /**
     The bundle identifier
     */
    var bundleIdentifier: String? { get }
    
    /**
     This will enable or disable the service
     */
    var isEnabled: Bool { get set }
    
    /**
     The context of logging
     */
    var logContexts: [any ContextProtocol] { get }
    
    /// Logger color configuration
    var loggerColorConfiguration: LoggerColorConfiguration { get }
    
    /**
     Log function
     */
    func log(_ message: @escaping @Sendable @autoclosure () -> String, level: LoggerLevel)
    
    /**
     Log function with context
     */
    func log(
        _ message: @escaping @Sendable @autoclosure () -> String,
        level: LoggerLevel,
        context: any ContextProtocol
    )
}

extension LoggerService {
    func shouldLog(context: any ContextProtocol) -> Bool {
        return logContexts.contains(where: { $0.name == context.name} )
    }

    public func isAllowedToLog(level: LoggerLevel) -> Bool {
        guard minLoggerLevel != .didabled else { return false }
        return level.rawValue <= minLoggerLevel.rawValue
    }
}

extension LoggerService where Self: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}

extension LoggerService {
    
    public var logContexts: [any ContextProtocol] {
        return []
    }
    
    public func log(
        _ message: @autoclosure () -> String,
        level: LoggerLevel,
        file: String = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: String = #function
    ) {
        var debug = ""
        debug += "[\(name)]"
        if let bundleIdentifier = self.bundleIdentifier {
            debug += "[\(bundleIdentifier)]"
        }
        debug += "[\(Date().toLoggerString)] \(level.description) [\(file.sourcefile)]:  [\(line):\(column):\(function)]\n\(message())"
        
        print(debug.color(level.color(loggerColorConfiguration: loggerColorConfiguration)))
    }
    
    public func log(
        _ message: @autoclosure () -> String,
        level: LoggerLevel,
        context: any ContextProtocol,
        sourceLocation: SourceLocation
    ) {
        var debug = ""
        debug += debug.color(level.color(loggerColorConfiguration: loggerColorConfiguration))
        debug += "[\(name)]"
        if let bundleIdentifier = self.bundleIdentifier {
            debug += "[\(bundleIdentifier)]"
        }
        debug += "[\(Date().toLoggerString)] \(level.description) [\(sourceLocation.file.sourcefile)]: [\(context.name)]: [\(sourceLocation.line):\(sourceLocation.column):\(sourceLocation.function)]\n\(message())"
        
        print(debug.color(level.color(loggerColorConfiguration: loggerColorConfiguration)))
    }

    public func debug(_ error: any Debuggable) {
        print(error.debugDescription)
    }
}

extension String {
    
    func color(_ color: String) -> String {
        //return Array(self).map({ "\($0)\u{fe07}"}).joined()
        return Array(self).map({ "\($0)\(String(color))" }).joined()
    }
}
