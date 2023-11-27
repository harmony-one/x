import XCTest
import SwiftUI
@testable import Voice_AI

struct Configuration {
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

    func testDetermineBackgroundColor() {
        let buttonStyle = PressEffectButtonStyle(theme: theme)
        var configuration = Configuration(isPressed: false)

//        // Test with isPressed = false
//        XCTAssertEqual(buttonStyle.determineBackgroundColor(configuration: configuration), theme.buttonDefaultColor)
//
//        // Test with isPressed = true
//        configuration.isPressed = true
//        XCTAssertEqual(buttonStyle.determineBackgroundColor(configuration: configuration), theme.buttonActiveColor)
    }

    func testDetermineForegroundColor() {
        let buttonStyle = PressEffectButtonStyle(theme: theme)
        var configuration = Configuration(isPressed: false)
    }

    func testButtonAppearance() {
        let buttonStyle = PressEffectButtonStyle(theme: theme, background: backgroundColor)
        let configuration = Configuration(isPressed: false)
    }

    override func tearDown() {
        backgroundColor = nil
        super.tearDown()
    }
}
