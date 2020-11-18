import XCTest

import DebuggableTests

var tests = [XCTestCaseEntry]()
tests += DebuggableTests.__allTests()

XCTMain(tests)
