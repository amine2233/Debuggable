//
//  DebuggableTests.swift
//  DebuggableTests
//

import XCTest
@testable import Debuggable

enum TestError: String, Error {
    case empty
}

extension TestError: Debuggable {
    var identifier: String {
        rawValue
    }

    var reason: String {
        switch self {
        case .empty: return "empty failure"
        }
    }

    var possibleCauses: [String] {
        switch self {
        case .empty: return ["empty cause"]
        }
    }

    var suggestedFixes: [String] {
        switch self {
        case .empty: return ["empty suggested"]
        }
    }

    var documentationLinks: [String] {
        switch self {
        case .empty: return ["https://doc.github.com"]
        }
    }

    var stackOverflowQuestions: [String] {
        switch self {
        case .empty: return ["https://stackoverflow.com"]
        }
    }

    var gitHubIssues: [String] {
        switch self {
        case .empty: return ["xxxx"]
        }
    }
}

enum TestShortError: String, Error {
    case empty
}

extension TestShortError: Debuggable {
    var identifier: String {
        rawValue
    }

    var reason: String {
        switch self {
        case .empty: return "empty short failure"
        }
    }

    var sourceLocation: SourceLocation? { .capture() }
}

class DebuggableTests: XCTestCase {

    func testReadableName() {
        XCTAssertEqual(TestError.readableName, "TestError")
    }

    func testTypeIdentifier() {
        XCTAssertEqual(TestError.typeIdentifier, "TestError")
    }

    func testTypeIdentifier_2() {
        // Test on `Mock`
        XCTAssertEqual(DebuggableMock.typeIdentifier, "DebuggableMock")
    }

    func testIdentifier() {
        XCTAssertEqual(TestError.empty.identifier, "empty")
    }

    func testReason() {
        XCTAssertEqual(TestError.empty.reason, "empty failure")
    }

    func testStackTrace() {
        XCTAssertNotNil(TestError.empty.stackTrace)
    }

    func testPossibleCauses() {
        // Test on `TestError`
        XCTAssertEqual(TestError.empty.possibleCauses, ["empty cause"])
    }

    func testPossibleCausesWhenItsNotDescribed() {
        // Test on `Mock`
        let error = DebuggableMock()
        XCTAssertEqual(error.possibleCauses, [])
    }

    func testSuggestedFixes() {
        // Test on `TestError`
        XCTAssertEqual(TestError.empty.suggestedFixes, ["empty suggested"])
    }

    func testSuggestedFixesWhenItsNotDescribed() {
        // Test on `Mock`
        let error = DebuggableMock()
        XCTAssertEqual(error.suggestedFixes, [])
    }

    func testDocumentationLinks() {
        // Test on `TestError`
        XCTAssertEqual(TestError.empty.documentationLinks, ["https://doc.github.com"])
    }

    func testDocumentationLinksWhenItsNotDescribed() {
        // Test on `Mock`
        let error = DebuggableMock()
        XCTAssertEqual(error.documentationLinks, [])
    }

    func testStackOverflowQuestions() {
        // Test on `TestError`
        XCTAssertEqual(TestError.empty.stackOverflowQuestions, ["https://stackoverflow.com"])
    }

    func testStackOverflowQuestionsWhenItsNotDescribed() {
        // Test on `Mock`
        let error = DebuggableMock()
        XCTAssertEqual(error.stackOverflowQuestions, [])
    }

    func testGitHubIssues() {
        // Test on `TestError`
        XCTAssertEqual(TestError.empty.gitHubIssues, ["xxxx"])
    }

    func testGitHubIssuesWhenItsNotDescribed() {
        // Test on `Mock`
        let error = DebuggableMock()
        XCTAssertEqual(error.gitHubIssues, [])
    }

    func testDebugDescription() {
        let test = "⚠️ TestError: empty failure"
        XCTAssertTrue(TestError.empty.debugDescription.contains(test))
    }

    func testDebugDescriptionWhenContainSourceLocation() {
        let test = "⚠️ TestShortError: empty short failure"
        XCTAssertTrue(TestShortError.empty.debugDescription.contains(test))
    }

    func testDescriptionWhenContainSourceLocation() {
        let test = "⚠️ [TestShortError.empty: empty short failure] ["
        XCTAssertTrue(TestShortError.empty.description.contains(test))
    }

    func testDescription() {
        let identifier = "mock"
        let possibleCauses = "authentication failure"
        let reason = "mock failure"
        let suggedtedFixes = "mock suggested"
        let error = DebuggableMock()
        error.stubbedIdentifier = identifier
        error.stubbedPossibleCauses = [possibleCauses]
        error.stubbedReason = reason
        error.stubbedSuggestedFixes = [suggedtedFixes]

        let test = "⚠️ [DebuggableMock.\(identifier): \(reason)] [Possible causes: \(possibleCauses)] [Suggested fixes: \(suggedtedFixes)]"
        XCTAssertEqual(error.description, test)
        XCTAssertEqual(error.errorDescription, test)
    }

    func testErrorDescription() {
        let identifier = "mock"
        let possibleCauses = "authentication failure"
        let reason = "mock failure"
        let suggedtedFixes = "mock suggested"
        let error = DebuggableMock()
        error.stubbedIdentifier = identifier
        error.stubbedPossibleCauses = [possibleCauses]
        error.stubbedReason = reason
        error.stubbedSuggestedFixes = [suggedtedFixes]

        let test = "⚠️ [DebuggableMock.\(identifier): \(reason)] [Possible causes: \(possibleCauses)] [Suggested fixes: \(suggedtedFixes)]"
        XCTAssertEqual(error.errorDescription, test)
    }

    func testFailureReason() {
        XCTAssertEqual(TestError.empty.failureReason, "empty failure")
    }

    func testRecoverySuggestion() {
        XCTAssertEqual(TestError.empty.recoverySuggestion, "empty suggested")
    }

    func testHelpAnchor() {
        XCTAssertEqual(TestError.empty.helpAnchor, "https://doc.github.com")
    }

    func testPossibleCauses_2() {
        // Test on `TestError`
        XCTAssertEqual(TestShortError.empty.possibleCauses, [])
    }

    func testSuggestedFixes_2() {
        // Test on `TestError`
        XCTAssertEqual(TestShortError.empty.suggestedFixes, [])
    }

    func testDocumentationLinks_2() {
        // Test on `TestError`
        XCTAssertEqual(TestShortError.empty.documentationLinks, [])
    }

    func testStackOverflowQuestions_2() {
        // Test on `TestError`
        XCTAssertEqual(TestShortError.empty.stackOverflowQuestions, [])
    }

    func testGitHubIssues_2() {
        // Test on `TestError`
        XCTAssertEqual(TestShortError.empty.gitHubIssues, [])
    }

    static var allTests = [
        ("testReadableName", testReadableName),
        ("testTypeIdentifier", testTypeIdentifier),
        ("testIdentifier", testIdentifier),
    ]
}
