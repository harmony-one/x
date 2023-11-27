import XCTest
import SwiftUI
@testable import Voice_AI

class GridButtonTests: XCTestCase {
    var theme: Theme = .init()
    var buttonData: ButtonData!
    var actionTriggered: EventType?

    override func setUp() {
        super.setUp()
        // Initialize common variables for the tests
        let config = AppConfig.shared
        let themeSettings = AppThemeSettings.fromString(config.getThemeName())
        
        theme.setTheme(theme: themeSettings)

        let themePrefix = theme.name
        buttonData = ButtonData(label: "Tap to Speak", pressedLabel: "Tap to SEND", image: "\(themePrefix) - square", action: .speak, testId: "button-tapToSpeak")
    }

    func testOnDragStartAndEnd() {
        let gridButton =   GridButton(currentTheme: theme, button: buttonData, foregroundColor: Color.black, action: { eventType in
            self.actionTriggered = eventType
        })

        XCTAssertNil(actionTriggered)

        gridButton.onDragStart()
        XCTAssertEqual(actionTriggered, .onStart)

        gridButton.onDragEnded()
        XCTAssertEqual(actionTriggered, .onEnd)
    }
}
