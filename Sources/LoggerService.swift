#if canImport(Foundation)
import Foundation

open class LoggerService: LoggerServiceProtocol {
    
    // The list of services added to this class as observers.
    internal private(set) var services = [LoggerServiceProtocol]()
    
    open var name: String
    
    open var isEnabled: Bool
    
    open var bundleIdentifier: String? {
        return Bundle.main.bundleIdentifier
    }
    
    public init(name: String, enable: Bool = false) {
        self.name = name
        self.isEnabled = enable
    }
    
    /**
     Adds a service as an observer.
     */
    public func add(service: LoggerServiceProtocol) {
        self.services.append(service)
    }
    
    /**
     Removes a service in observer
     */
    public func remove(service: LoggerServiceProtocol) {
        self.services = self.services.filter { $0.name != service.name }
    }
    
    public func enable(_ value: Bool, name: String) {
        if let service = self.services.filter({ $0.name == name }).last {
            service.isEnabled = value
        }
    }
    
    public func log(message: CustomStringConvertible, level: LoggerLevel, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        for service in services where service.isEnabled {
            service.log(message: message, level: level, file: file, line: line, column: column, function: function)
        }
    }
    
    public func log(message: CustomStringConvertible, level: LoggerLevel, context: ContextProtocol, sourceLocation: SourceLocation) {
        for service in services where service.isEnabled && service.shouldLog(context: context) {
            service.log(message: message, level: level, context: context, sourceLocation: sourceLocation)
        }
    }
    
    public func debug(message: CustomStringConvertible, level: LoggerLevel) {
        for service in services where service.isEnabled {
            service.debug(message: message, level: level)
        }
    }
    
    public func debug(error: Debuggable) {
        for service in services where service.isEnabled {
            service.debug(error: error)
        }
    }
}

extension LoggerService {
    
    public func log(error: CustomStringConvertible, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(message: error, level: .error, file: file, line: line, column: column, function: function)
    }
    
    public func log(info: CustomStringConvertible, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(message: info, level: .info, file: file, line: line, column: column, function: function)
    }
    
    public func log(debug: CustomStringConvertible, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(message: debug, level: .debug, file: file, line: line, column: column, function: function)
    }
    
    public func log(verbose: CustomStringConvertible, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(message: verbose, level: .verbose, file: file, line: line, column: column, function: function)
    }
    
    public func log(warning: CustomStringConvertible, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(message: warning, level: .warning, file: file, line: line, column: column, function: function)
    }
    
    public func log(service: CustomStringConvertible, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(message: service, level: .service, file: file, line: line, column: column, function: function)
    }
    
    public func log(error: CustomStringConvertible, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(message: error, level: .error, file: file, line: line, column: column, function: function)
    }
    
    public func log(info: CustomStringConvertible, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(message: info, level: .info, context: context, sourceLocation: SourceLocation(file: file, function: function, line: line, column: column, range: nil))
    }
    
    public func log(debug: CustomStringConvertible, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(message: debug, level: .debug, context: context, sourceLocation: SourceLocation(file: file, function: function, line: line, column: column, range: nil))
    }
    
    public func log(verbose: CustomStringConvertible, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(message: verbose, level: .verbose, context: context, sourceLocation: SourceLocation(file: file, function: function, line: line, column: column, range: nil))
    }
    
    public func log(warning: CustomStringConvertible, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(message: warning, level: .warning, context: context, sourceLocation: SourceLocation(file: file, function: function, line: line, column: column, range: nil))
    }
    
    public func log(service: CustomStringConvertible, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(message: service, level: .service, context: context, sourceLocation: SourceLocation(file: file, function: function, line: line, column: column, range: nil))
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
    var sourcefile: String {
        let components = self.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
#endif
