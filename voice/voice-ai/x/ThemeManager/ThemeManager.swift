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
    case blackredTheme
    case defaultTheme

    static func fromString(_ name: String) -> ThemeName {
        switch name {
        case "herTheme": return .herTheme
        case "blackredTheme": return .blackredTheme
        case "defaultTheme": return .defaultTheme
        default: return .defaultTheme
        }
    }
}

class Theme:ObservableObject {
    @Published var name: ThemeName
    @Published var bodyTextColor: Color
    @Published var buttonActiveColor: Color
    @Published var buttonDefaultColor: Color

    init(name: ThemeName, bodyTextColor:Color, buttonActiveColor: Color, buttonDefaultColor: Color){
        self.name = name
        self.bodyTextColor = bodyTextColor
        self.buttonActiveColor = buttonActiveColor
        self.buttonDefaultColor = buttonDefaultColor
    }
    
    init() {
        let themeManager = ThemeManager()
        let theme = themeManager.getThemeByName(ThemeName.defaultTheme)
        self.name = theme.name
        self.bodyTextColor = theme.bodyTextColor
        self.buttonActiveColor = theme.buttonActiveColor
        self.buttonDefaultColor = theme.buttonDefaultColor
    }
}

struct ThemeManager {
    var themes: [Theme] = [
        Theme(
            name: .defaultTheme,
            bodyTextColor: Color(hex: 0x552233),
            buttonActiveColor: Color(hex: 0x0088B0),
            buttonDefaultColor: Color(hex: 0xDDF6FF)
        ),
        
        Theme(
            name: .blackredTheme,
            bodyTextColor: Color(hex: 0x552233),
            buttonActiveColor: Color(hex: 0xb02c00),
            buttonDefaultColor: Color(hex: 0xc9785d)
        )
    ]
    
    func getThemeByName(_ name: ThemeName) -> Theme {
        return themes.first { $0.name == name } ?? themes[0]
    }
}

