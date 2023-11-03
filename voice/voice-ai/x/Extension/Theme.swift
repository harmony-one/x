//
//  Theme.swift
//  Voice AI
//
//  Created by Francisco Egloff on 3/11/23.
//

import Foundation

extension ThemeSettings {
    static let baseTheme = ThemeSettings(
        appBgColor: .orange,
        textColor: .white,
        buttonActiveColor: .yellow,
        buttonDefaultColor: .purple
    )
    static let herTheme = ThemeSettings(
        appBgColor: .red,
        textColor: .white,
        buttonActiveColor: .yellow,
        buttonDefaultColor: .purple
    )
    static let blackTheme = ThemeSettings(
        appBgColor: .black,
        textColor: .white,
        buttonActiveColor: .gray,
        buttonDefaultColor: .purple
    )
}
