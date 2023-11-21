import SwiftUI
import XCTest

final class xUIDebounceTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testActionButtons() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let labels = [
            "Random Fact",
            "Repeat Last",
            "Pause / Play",
        ]

        for label in labels {
            let button = app.staticTexts[label]
            XCTAssertTrue(button.exists)
        }
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements

        elementsQuery/*@START_MENU_TOKEN@*/ .images["random fact"]/*[[".buttons[\"Random Fact\"].images[\"random fact\"]",".images[\"random fact\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
        sleep(10)

        let pausePlayImage = elementsQuery/*@START_MENU_TOKEN@*/ .images["pause play"]/*[[".buttons[\"Pause \/ Play\"].images[\"pause play\"]",".images[\"pause play\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        var i = 0;
        
        while(i < 50) {
            pausePlayImage.tap()
            i += 1
            sleep(UInt32(0.1))
        }

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
