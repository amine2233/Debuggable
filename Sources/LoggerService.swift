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
    
    public func log(_ message: @autoclosure () -> String, level: LoggerLevel, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        for service in services where service.isEnabled {
            service.log(message, level: level, file: file, line: line, column: column, function: function)
        }
    }
    
    public func log(_ message: @autoclosure () -> String, level: LoggerLevel, context: ContextProtocol, sourceLocation: SourceLocation) {
        for service in services where service.isEnabled && service.shouldLog(context: context) {
            service.log(message, level: level, context: context, sourceLocation: sourceLocation)
        }
    }
    
    public func debug(_ message: @autoclosure () -> String, level: LoggerLevel) {
        for service in services where service.isEnabled {
            service.debug(message, level: level)
        }
    }
    
    public func debug(_ error: Debuggable) {
        for service in services where service.isEnabled {
            service.debug(error)
        }
    }
}

extension LoggerService {
    
    public func log(error: @autoclosure () -> String, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(error, level: .error, file: file, line: line, column: column, function: function)
    }
    
    public func log(info: @autoclosure () -> String, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(info, level: .info, file: file, line: line, column: column, function: function)
    }
    
    public func log(debug: @autoclosure () -> String, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(debug, level: .debug, file: file, line: line, column: column, function: function)
    }
    
    public func log(verbose: @autoclosure () -> String, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(verbose, level: .verbose, file: file, line: line, column: column, function: function)
    }
    
    public func log(warning: @autoclosure () -> String, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(warning, level: .warning, file: file, line: line, column: column, function: function)
    }
    
    public func log(service: @autoclosure () -> String, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(service, level: .service, file: file, line: line, column: column, function: function)
    }
    
    public func log(error: @autoclosure () -> String, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(error, level: .error, file: file, line: line, column: column, function: function)
    }
    
    public func log(info: @autoclosure () -> String, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(info, level: .info, context: context, sourceLocation: SourceLocation(file: file, function: function, line: line, column: column, range: nil))
    }
    
    public func log(debug: @autoclosure () -> String, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(debug, level: .debug, context: context, sourceLocation: SourceLocation(file: file, function: function, line: line, column: column, range: nil))
    }
    
    public func log(verbose: @autoclosure () -> String, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(verbose, level: .verbose, context: context, sourceLocation: SourceLocation(file: file, function: function, line: line, column: column, range: nil))
    }
    
    public func log(warning: @autoclosure () -> String, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(warning, level: .warning, context: context, sourceLocation: SourceLocation(file: file, function: function, line: line, column: column, range: nil))
    }
    
    public func log(service: @autoclosure () -> String, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        log(service, level: .service, context: context, sourceLocation: SourceLocation(file: file, function: function, line: line, column: column, range: nil))
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
