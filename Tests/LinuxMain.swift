import XCTest

import DramatisPersonaeTests
import StarWarsAPITests

var tests = [XCTestCaseEntry]()
tests += DramatisPersonaeTests.allTests()
tests += StarWarsAPITests.allTests()
XCTMain(tests)
