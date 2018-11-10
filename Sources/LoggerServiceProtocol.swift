#if canImport(Foundation)
import Foundation

/// Log level
public enum LoggerLevel: String {
    case error = "‼️" // error
    case info = "ℹ️" // info
    case debug = "💬" // debug
    case verbose = "🔬" // verbose
    case warning = "⚠️" // warning
    case service = "🔥" // service
    
    public var color: String {
        switch self {
        case .error:
            return "\u{001B}[0;31m"
        case .info:
            return "\u{001B}[0;34m"
        case .debug:
            return "\u{001B}[0;33m"
        case .verbose:
            return "\u{001B}[0;32m"
        case .warning:
            return "\u{001B}[0;33m"
        case .service:
            return "\u{001B}[0;35m"
        }
    }
}

/// Context for debugging
public protocol ContextProtocol {
    var name: String { get }
    
    static var all: [ContextProtocol] { get }
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
public protocol LoggerServiceProtocol: class {
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
    var logContexts: [ContextProtocol] { get }
    
    /**
     Log function
     */
    func log(message: CustomStringConvertible, level: LoggerLevel, file: String, line: UInt, column: UInt, function: String)
    
    /**
     Log function with context
     */
    func log(message: CustomStringConvertible, level: LoggerLevel, context: ContextProtocol, sourceLocation: SourceLocation)
    
    /**
     Simple debug info
     */
    func debug(message: CustomStringConvertible, level: LoggerLevel)
    
    /**
     Debug information for debuggable protocol
     */
    func debug(error: Debuggable)
}

extension LoggerServiceProtocol {
    func shouldLog(context: ContextProtocol) -> Bool {
        return logContexts.contains(where: { $0.name == context.name} )
    }
}

extension LoggerServiceProtocol {
    
    public var logContexts: [ContextProtocol] {
        return []
    }
    
    public func log(message: CustomStringConvertible, level: LoggerLevel, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        var debug = "[\(name)]"
        if let bundleIdentifier = self.bundleIdentifier {
            debug += "[\(bundleIdentifier)]"
        }
        debug += "[\(Date().toLoggerString)] \(level.rawValue) [\(file.sourcefile)] : [\(line):\(column)] \(function) -> \(message)"
        
        debugPrint(debug)
    }
    
    public func log(message: CustomStringConvertible, level: LoggerLevel, context: ContextProtocol, sourceLocation: SourceLocation) {
        var debug = "[\(name)]"
        if let bundleIdentifier = self.bundleIdentifier {
            debug += "[\(bundleIdentifier)]"
        }
        debug += "[\(Date().toLoggerString)] \(level.rawValue) [\(sourceLocation.file.sourcefile)] : [\(context.name)]: [\(sourceLocation.line):\(sourceLocation.column)] \(sourceLocation.function) -> \(message)"
        
        debugPrint(debug)
    }
    
    public func debug(message: CustomStringConvertible, level: LoggerLevel) {
        self.log(message: message, level: level, file: #file, line: #line, column: #column, function: #function)
    }
    
    public func debug(error: Debuggable) {
        debugPrint(error.debugDescription)
    }
}
#endif
