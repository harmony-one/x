//
//  ThemeManager.swift
//  Voice AI
//
//  Created by Francisco Egloff on 3/11/23.
//

import Foundation
import SwiftUI


enum ThemeName {
    case herTheme
    case darkTheme
    case defaultTheme

    static func fromString(_ name: String) -> ThemeName {
        switch name {
        case "herTheme": return .herTheme
        case "darkTheme": return .darkTheme
        case "defaultTheme": return .defaultTheme
        default: return .defaultTheme
        }
    }
}

class Theme:ObservableObject {
    @Published var name: ThemeName
    @Published var brandColor: Color
    @Published var backgroundColor: Color
    @Published var contrastBackgroundColor: Color
    @Published var secondaryColor: Color
    @Published var shadowColor: Color
    @Published var bodyTextColor: Color
    @Published var buttonActiveColor: Color
    @Published var buttonDefaultColor: Color

    init(name: ThemeName, brandColor: Color, backgroundColor: Color, contrastBackgroundColor: Color, secondaryColor:Color, shadowColor:Color, bodyTextColor:Color, buttonActiveColor: Color, buttonDefaultColor: Color){
        self.name = name
        self.brandColor = brandColor
        self.backgroundColor = backgroundColor
        self.contrastBackgroundColor = contrastBackgroundColor
        self.secondaryColor = secondaryColor
        self.shadowColor = shadowColor
        self.bodyTextColor = bodyTextColor
        self.buttonActiveColor = buttonActiveColor
        self.buttonDefaultColor = buttonDefaultColor
    }
    
    init() {
        let themeManager = ThemeManager()
        let theme = themeManager.getThemeByName(ThemeName.defaultTheme)
        self.name = theme.name
        self.brandColor = theme.brandColor
        self.backgroundColor = theme.backgroundColor
        self.contrastBackgroundColor = theme.contrastBackgroundColor
        self.secondaryColor = theme.secondaryColor
        self.shadowColor = theme.shadowColor
        self.bodyTextColor = theme.bodyTextColor
        self.buttonActiveColor = theme.buttonActiveColor
        self.buttonDefaultColor = theme.buttonDefaultColor
    }
}

struct ThemeManager {
    var themes: [Theme] = [
        Theme(
            name: .defaultTheme,
            brandColor: Color(hex: 0x552233),
            backgroundColor: Color(hex: 0x552233),
            contrastBackgroundColor: Color(hex: 0x552233),
            secondaryColor: Color(hex: 0x552233),
            shadowColor: Color(hex: 0x552233),
            bodyTextColor: Color(hex: 0x552233),
            buttonActiveColor: Color(hex: 0x0088B0),
            buttonDefaultColor: Color(hex: 0xDDF6FF)
        ),
        
        Theme(
            name: .herTheme,
            brandColor: Color(hex: 0x552233),
            backgroundColor: Color(hex: 0x552233),
            contrastBackgroundColor: Color(hex: 0x552233),
            secondaryColor: Color(hex: 0x552233),
            shadowColor: Color(hex: 0x552233),
            bodyTextColor: Color(hex: 0x552233),
            buttonActiveColor: Color(hex: 0xb02c00),
            buttonDefaultColor: Color(hex: 0xc9785d)
        )
    ]
    
    func getThemeByName(_ name: ThemeName) -> Theme {
        return themes.first { $0.name == name } ?? themes[0]
    }
}
