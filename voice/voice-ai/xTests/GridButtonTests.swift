import XCTest
import SwiftUI
import SnapshotTesting
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
    
    func testButtonParamsInverted() {
        let buttonData = ButtonData(label: "Tap to Speak", pressedLabel: "Tap to SEND", image: "\(theme.name) - square", action: .speak, testId: "button-tapToSpeak")
        
        let button = GridButton(currentTheme: theme, button: buttonData, foregroundColor: Color.black, active: false, isPressed: false, action: { eventType in }).frame(width: 250, height: 250)
        assertSnapshot(matching: button, as: .image, named: "gridbutton-normal")
        
        let buttonActive = GridButton(currentTheme: theme, button: buttonData, foregroundColor: Color.black, active: true, isPressed: false, action: { eventType in }).frame(width: 250, height: 250)
        assertSnapshot(matching: buttonActive, as: .image, named: "gridbutton-active")
        
        let buttonActivePressed = GridButton(currentTheme: theme, button: buttonData, foregroundColor: Color.black, active: true, isPressed: true, action: { eventType in
            
        }).frame(width: 250, height: 250)
        assertSnapshot(matching: buttonActivePressed, as: .image, named: "gridbutton-active-and-pressed")
        
        let buttonPressed = GridButton(currentTheme: theme, button: buttonData, foregroundColor: Color.black, active: false, isPressed: true, action: { eventType in
            
        }).frame(width: 250, height: 250)
        assertSnapshot(matching: buttonPressed, as: .image, named: "gridbutton-pressed")
    }
    
    func testButtonParams() {
        let buttonData = ButtonData(label: "Pause / Play", image: "\(theme.name) - pause play", pressedImage: "\(theme.name) - play", action: .play, testId: "button-playPause")
        
        let button = GridButton(currentTheme: theme, button: buttonData, foregroundColor: Color.black, active: false, isPressed: false, action: { eventType in }).frame(width: 250, height: 250)
        assertSnapshot(matching: button, as: .image, named: "gridbutton-normal")
        
        let buttonActive = GridButton(currentTheme: theme, button: buttonData, foregroundColor: Color.black, active: true, isPressed: false, action: { eventType in }).frame(width: 250, height: 250)
        assertSnapshot(matching: buttonActive, as: .image, named: "gridbutton-active")
        
        
        let buttonActivePressed = GridButton(currentTheme: theme, button: buttonData, foregroundColor: Color.black, active: true, isPressed: true, action: { eventType in
            
        }).frame(width: 250, height: 250)
        assertSnapshot(matching: buttonActivePressed, as: .image, named: "gridbutton-active-and-pressed")
        
        let buttonPressed = GridButton(currentTheme: theme, button: buttonData, foregroundColor: Color.black, active: false, isPressed: true, action: { eventType in
            
        }).frame(width: 250, height: 250)
        assertSnapshot(matching: buttonPressed, as: .image, named: "gridbutton-pressed")
    }
    
    
}
