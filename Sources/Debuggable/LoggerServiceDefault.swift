import Foundation

public struct LoggerServiceDefault: LoggerService, Equatable {

    // The list of services added to this class as observers.
    private(set) var services = [any LoggerService]()
    
    public let name: String
    
    public var isEnabled: Bool

    public var minLoggerLevel: LoggerLevel
    
    public let bundleIdentifier: String?

    public let queue: any LoggerQueue
    
    public let loggerColorConfiguration: LoggerColorConfiguration
    
    public init(
        name: String,
        enable: Bool = false,
        minLoggerLevel: LoggerLevel = .didabled,
        queue: any LoggerQueue = DispatchQueue.global(),
        bundleIdentifier: String? = Bundle.main.bundleIdentifier,
        loggerColorConfiguration: LoggerColorConfiguration = .default
    ) {
        self.name = name
        self.isEnabled = enable
        self.minLoggerLevel = minLoggerLevel
        self.queue = queue
        self.bundleIdentifier = bundleIdentifier
        self.loggerColorConfiguration = loggerColorConfiguration
    }
    
    /**
     Adds a service as an observer.
     */
    public mutating func add(service: any LoggerService) {
        self.services.append(service)
    }
    
    /**
     Removes a service in observer
     */
    public mutating func remove(service: any LoggerService) {
        self.services = self.services.filter { $0.name != service.name }
    }
    
    public func enable(_ value: Bool, name: String) {
        if var service = self.services.filter({ $0.name == name }).last {
            service.isEnabled = value
        }
    }
    
    public func log(_ message: @escaping @Sendable @autoclosure () -> String, level: LoggerLevel) {
        dispatchLogger(message(), level: level)
    }
    
    public func log(_ message: @escaping @Sendable @autoclosure () -> String, level: LoggerLevel, context: any ContextProtocol) {
        dispatchLogger(message(), level: level, context: context)
    }

    private func dispatchLogger(_ message: @escaping @Sendable @autoclosure () -> String, level: LoggerLevel, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        guard isAllowedToLog(level: level) else { return }
        for service in services where service.isEnabled {
            guard service.isAllowedToLog(level: level) else { continue }
            queue.async(group: .none, qos: .default, flags: .detached) {
                service.log(message(), level: level, file: file, line: line, column: column, function: function)
            }
        }
    }

    private func dispatchLogger(_ message: @escaping @Sendable @autoclosure () -> String, level: LoggerLevel, context: any ContextProtocol, file: String = #file, line: UInt = #line, column: UInt = #column, function: String = #function) {
        guard isAllowedToLog(level: level) else { return }
        for service in services where service.isEnabled {
            guard service.isAllowedToLog(level: level) else { continue }
            queue.async(group: .none, qos: .default, flags: .detached) {
                service.log(message(), level: level, context: context, sourceLocation: SourceLocation(file: file, function: function, line: line, column: column, range: nil))
            }
        }
    }
}

extension LoggerServiceDefault {
    
    public func log(error: @escaping @Sendable @autoclosure () -> String) {
        log(error(), level: .error)
    }
    
    public func log(info: @escaping @Sendable @autoclosure () -> String) {
        log(info(), level: .info)
    }
    
    public func log(debug: @escaping @Sendable @autoclosure () -> String) {
        log(debug(), level: .debug)
    }
    
    public func log(verbose: @escaping @Sendable @autoclosure () -> String) {
        log(verbose(), level: .verbose)
    }
    
    public func log(warning: @escaping @Sendable @autoclosure () -> String) {
        log(warning(), level: .warning)
    }
    
    public func log(fatalError: @escaping @Sendable @autoclosure () -> String) {
        log(fatalError(), level: .fatalError)
    }
    
    public func log(error: @escaping @Sendable @autoclosure () -> String, context: any ContextProtocol) {
        log(error(), level: .error, context: context)
    }
    
    public func log(info: @escaping @Sendable @autoclosure () -> String, context: any ContextProtocol) {
        log(info(), level: .info, context: context)
    }
    
    public func log(debug: @escaping @Sendable @autoclosure () -> String, context: any ContextProtocol) {
        log(debug(), level: .debug, context: context)
    }
    
    public func log(verbose: @escaping @Sendable @autoclosure () -> String, context: any ContextProtocol) {
        log(verbose(), level: .verbose, context: context)
    }
    
    public func log(warning: @escaping @Sendable @autoclosure () -> String, context: any ContextProtocol) {
        log(warning(), level: .warning, context: context)
    }
    
    public func log(fatalError: @escaping @Sendable @autoclosure () -> String, context: any ContextProtocol) {
        log(fatalError(), level: .fatalError, context: context)
    }
}

extension Date {
    static let dateFormat = "yyyy-MM-dd hh:mm:ssSSS"

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        return formatter
    }()

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
