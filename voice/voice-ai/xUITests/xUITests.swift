import SwiftUI
import XCTest

struct GeometryProxyMock {
    var size: CGSize

    init(size: CGSize) {
        self.size = size
    }
}

final class xUITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPlayPause() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        let buttonSurpriseMe = app.buttons["button-surpriseMe"]
        let buttonPlay = app.buttons["button-playPause"]
        let playImage = "blackredTheme - play"
        let pauseImage = "blackredTheme - pause play"
        
        // start
        buttonSurpriseMe.tap()
        
        sleep(5)

        // pause
        buttonPlay.tap()
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: buttonPlay, handler: nil)
        waitForExpectations(timeout: 2, handler: nil)

        // play
        buttonPlay.tap()

        XCTAssertFalse(buttonPlay.images[playImage].exists)
        XCTAssertTrue(buttonPlay.images[pauseImage].exists)
    }
    
    func testMore() throws {
        let app = XCUIApplication()
        app.launch()

        let buttonMore = app.buttons["button-more"]
        sleep(1)
        
        buttonMore.tap()
        XCTAssertTrue(app.buttons["button-more"].exists)
    }
    
    func testNewSession() throws {
        let app = XCUIApplication()
        app.launch()
        
        let buttonSurpriseMe = app.buttons["button-surpriseMe"]
        let buttonPlay = app.buttons["button-playPause"]
        let buttonMore = app.buttons["button-more"]
        let buttonNewSession = app.buttons["button-newSession"]
        let playImage = "blackredTheme - play"
        let pauseImage = "blackredTheme - pause play"
        
        // run surprise me
        buttonSurpriseMe.tap()
        
        sleep(5)
        
        // pause audio
        buttonPlay.tap()
        
        // run new session
        buttonNewSession.tap();
        
        sleep(2)
        
        // expect: play pause button - has pause icon
        XCTAssertTrue(buttonPlay.images[pauseImage].exists)
    }

    func testActionButtonsLabels() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let labels = [
            "New Session",
            "Tap to Speak",
            "Surprise ME!",
            "Press & Hold",
            "More Actions",
            "Pause / Play",
        ]

        for label in labels {
            let button = app.staticTexts[label]
            XCTAssertTrue(button.exists)
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func openSettingsView() -> some XCUIApplication {
        let app = XCUIApplication()
        app.launch()

        let pausePlayButton = app.staticTexts["More Actions"]
        XCTAssertTrue(pausePlayButton.exists)

        let buttonMore = app.buttons["button-more"]
        XCTAssertTrue(buttonMore.exists)
    
        buttonMore.tap()
        
        sleep(1)
        return app
    }
    
    func testSettingsViewCancel() throws {
        let app = self.openSettingsView()

        let cancel = app.buttons["Cancel"]
        XCTAssertTrue(cancel.exists)
        cancel.tap()

        sleep(1)
        XCTAssertFalse(app.buttons["Cancel"].exists)
    }
    
    func testSettingsViewPurchase() throws {
        let app = self.openSettingsView()
        let button = app.buttons["Purchase"]
        XCTAssertTrue(button.exists)
    }
    
    func testSettingsViewShare() throws {
        let app = self.openSettingsView()
        let button = app.buttons["Share"]
        XCTAssertTrue(button.exists)
    }
    
    func testSettingsViewTweet() throws {
        let app = self.openSettingsView()
        let button = app.buttons["Tweet"]
        XCTAssertTrue(button.exists)
    }
    
    func testSettingsViewSettings() throws {
        let app = self.openSettingsView()
        let button = app.buttons["System Settings"]
        XCTAssertTrue(button.exists)
    }
    
    func testSettingsViewTranscript() throws {
        let app = self.openSettingsView()
        let button = app.buttons["Save Transcript"]
        XCTAssertTrue(button.exists)
    }
}
