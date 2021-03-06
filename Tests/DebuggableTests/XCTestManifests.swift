#if !canImport(ObjectiveC)
import XCTest

extension DebuggableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DebuggableTests = [
        ("testDebugDescription", testDebugDescription),
        ("testDebugDescriptionWhenContainSourceLocation", testDebugDescriptionWhenContainSourceLocation),
        ("testDescription", testDescription),
        ("testDescriptionWhenContainSourceLocation", testDescriptionWhenContainSourceLocation),
        ("testDocumentationLinks", testDocumentationLinks),
        ("testDocumentationLinks_2", testDocumentationLinks_2),
        ("testDocumentationLinksWhenItsNotDescribed", testDocumentationLinksWhenItsNotDescribed),
        ("testErrorDescription", testErrorDescription),
        ("testFailureReason", testFailureReason),
        ("testGitHubIssues", testGitHubIssues),
        ("testGitHubIssues_2", testGitHubIssues_2),
        ("testGitHubIssuesWhenItsNotDescribed", testGitHubIssuesWhenItsNotDescribed),
        ("testHelpAnchor", testHelpAnchor),
        ("testIdentifier", testIdentifier),
        ("testPossibleCauses", testPossibleCauses),
        ("testPossibleCauses_2", testPossibleCauses_2),
        ("testPossibleCausesWhenItsNotDescribed", testPossibleCausesWhenItsNotDescribed),
        ("testReadableName", testReadableName),
        ("testReason", testReason),
        ("testRecoverySuggestion", testRecoverySuggestion),
        ("testStackOverflowQuestions", testStackOverflowQuestions),
        ("testStackOverflowQuestions_2", testStackOverflowQuestions_2),
        ("testStackOverflowQuestionsWhenItsNotDescribed", testStackOverflowQuestionsWhenItsNotDescribed),
        ("testStackTrace", testStackTrace),
        ("testSuggestedFixes", testSuggestedFixes),
        ("testSuggestedFixes_2", testSuggestedFixes_2),
        ("testSuggestedFixesWhenItsNotDescribed", testSuggestedFixesWhenItsNotDescribed),
        ("testTypeIdentifier", testTypeIdentifier),
        ("testTypeIdentifier_2", testTypeIdentifier_2),
    ]
}

extension LoggerServiceTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__LoggerServiceTests = [
        ("testAddServce", testAddServce),
        ("testBundleIdentifier", testBundleIdentifier),
        ("testDisableServce", testDisableServce),
        ("testEnableServce", testEnableServce),
        ("testLogDebug", testLogDebug),
        ("testLogDebugContext", testLogDebugContext),
        ("testLogError", testLogError),
        ("testLogErrorContext", testLogErrorContext),
        ("testLogFatalError", testLogFatalError),
        ("testLogFatalErrorContext", testLogFatalErrorContext),
        ("testLogInfo", testLogInfo),
        ("testLogInfoContext", testLogInfoContext),
        ("testLogMessageContextWhenCantShowLog", testLogMessageContextWhenCantShowLog),
        ("testLogMessageContextWhenCantShowLogDueToGlobalLevel", testLogMessageContextWhenCantShowLogDueToGlobalLevel),
        ("testLogMessageContextWhenMinLoggerLevelIsEqualPriorityThenServiceLogget", testLogMessageContextWhenMinLoggerLevelIsEqualPriorityThenServiceLogget),
        ("testLogMessageContextWhenMinLoggerLevelIsHigherPriorityThenServiceLogget", testLogMessageContextWhenMinLoggerLevelIsHigherPriorityThenServiceLogget),
        ("testLogMessageContextWhenMinLoggerLevelIsLessPriorityThenServiceLogget", testLogMessageContextWhenMinLoggerLevelIsLessPriorityThenServiceLogget),
        ("testLogMessageWhenCantShowLog", testLogMessageWhenCantShowLog),
        ("testLogMessageWhenCantShowLogDueToGlobalLevel", testLogMessageWhenCantShowLogDueToGlobalLevel),
        ("testLogMessageWhenMinLoggerLevelIsEqualPriorityThenServiceLogget", testLogMessageWhenMinLoggerLevelIsEqualPriorityThenServiceLogget),
        ("testLogMessageWhenMinLoggerLevelIsHigherPriorityThenServiceLogget", testLogMessageWhenMinLoggerLevelIsHigherPriorityThenServiceLogget),
        ("testLogMessageWhenMinLoggerLevelIsLessPriorityThenServiceLogget", testLogMessageWhenMinLoggerLevelIsLessPriorityThenServiceLogget),
        ("testLogVerbose", testLogVerbose),
        ("testLogVerboseContext", testLogVerboseContext),
        ("testLogwWarning", testLogwWarning),
        ("testLogwWarningContext", testLogwWarningContext),
        ("testRemoveServce", testRemoveServce),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DebuggableTests.__allTests__DebuggableTests),
        testCase(LoggerServiceTests.__allTests__LoggerServiceTests),
    ]
}
#endif
