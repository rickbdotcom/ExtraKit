import UIKit
import XCTest
import ExtraKit

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
		let button = UIButton()
		button.on(.touchUpInside) { (b: UIButton) in
			print("touch up inside")
		}g
        XCTAssert(true, "Pass")
    }
}
