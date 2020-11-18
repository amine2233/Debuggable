#if !canImport(ObjectiveC)
import XCTest

public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DebuggableTests.allTests),
    ]
}
#endif
