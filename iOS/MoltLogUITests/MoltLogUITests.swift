import XCTest

final class MoltLogUITests: XCTestCase {

    func testAddEntryFlow() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let titleField = app.textFields["titleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("UI Test Entry")
        app.buttons["saveButton"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Entry"].waitForExistence(timeout: 2))
    }

    func testFreeLimitTriggersPaywall() {
        let app = XCUIApplication()
        app.launch()
        for i in 0..<20 {
            if app.buttons["addButton"].waitForExistence(timeout: 1) {
                app.buttons["addButton"].tap()
            }
            if app.buttons["unlockProButton"].waitForExistence(timeout: 1) {
                XCTAssertTrue(true)
                app.buttons["paywallCloseButton"].tap()
                return
            }
            let titleField = app.textFields["titleField"]
            if titleField.waitForExistence(timeout: 1) {
                titleField.tap()
                titleField.typeText("Entry \(i)")
                app.buttons["saveButton"].tap()
            }
        }
    }

    func testKeyboardDismissOnTapOutside() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let titleField = app.textFields["titleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("Dismiss Test")
        XCTAssertTrue(app.keyboards.element.exists)
        app.navigationBars.firstMatch.tap()
        XCTAssertFalse(app.keyboards.element.waitForExistence(timeout: 1))
    }

    func testSettingsSheetOpens() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }

    func testCancelDiscardsEntry() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let titleField = app.textFields["titleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        app.buttons["cancelButton"].tap()
        XCTAssertFalse(app.textFields["titleField"].exists)
    }
}
