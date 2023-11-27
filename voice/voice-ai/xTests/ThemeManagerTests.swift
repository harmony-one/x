import XCTest
@testable import Voice_AI
import Foundation
import SwiftUI

class ThemeTests: XCTestCase {
    func testDefaultThemeInitialization() {
        let theme = Theme()
        XCTAssertEqual(theme.name, "defaultTheme")
        XCTAssertEqual(theme.bodyTextColor, Color(hex: 0x552233))
        XCTAssertEqual(theme.buttonActiveColor, Color(hex: 0x0088B0))
        XCTAssertEqual(theme.buttonDefaultColor, Color(hex: 0xDDF6FF))
        XCTAssertEqual(theme.fontActiveColor, Color(hex: 0x0088B0))
    }

    func testBlackredThemeInitialization() {
        let theme = Theme()
        XCTAssertEqual(theme.name, "blackredTheme")
        XCTAssertEqual(theme.bodyTextColor, Color(hex: 0xD7303A))
        XCTAssertEqual(theme.buttonActiveColor, Color(hex: 0xD7303A))
        XCTAssertEqual(theme.buttonDefaultColor, Color(hex: 0x1E1E1E))
        XCTAssertEqual(theme.fontActiveColor, Color.black)
    }

    func testFromString() {
        let blackRedTheme = AppThemeSettings.fromString("blackredTheme")
        XCTAssertEqual(blackRedTheme.name, "blackredTheme")

        let defaultTheme = AppThemeSettings.fromString("defaultTheme")
        XCTAssertEqual(defaultTheme.name, "defaultTheme")
    }
}
