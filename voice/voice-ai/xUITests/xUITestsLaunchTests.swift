import XCTest

final class xUITestsLaunchTests: XCTestCase {
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testActionButtons() throws {
        let app = XCUIApplication()
        app.launch()

        let buttonLabels = [
            "New Session",
            "Tap to Speak",
            "Surprise ME!",
            "Press & Hold",
            "More Actions",
            "Pause / Play",
        ]

        for label in buttonLabels {
            let button = app.staticTexts[label]
            XCTAssertTrue(button.exists)
        }

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
