import Foundation

public enum LoggerLevel: String {
    case error      = "‼️" // error
    case info       = "ℹ️" // info
    case debug      = "💬" // debug
    case verbose    = "🔬" // verbose
    case warning    = "⚠️" // warning
    case service    = "🔥" // service
    
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

public protocol Logger {
    static func log(message: CustomStringConvertible, level: LoggerLevel, fileName: String, line: Int, column: Int, funcName: String)
    static func debug(message: CustomStringConvertible, level: LoggerLevel)
    static func debug(error: Debuggable)
}

extension Logger {
    public static func debug(message: CustomStringConvertible, level: LoggerLevel) {
        Self.log(message: message, level: level, fileName: #file, line: #line, column: #column, funcName: #function)
    }
    
    public static func debug(error: Debuggable) {
        debugPrint(error.debugDescription)
    }
}

public protocol Loggable {
    static func log(error: CustomStringConvertible, fileName: String, line: Int, column: Int, funcName: String)
    static func log(info: CustomStringConvertible, fileName: String, line: Int, column: Int, funcName: String)
    static func log(debug: CustomStringConvertible, fileName: String, line: Int, column: Int, funcName: String)
    static func log(verbose: CustomStringConvertible, fileName: String, line: Int, column: Int, funcName: String)
    static func log(warning: CustomStringConvertible, fileName: String, line: Int, column: Int, funcName: String)
    static func log(service: CustomStringConvertible, fileName: String, line: Int, column: Int, funcName: String)
}

public struct LoggerManager: Logger {
    
    public static func log(message: CustomStringConvertible, level: LoggerLevel, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        debugPrint("[\(Date().toLoggerString)] \(level.rawValue) [\(fileName.sourceFileName)] : [\(line):\(column)] \(funcName) -> \(message)")
    }
}

extension LoggerManager: Loggable {
    public static func log(error: CustomStringConvertible, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        log(message: error, level: .error, fileName: fileName, line: line, column: column, funcName: funcName)
    }
    
    public static func log(info: CustomStringConvertible, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        log(message: info, level: .info, fileName: fileName, line: line, column: column, funcName: funcName)
    }
    
    public static func log(debug: CustomStringConvertible, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        log(message: debug, level: .debug, fileName: fileName, line: line, column: column, funcName: funcName)
    }
    
    public static func log(verbose: CustomStringConvertible, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        log(message: verbose, level: .verbose, fileName: fileName, line: line, column: column, funcName: funcName)
    }
    
    public static func log(warning: CustomStringConvertible, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        log(message: warning, level: .warning, fileName: fileName, line: line, column: column, funcName: funcName)
    }
    
    public static func log(service: CustomStringConvertible, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        log(message: service, level: .service, fileName: fileName, line: line, column: column, funcName: funcName)
    }
}

extension Date {
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        return formatter
    }
    
    var toLoggerString: String {
        return Date.dateFormatter.string(from: self as Date)
    }
}

extension String {
    var sourceFileName: String {
        let components = self.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
