import XCTest
@testable import abjc_core

final class abjc_coreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(abjc_core().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
