import Foundation
import SwiftUI

extension ThemeSettings {
    static let defaultTheme = ThemeSettings(
        name: "defaultTheme",
        bodyTextColor: Color(hex: 0x552233),
        buttonActiveColor: Color(hex: 0x0088B0),
        buttonDefaultColor: Color(hex: 0xDDF6FF),
        fontActiveColor: Color(hex: 0x0088B0)
    )
    static let blackredTheme = ThemeSettings(
        name: "blackredTheme",
        bodyTextColor: Color(hex: 0xD7303A),
        buttonActiveColor: Color(hex: 0xD7303A),
        buttonDefaultColor: Color(hex: 0x1E1E1E),
        fontActiveColor: .black
    )
}
