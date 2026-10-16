import XCTest

final class KidsLearnTVUITests: XCTestCase {
    func testRemoteCanOpenMenuAndQuiz() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.buttons["Start Learning"].waitForExistence(timeout: 10))
        XCUIRemote.shared.press(.select)
        XCTAssertTrue(app.staticTexts["Choose Your Learning Adventure!"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.buttons["Play Mixed Quiz"].exists)
    }
}
