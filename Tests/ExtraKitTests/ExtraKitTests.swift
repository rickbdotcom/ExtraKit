import XCTest
@testable import ExtraKit

final class ExtraKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ExtraKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
