//
//  File.swift
//  
//
//  Created by Amine Bensalah on 18/11/2020.
//

import XCTest
@testable import Debuggable

final class LoggerServiceTests: XCTestCase {
    var loggerQueue: LoggerQueueMock!
    var service: LoggerServiceMock!
    var contextMock: ContextMock!

    override func setUpWithError() throws {
        loggerQueue = LoggerQueueMock()
        service = LoggerServiceMock()
        contextMock = ContextMock()
    }

    override func tearDownWithError() throws {
        loggerQueue = nil
        service = nil
        contextMock = nil
    }

    func makeTest(name: String, enable: Bool = true, minLoggerLevel: LoggerLevel = .fatalError) -> LoggerService {
        LoggerService(name: name,
                      enable: enable,
                      minLoggerLevel: minLoggerLevel,
                      queue: loggerQueue,
                      bundleIdentifier: Bundle.test.bundleIdentifier)
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
        underTest.log("test", level: .debug)

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
        underTest.log("test", level: .debug)

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
        underTest.log("test", level: .debug)

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
        underTest.log("test", level: .error)

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
        underTest.log("test", level: .error)

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
        underTest.log("test", level: .debug, context: contextMock)

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
        underTest.log("test", level: .debug, context: contextMock)

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
        underTest.log("test", level: .debug, context: contextMock)

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
        underTest.log("test", level: .error, context: contextMock)

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
        underTest.log("test", level: .error, context: contextMock)

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
        underTest.log(error: "test")

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
        underTest.log(info: "test")

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
        underTest.log(debug: "test")

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
        underTest.log(verbose: "test")

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
        underTest.log(warning: "test")

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
        underTest.log(fatalError: "test")

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
        underTest.log(error: "test", context: contextMock)

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
        underTest.log(info: "test", context: contextMock)

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
        underTest.log(debug: "test", context: contextMock)

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
        underTest.log(verbose: "test", context: contextMock)

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
        underTest.log(warning: "test", context: contextMock)

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
        underTest.log(fatalError: "test", context: contextMock)

        // THEN
        XCTAssertEqual(self.loggerQueue.invokedAsyncCount, 1)
    }
}
