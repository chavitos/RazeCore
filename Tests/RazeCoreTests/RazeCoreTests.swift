import XCTest
@testable import RazeCore

final class RazeCoreTests: XCTestCase {
    func testColorRedEqual() {
        let color = RazeCore.colorFromHexString("#FF0000")
        XCTAssertEqual(color, .red)
    }
    
    func testRazeColorsAreEqual() {
        let color = RazeCore.colorFromHexString("006736")
        XCTAssertEqual(color, RazeCore.razeColor)
    }
}
