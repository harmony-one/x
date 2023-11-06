//
//  xUITests.swift
//  xUITests
//
//  Created by Aaron Li on 10/13/23.
//

import XCTest
import SwiftUI

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

    func testActionButtons() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let labels = [
            "New Session",
            "Skip 5 Seconds",
            "Random Fact",
            "Press & Hold",
            "Repeat Last",
            "Pause / Play",
        ]
        
        for label in labels {
            let button = app.staticTexts[label]
            XCTAssertTrue(button.exists)
        }
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        elementsQuery/*@START_MENU_TOKEN@*/.images["press to speak"].press(forDuration: 5.1);/*[[".buttons[\"Press to Speak\"].images[\"press to speak\"]",".tap()",".press(forDuration: 5.1);",".images[\"press to speak\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        
        let pausePlayImage = elementsQuery/*@START_MENU_TOKEN@*/.images["pause play"]/*[[".buttons[\"Pause \/ Play\"].images[\"pause play\"]",".images[\"pause play\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pausePlayImage.tap()
        elementsQuery/*@START_MENU_TOKEN@*/.images["random fact"]/*[[".buttons[\"Random Fact\"].images[\"random fact\"]",".images[\"random fact\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        sleep(10)
        pausePlayImage.tap()
        sleep(2)
        pausePlayImage/*@START_MENU_TOKEN@*/.press(forDuration: 0.5);/*[[".tap()",".press(forDuration: 0.5);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        elementsQuery/*@START_MENU_TOKEN@*/.images["new session"].press(forDuration: 0.6);/*[[".buttons[\"New Session\"].images[\"new session\"]",".tap()",".press(forDuration: 0.6);",".images[\"new session\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        pausePlayImage/*@START_MENU_TOKEN@*/.press(forDuration: 1.3);/*[[".tap()",".press(forDuration: 1.3);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

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
