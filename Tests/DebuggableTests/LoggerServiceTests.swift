//
//  File.swift
//  
//
//  Created by Amine Bensalah on 18/11/2020.
//

import XCTest
@testable import Debuggable

extension LoggerColorConfiguration {
    static let macOS: LoggerColorConfiguration = LoggerColorConfiguration(
        disable: { $0 },
        debug: { Array($0).map({ "\($0)\u{fe07}" }).joined() }, // green
        info: { Array($0).map({ "\($0)\u{fe09}" }).joined() }, // blue
        warning: { Array($0).map({ "\($0)\u{fe08}" }).joined() }, // orange
        error: { Array($0).map({ "\($0)\u{fe06}" }).joined() }, // red
        fatalError: { Array($0).map({ "\($0)\u{fe06}" }).joined() }, // red
        verbose: { Array($0).map({ "\($0)\u{fe0A}" }).joined() }, // pink
        description: "macOS"
    )
}

final class LoggerServiceTests: XCTestCase {
    var loggerQueue: LoggerQueueMock!
    var service: LoggerServiceMock!
    var contextMock: ContextMock!

    override func setUpWithError() throws {
        var color: LoggerColorConfiguration = .macOS
        #if os(Linux)
        color = .linux
        #endif

        loggerQueue = LoggerQueueMock()
        service = LoggerServiceMock()
        service.stubbedLoggerColorConfigurationLevel = color
        service.stubbedLoggerDescriptionConfigurationLevel = .default
        contextMock = ContextMock()
    }

    override func tearDownWithError() throws {
        loggerQueue = nil
        service = nil
        contextMock = nil
    }

    func makeTest(
        name: String,
        enable: Bool = true,
        minLoggerLevel: LoggerLevel = .fatalError
    ) -> any LoggerService {
        return LoggerServiceFactory.build(
            name: name,
            enable: enable,
            minLoggerLevel: minLoggerLevel,
            queue: loggerQueue,
            bundleIdentifier: Bundle.test.bundleIdentifier
        )
    }

    func testAddServce() {
        // GIVEN
        service.stubbedName = "oslog"
        var underTest = makeTest(name: #function)

        // WHEN
        underTest.add(service: service)

        // THEN
        XCTAssertEqual(underTest.services.count, 1)
        XCTAssertTrue(underTest.services.contains(where: { $0.name == "oslog" }))
    }

    func xtestBundleIdentifier() {
        // GIVEN
        let underTest = makeTest(name: #function)

        // THEN
        // Bundle(identifier: "com.apple.dt.xctest.tool")?.bundleIdentifier
        XCTAssertEqual(underTest.bundleIdentifier, "DebuggableTests")
    }

    func testRemoveServce() {
        // GIVEN
        service.stubbedName = "oslog"
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.remove(service: service)

        // THEN
        XCTAssertEqual(underTest.services.count, 0)
        XCTAssertFalse(underTest.services.contains(where: { $0.name == "oslog" }))
    }

    func testEnableServce() {
        // GIVEN
        service.stubbedName = "oslog"
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.enable(true, name: "oslog")

        // THEN
        XCTAssertTrue(service.invokedIsEnabled!)
        XCTAssertTrue(service.invokedIsEnabledSetter)
        XCTAssertEqual(service.invokedIsEnabledSetterCount, 1)
    }

    func testDisableServce() {
        // GIVEN
        service.stubbedName = "oslog"
        service.isEnabled = false
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.enable(false, name: "oslog")

        // THEN
        XCTAssertFalse(service.invokedIsEnabled!)
        XCTAssertTrue(service.invokedIsEnabledSetter)
        XCTAssertEqual(service.invokedIsEnabledSetterCount, 2)
    }

    func testLogMessageWhenMinLoggerLevelIsEqualPriorityThenServiceLogget() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .fatalError
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log("test debug", level: .debug)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogMessageWhenMinLoggerLevelIsLessPriorityThenServiceLogget() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .debug
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log("test debug", level: .debug)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogMessageWhenMinLoggerLevelIsHigherPriorityThenServiceLogget() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .info
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log("test debug", level: .debug)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogMessageWhenCantShowLog() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .warning
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log("test error", level: .error)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 0)
    }

    func testLogMessageWhenCantShowLogDueToGlobalLevel() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .warning
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function, minLoggerLevel: .debug)
        underTest.add(service: service)

        // WHEN
        underTest.log("test error", level: .error)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 0)
    }

    func testLogMessageContextWhenMinLoggerLevelIsEqualPriorityThenServiceLogget() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .fatalError
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log("test debug", level: .debug, context: contextMock)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogMessageContextWhenMinLoggerLevelIsLessPriorityThenServiceLogget() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .debug
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log("test debug", level: .debug, context: contextMock)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogMessageContextWhenMinLoggerLevelIsHigherPriorityThenServiceLogget() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .info
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log("test debug", level: .debug, context: contextMock)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogMessageContextWhenCantShowLog() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .warning
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log("test error", level: .error, context: contextMock)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 0)
    }

    func testLogMessageContextWhenCantShowLogDueToGlobalLevel() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .warning
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function, minLoggerLevel: .debug)
        underTest.add(service: service)

        // WHEN
        underTest.log("test error", level: .error, context: contextMock)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 0)
    }

    func testLogError() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .error
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log(error: "test error")

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogInfo() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .info
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log(info: "test info")

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogDebug() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .debug
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log(debug: "test debug")

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogVerbose() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .verbose
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function, minLoggerLevel: .verbose)
        underTest.add(service: service)

        // WHEN
        underTest.log(verbose: "test verbose")

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogwWarning() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .warning
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log(warning: "test warning")

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogFatalError() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .fatalError
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log(fatalError: "test fatalError")

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogErrorContext() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .error
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log(error: "test error", context: contextMock)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogInfoContext() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .info
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log(info: "test info", context: contextMock)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogDebugContext() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .debug
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log(debug: "test debug", context: contextMock)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogVerboseContext() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .verbose
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function, minLoggerLevel: .verbose)
        underTest.add(service: service)

        // WHEN
        underTest.log(verbose: "test verbose", context: contextMock)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogwWarningContext() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .warning
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log(warning: "test warning", context: contextMock)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }

    func testLogFatalErrorContext() {
        // GIVEN
        service.stubbedName = "oslog"
        service.stubbedIsEnabled = true
        service.stubbedMinLoggerLevel = .fatalError
        loggerQueue.shouldInvokeAsyncWork = true
        var underTest = makeTest(name: #function)
        underTest.add(service: service)

        // WHEN
        underTest.log(fatalError: "test fatalError", context: contextMock)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }
}
