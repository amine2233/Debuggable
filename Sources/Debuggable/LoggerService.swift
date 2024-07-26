import Foundation

/// The logger service protocol
public protocol LoggerService: Sendable {
    /// Minimum loggger level by default is error
    var minLoggerLevel: LoggerLevel { get }
    /// The name of logger
    var name: String { get }
    
    /// The bundle identifier
    var bundleIdentifier: String? { get }
    
    /// This will enable or disable the service
    var isEnabled: Bool { get set }
    
    /// The context of logging
    var logContexts: [any LoggerContext] { get }
    
    /// Logger color configuration
    var loggerColorConfiguration: LoggerColorConfiguration? { get }
    
    /// Logger description
    var loggerDescriptionConfiguration: LoggerDescriptionConfiguration? { get }
    
    /// The list of services added to this class as observers.
    var services: [any LoggerService] { get }
    
    /// Log function
    func log(_ message: @escaping @Sendable @autoclosure () -> String, level: LoggerLevel)
    
    /// Log function with context
    func log(
        _ message: @escaping @Sendable @autoclosure () -> String,
        level: LoggerLevel,
        context: any LoggerContext
    )
    
    /// Adds a service as an observer.
    mutating func add(service: any LoggerService)
    
    /// Removes a service in observer
    mutating func remove(service: any LoggerService)
    
    func enable(_ value: Bool, name: String)
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
        return lhs.name == rhs.name &&
        lhs.bundleIdentifier == rhs.bundleIdentifier &&
        lhs.minLoggerLevel == rhs.minLoggerLevel &&
        lhs.isEnabled == rhs.isEnabled
    }
}

extension LoggerService {
    func applyColorForLevel(
        _ level: LoggerLevel,
        on value: String,
        loggerColorConfiguration: LoggerColorConfiguration?
    ) -> String {
        guard let loggerColorConfiguration else { return value }
        switch level {
        case .disable:
            return loggerColorConfiguration.disable(value)
        case .error:
            return loggerColorConfiguration.error(value)
        case .info:
            return loggerColorConfiguration.info(value)
        case .debug:
            return loggerColorConfiguration.debug(value)
        case .verbose:
            return loggerColorConfiguration.verbose(value)
        case .warning:
            return loggerColorConfiguration.warning(value)
        case .fatalError:
            return loggerColorConfiguration.fatalError(value)
        }
    }
}

extension LoggerService {
    
    public var logContexts: [any LoggerContext] {
        return []
    }
    
    public func debug(_ error: any Debuggable) {
        log(error: error.debugDescription)
    }
    
    func log(
        _ message: @autoclosure () -> String,
        level: LoggerLevel,
        file: String = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: String = #function
    ) {
        log(
            message(),
            level: level,
            context: ContextEmpty(),
            sourceLocation: SourceLocation(
                file: file,
                function: function,
                line: line,
                column: column,
                range: nil
            )
        )
    }
    
    func log(
        _ message: @autoclosure () -> String,
        level: LoggerLevel,
        context: any LoggerContext,
        sourceLocation: SourceLocation
    ) {
        var debug = ""
        debug += "\(level.description(using: loggerDescriptionConfiguration)) "
        debug += "[\(name)] "
        if let bundleIdentifier = self.bundleIdentifier {
            debug += "[\(bundleIdentifier)] "
        }
        if !context.name.isEmpty {
            debug += "[\(context.name)] "
        }
        debug += "[\(Date().toLoggerString)][\(sourceLocation.file.sourcefile)]"
        debug += ":[\(sourceLocation.line):\(sourceLocation.column):\(sourceLocation.function)]"

        var logMessage = applyColorForLevel(
            level,
            on: debug,
            loggerColorConfiguration: loggerColorConfiguration
        )
        
        let _message = message()

        if !_message.isEmpty {
            logMessage += "\n" + applyColorForLevel(
                level,
                on: _message,
                loggerColorConfiguration: loggerColorConfiguration
            )
        }

        print(logMessage)
    }
}

extension LoggerService {
    
    func log(
        error: @escaping @Sendable @autoclosure () -> String
    ) {
        log(error(), level: .error)
    }
    
    func log(
        info: @escaping @Sendable @autoclosure () -> String
    ) {
        log(info(), level: .info)
    }
    
    func log(
        debug: @escaping @Sendable @autoclosure () -> String
    ) {
        log(debug(), level: .debug)
    }
    
    func log(
        verbose: @escaping @Sendable @autoclosure () -> String
    ) {
        log(verbose(), level: .verbose)
    }
    
    func log(
        warning: @escaping @Sendable @autoclosure () -> String
    ) {
        log(warning(), level: .warning)
    }
    
    func log(
        fatalError: @escaping @Sendable @autoclosure () -> String
    ) {
        log(fatalError(), level: .fatalError)
    }
    
    func log(
        error: @escaping @Sendable @autoclosure () -> String,
        context: any LoggerContext
    ) {
        log(error(), level: .error, context: context)
    }
    
    func log(
        info: @escaping @Sendable @autoclosure () -> String,
        context: any LoggerContext
    ) {
        log(info(), level: .info, context: context)
    }
    
    func log(
        debug: @escaping @Sendable @autoclosure () -> String,
        context: any LoggerContext
    ) {
        log(debug(), level: .debug, context: context)
    }
    
    func log(
        verbose: @escaping @Sendable @autoclosure () -> String,
        context: any LoggerContext
    ) {
        log(verbose(), level: .verbose, context: context)
    }
    
    func log(
        warning: @escaping @Sendable @autoclosure () -> String,
        context: any LoggerContext
    ) {
        log(warning(), level: .warning, context: context)
    }
    
    func log(
        fatalError: @escaping @Sendable @autoclosure () -> String,
        context: any LoggerContext
    ) {
        log(fatalError(), level: .fatalError, context: context)
    }
}

extension LoggerService {
    func shouldLog(
        context: any LoggerContext
    ) -> Bool {
        return logContexts.contains(where: { $0.name == context.name} )
    }

    func isAllowedToLog(
        level: LoggerLevel
    ) -> Bool {
        guard minLoggerLevel != .disable else { return false }
        return level.rawValue <= minLoggerLevel.rawValue
    }
}
