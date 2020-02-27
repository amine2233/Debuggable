import XCTest

import DebuggableTests

var tests = [XCTestCaseEntry]()
tests += DebuggableTests.allTests()
XCTMain(tests)
