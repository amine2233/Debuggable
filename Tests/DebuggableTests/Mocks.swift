@testable import Debuggable
import Foundation

final class LoggerQueueMock: LoggerQueue {
    var invokedAsync = false
    var invokedAsyncCount = 0
    var invokedAsyncParameters: (group: DispatchGroup?, qos: DispatchQoS, flags: DispatchWorkItemFlags)?
    var invokedAsyncParametersList = [(group: DispatchGroup?, qos: DispatchQoS, flags: DispatchWorkItemFlags)]()
    var shouldInvokeAsyncWork = false

    func async(group: DispatchGroup?, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute work: @escaping @convention(block) () -> Void) {
        invokedAsync = true
        invokedAsyncCount += 1
        invokedAsyncParameters = (group, qos, flags)
        invokedAsyncParametersList.append((group, qos, flags))
        if shouldInvokeAsyncWork {
            work()
        }
    }
}

final class LoggerServiceMock: LoggerServiceProtocol {

    var invokedMinLoggerLevelGetter = false
    var invokedMinLoggerLevelGetterCount = 0
    var stubbedMinLoggerLevel: LoggerLevel!

    var minLoggerLevel: LoggerLevel {
        invokedMinLoggerLevelGetter = true
        invokedMinLoggerLevelGetterCount += 1
        return stubbedMinLoggerLevel
    }

    var invokedNameGetter = false
    var invokedNameGetterCount = 0
    var stubbedName: String! = ""

    var name: String {
        invokedNameGetter = true
        invokedNameGetterCount += 1
        return stubbedName
    }

    var invokedBundleIdentifierGetter = false
    var invokedBundleIdentifierGetterCount = 0
    var stubbedBundleIdentifier: String!

    var bundleIdentifier: String? {
        invokedBundleIdentifierGetter = true
        invokedBundleIdentifierGetterCount += 1
        return stubbedBundleIdentifier
    }

    var invokedIsEnabledSetter = false
    var invokedIsEnabledSetterCount = 0
    var invokedIsEnabled: Bool?
    var invokedIsEnabledList = [Bool]()
    var invokedIsEnabledGetter = false
    var invokedIsEnabledGetterCount = 0
    var stubbedIsEnabled: Bool! = false

    var isEnabled: Bool {
        set {
            invokedIsEnabledSetter = true
            invokedIsEnabledSetterCount += 1
            invokedIsEnabled = newValue
            invokedIsEnabledList.append(newValue)
        }
        get {
            invokedIsEnabledGetter = true
            invokedIsEnabledGetterCount += 1
            return stubbedIsEnabled
        }
    }

    var invokedLogContextsGetter = false
    var invokedLogContextsGetterCount = 0
    var stubbedLogContexts: [ContextProtocol]! = []

    var logContexts: [ContextProtocol] {
        invokedLogContextsGetter = true
        invokedLogContextsGetterCount += 1
        return stubbedLogContexts
    }

    var invokedLog = false
    var invokedLogCount = 0
    var invokedLogParameters: (level: LoggerLevel, Void)?
    var invokedLogParametersList = [(level: LoggerLevel, Void)]()
    var shouldInvokeLogMessage = false

    func log(_ message: @escaping @autoclosure () -> String, level: LoggerLevel) {
        invokedLog = true
        invokedLogCount += 1
        invokedLogParameters = (level, ())
        invokedLogParametersList.append((level, ()))
        if shouldInvokeLogMessage {
            _ = message()
        }
    }

    var invokedLogLevel = false
    var invokedLogLevelCount = 0
    var invokedLogLevelParameters: (level: LoggerLevel, context: ContextProtocol)?
    var invokedLogLevelParametersList = [(level: LoggerLevel, context: ContextProtocol)]()
    var shouldInvokeLogLevelMessage = false

    func log(_ message: @escaping @autoclosure () -> String, level: LoggerLevel, context: ContextProtocol) {
        invokedLogLevel = true
        invokedLogLevelCount += 1
        invokedLogLevelParameters = (level, context)
        invokedLogLevelParametersList.append((level, context))
        if shouldInvokeLogLevelMessage {
            _ = message()
        }
    }

    var invokedDebugLevel = false
    var invokedDebugLevelCount = 0
    var invokedDebugLevelParameters: (level: LoggerLevel, Void)?
    var invokedDebugLevelParametersList = [(level: LoggerLevel, Void)]()
    var shouldInvokeDebugLevelMessage = false

    func debug(_ message: @escaping @autoclosure () -> String, level: LoggerLevel) {
        invokedDebugLevel = true
        invokedDebugLevelCount += 1
        invokedDebugLevelParameters = (level, ())
        invokedDebugLevelParametersList.append((level, ()))
        if shouldInvokeDebugLevelMessage {
            _ = message()
        }
    }

    var invokedDebug = false
    var invokedDebugCount = 0
    var invokedDebugParameters: (error: Debuggable, Void)?
    var invokedDebugParametersList = [(error: Debuggable, Void)]()

    func debug(_ error: Debuggable) {
        invokedDebug = true
        invokedDebugCount += 1
        invokedDebugParameters = (error, ())
        invokedDebugParametersList.append((error, ()))
    }
}

final class ContextMock: ContextProtocol {
    var invokedNameGetter = false
    var invokedNameGetterCount = 0
    var stubbedName: String! = ""

    var name: String {
        invokedNameGetter = true
        invokedNameGetterCount += 1
        return stubbedName
    }
}

final class DebuggableMock: Debuggable {
    var invokedIdentifierGetter = false
    var invokedIdentifierGetterCount = 0
    var stubbedIdentifier: String! = ""

    var identifier: String {
        invokedIdentifierGetter = true
        invokedIdentifierGetterCount += 1
        return stubbedIdentifier
    }

    var invokedReasonGetter = false
    var invokedReasonGetterCount = 0
    var stubbedReason: String! = ""

    var reason: String {
        invokedReasonGetter = true
        invokedReasonGetterCount += 1
        return stubbedReason
    }

    var invokedSourceLocationGetter = false
    var invokedSourceLocationGetterCount = 0
    var stubbedSourceLocation: SourceLocation!

    var sourceLocation: SourceLocation? {
        invokedSourceLocationGetter = true
        invokedSourceLocationGetterCount += 1
        return stubbedSourceLocation
    }

    var invokedStackTraceGetter = false
    var invokedStackTraceGetterCount = 0
    var stubbedStackTrace: [String]!

    var stackTrace: [String]? {
        invokedStackTraceGetter = true
        invokedStackTraceGetterCount += 1
        return stubbedStackTrace
    }

    var invokedPossibleCausesGetter = false
    var invokedPossibleCausesGetterCount = 0
    var stubbedPossibleCauses: [String]! = []

    var possibleCauses: [String] {
        invokedPossibleCausesGetter = true
        invokedPossibleCausesGetterCount += 1
        return stubbedPossibleCauses
    }

    var invokedSuggestedFixesGetter = false
    var invokedSuggestedFixesGetterCount = 0
    var stubbedSuggestedFixes: [String]! = []

    var suggestedFixes: [String] {
        invokedSuggestedFixesGetter = true
        invokedSuggestedFixesGetterCount += 1
        return stubbedSuggestedFixes
    }

    var invokedDocumentationLinksGetter = false
    var invokedDocumentationLinksGetterCount = 0
    var stubbedDocumentationLinks: [String]! = []

    var documentationLinks: [String] {
        invokedDocumentationLinksGetter = true
        invokedDocumentationLinksGetterCount += 1
        return stubbedDocumentationLinks
    }

    var invokedStackOverflowQuestionsGetter = false
    var invokedStackOverflowQuestionsGetterCount = 0
    var stubbedStackOverflowQuestions: [String]! = []

    var stackOverflowQuestions: [String] {
        invokedStackOverflowQuestionsGetter = true
        invokedStackOverflowQuestionsGetterCount += 1
        return stubbedStackOverflowQuestions
    }

    var invokedGitHubIssuesGetter = false
    var invokedGitHubIssuesGetterCount = 0
    var stubbedGitHubIssues: [String]! = []

    var gitHubIssues: [String] {
        invokedGitHubIssuesGetter = true
        invokedGitHubIssuesGetterCount += 1
        return stubbedGitHubIssues
    }
}
