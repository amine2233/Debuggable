import Foundation

struct LoggerServiceDefault: LoggerService, Equatable, Sendable {
    private(set) var services = [any LoggerService]()
    
    let name: String
    
    var isEnabled: Bool

    let minLoggerLevel: LoggerLevel
    
    let bundleIdentifier: String?

    let queue: any LoggerQueue
    
    let loggerColorConfiguration: LoggerColorConfiguration?
    
    let loggerDescriptionConfiguration: LoggerDescriptionConfiguration?

    init(
        name: String,
        enable: Bool,
        minLoggerLevel: LoggerLevel,
        queue: any LoggerQueue,
        bundleIdentifier: String?
    ) {
        self.name = name
        self.isEnabled = enable
        self.minLoggerLevel = minLoggerLevel
        self.queue = queue
        self.bundleIdentifier = bundleIdentifier
        self.loggerColorConfiguration = nil
        self.loggerDescriptionConfiguration = nil
    }
    
    mutating func add(service: any LoggerService) {
        self.services.append(service)
    }
    
    mutating func remove(service: any LoggerService) {
        self.services = self.services.filter { $0.name != service.name }
    }
    
    func enable(_ value: Bool, name: String) {
        if var service = self.services.filter({ $0.name == name }).last {
            service.isEnabled = value
        }
    }
    
    func log(
        _ message: @escaping @Sendable @autoclosure () -> String,
        level: LoggerLevel
    ) {
        dispatchLogger(message(), level: level)
    }
    
    func log(
        _ message: @escaping @Sendable @autoclosure () -> String,
        level: LoggerLevel,
        context: any LoggerContext
    ) {
        dispatchLogger(message(), level: level, context: context)
    }

    private func dispatchLogger(
        _ message: @escaping @Sendable @autoclosure () -> String,
        level: LoggerLevel,
        file: String = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: String = #function
    ) {
        guard isAllowedToLog(level: level) else { return }
        for service in services where service.isEnabled {
            guard service.isAllowedToLog(level: level) else { continue }
            queue.async(group: .none, qos: .default, flags: .detached) {
                service.log(
                    message(),
                    level: level,
                    file: file,
                    line: line,
                    column: column,
                    function: function
                )
            }
        }
    }

    private func dispatchLogger(
        _ message: @escaping @Sendable @autoclosure () -> String,
        level: LoggerLevel,
        context: any LoggerContext,
        file: String = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: String = #function
    ) {
        guard isAllowedToLog(level: level) else { return }
        for service in services where service.isEnabled {
            guard service.isAllowedToLog(level: level) else { continue }
            queue.async(group: .none, qos: .default, flags: .detached) {
                service.log(
                    message(),
                    level: level,
                    context: context,
                    sourceLocation: SourceLocation(
                        file: file,
                        function: function,
                        line: line,
                        column: column,
                        range: nil
                    )
                )
            }
        }
    }
}
