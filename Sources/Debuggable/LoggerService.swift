#if canImport(Foundation)
import Foundation

open class LoggerService: LoggerServiceProtocol, Equatable {

    // The list of services added to this class as observers.
    internal private(set) var services = [LoggerServiceProtocol]()
    
    open var name: String
    
    open var isEnabled: Bool

    open var minLoggerLevel: LoggerLevel
    
    open var bundleIdentifier: String? {
        return Bundle.main.bundleIdentifier
    }

    public let queue: LoggerQueue
    
    public init(name: String, enable: Bool = false, minLoggerLevel: LoggerLevel, queue: LoggerQueue) {
        self.name = name
        self.isEnabled = enable
        self.minLoggerLevel = minLoggerLevel
        self.queue = queue
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
        if var service = self.services.filter({ $0.name == name }).last {
            service.isEnabled = value
        }
    }
    
    public func log(_ message: @escaping @autoclosure () -> String, level: LoggerLevel) {
        dispatchLogger(message(), level: level)
    }
    
    public func log(_ message: @escaping @autoclosure () -> String, level: LoggerLevel, context: ContextProtocol) {
        dispatchLogger(message(), level: level, context: context)
    }

    private func dispatchLogger(_ message: @escaping @autoclosure () -> String, level: LoggerLevel, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        guard isAllowedToLog(level: level) else { return }
        for service in services where service.isEnabled {
            guard service.isAllowedToLog(level: level) else { continue }
            queue.async {
                service.log(message(), level: level, file: file, line: line, column: column, function: function)
            }
        }
    }

    private func dispatchLogger(_ message: @escaping @autoclosure () -> String, level: LoggerLevel, context: ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        guard isAllowedToLog(level: level) else { return }
        for service in services where service.isEnabled {
            guard service.isAllowedToLog(level: level) else { continue }
            queue.async {
                service.log(message(), level: level, context: context, sourceLocation: SourceLocation(file: file, function: function, line: line, column: column, range: nil))
            }
        }
    }
}

extension LoggerService {
    
    public func log(error: @escaping @autoclosure () -> String) {
        log(error(), level: .error)
    }
    
    public func log(info: @escaping @autoclosure () -> String) {
        log(info(), level: .info)
    }
    
    public func log(debug: @escaping @autoclosure () -> String) {
        log(debug(), level: .debug)
    }
    
    public func log(verbose: @escaping @autoclosure () -> String) {
        log(verbose(), level: .verbose)
    }
    
    public func log(warning: @escaping @autoclosure () -> String) {
        log(warning(), level: .warning)
    }
    
    public func log(fatalError: @escaping @autoclosure () -> String) {
        log(fatalError(), level: .fatalError)
    }
    
    public func log(error: @escaping @autoclosure () -> String, context: ContextProtocol) {
        log(error(), level: .error, context: context)
    }
    
    public func log(info: @escaping @autoclosure () -> String, context: ContextProtocol) {
        log(info(), level: .info, context: context)
    }
    
    public func log(debug: @escaping @autoclosure () -> String, context: ContextProtocol) {
        log(debug(), level: .debug, context: context)
    }
    
    public func log(verbose: @escaping @autoclosure () -> String, context: ContextProtocol) {
        log(verbose(), level: .verbose, context: context)
    }
    
    public func log(warning: @escaping @autoclosure () -> String, context: ContextProtocol) {
        log(warning(), level: .warning, context: context)
    }
    
    public func log(fatalError: @escaping @autoclosure () -> String, context: ContextProtocol) {
        log(fatalError(), level: .fatalError, context: context)
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
        return components.isEmpty ? "" : components.last ?? ""
    }
}
#endif
