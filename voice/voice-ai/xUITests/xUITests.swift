//
//  xUITests.swift
//  xUITests
//
//  Created by Aaron Li on 10/13/23.
//

import XCTest
import SwiftUI

struct GeometryProxyMock: GeometryProxy {
    var size: CGSize {
        return CGSize(width: 320, height: 480)
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
    
    func testGridButton() throws {
        
        
        let buttonReset = ButtonData(label: "New Session", image: "new session", action: .reset)
        let buttonSkip = ButtonData(label: "Skip 5 Seconds", image: "skip 5 seconds", action: .skip)
        let buttonRandom = ButtonData(label: "Random Fact", image: "random fact", action: .randomFact)
        let buttonSpeak = ButtonData(label: "Press to Speak", image: "press to speak", action: .speak)
        let buttonRepeat = ButtonData(label: "Repeat Last", image: "repeat last", action: .repeatLast)
        let buttonPlay = ButtonData(label: "Pause / Play", image: "pause play", action: .play)
        
        
        let geometry = GeometryProxyMock()
        let button = GridButton(button: buttonReset, geometry: geometry, foregroundColor: .black) {
            
        }
        
        
        
//        let buttonData = ButtonData(label: "Pause", image: "pl", action: .reset);
//        let geometry = GeometryProxyMock()
//        let button = GridButton(button: buttonData, geometry: geometry, foregroundColor: .black, action: buttonData.action)
//        
//        let buttonData = ButtonData(label: "New Session", image: "new session", action: .reset);
//        let geometry = GeometryProxyMock()
//        let button = GridButton(button: buttonData, geometry: geometry, foregroundColor: .black, action: buttonData.action)
        
        XCTAssertEqual(button.action, buttonData.action)
    }

    func testActionButtons() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let labels = [
            "New Session",
            "Skip 5 Seconds",
            "Random Fact",
            "Press to Speak",
            "Repeat Last",
            "Pause / Play",
        ]
        
        for label in labels {
            let button = app.staticTexts[label]
            XCTAssertTrue(button.exists)
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
