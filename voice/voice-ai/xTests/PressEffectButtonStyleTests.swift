import XCTest
import SwiftUI
@testable import Voice_AI

struct CustomConfiguration {
    var isPressed: Bool
}

class PressEffectButtonStyleTests: XCTestCase {
    var theme: Theme = .init()
    var backgroundColor: Color!

    override func setUp() {
        super.setUp()
        let config = AppConfig.shared
        let themeSettings = AppThemeSettings.fromString(config.getThemeName())
        theme.setTheme(theme: themeSettings)
        backgroundColor = Color.red
    }

    func testInitializer() {
        let buttonStyle = PressEffectButtonStyle(theme: theme, background: backgroundColor, active: true, invertColors: true, isButtonEnabled: false)

        XCTAssertEqual(buttonStyle.background, backgroundColor)
        XCTAssertTrue(buttonStyle.active)
        XCTAssertTrue(buttonStyle.invertColors)
        XCTAssertFalse(buttonStyle.isButtonEnabled)
    }
    
    func testDetermineBackgroundColorActiveTrue() {
        let buttonStyle = PressEffectButtonStyle(theme: theme, background: backgroundColor, active: true, invertColors: false, isButtonEnabled: false)

        // Test with active = true
        XCTAssertTrue(buttonStyle.active)
        XCTAssertFalse(buttonStyle.invertColors)
        XCTAssertEqual(buttonStyle.determineBackgroundColor(configuration: nil), theme.buttonActiveColor)
    }
    
    func testDetermineBackgroundColorActiveFalse() {
        let buttonStyle = PressEffectButtonStyle(theme: theme, background: backgroundColor, active: false, invertColors: false, isButtonEnabled: false)

        // Test with active = true
        XCTAssertFalse(buttonStyle.active)
        XCTAssertFalse(buttonStyle.invertColors)
        XCTAssertEqual(buttonStyle.determineBackgroundColor(configuration: nil), theme.buttonDefaultColor)
    }

    override func tearDown() {
        backgroundColor = nil
        super.tearDown()
    }
}
