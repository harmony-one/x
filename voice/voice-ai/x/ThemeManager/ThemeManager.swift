//
//  ThemeManager.swift
//  Voice AI
//
//  Created by Francisco Egloff on 3/11/23.
//

import Foundation
import SwiftUI


struct ThemeSettings {
    let name: String
    let bodyTextColor: Color
    let buttonActiveColor: Color
    let buttonDefaultColor: Color
    let fontActiveColor: Color
 }

enum AppThemeSettings {
    case blackredTheme
    case defaultTheme
    var settings: ThemeSettings {
         switch self {
         case .blackredTheme: return ThemeSettings.blackredTheme
         case .defaultTheme: return ThemeSettings.defaultTheme
         }
    }
    static func fromString(_ name: String) -> ThemeSettings {
        switch name {
        case "blackredTheme": return .blackredTheme
        case "defaultTheme": return .defaultTheme
        default: return .defaultTheme
        }
    }
 }

class Theme:ObservableObject {
    @Published var name: String //ThemeName used for button icons (assets.xcassets)
    @Published var bodyTextColor: Color
    @Published var buttonActiveColor: Color
    @Published var buttonDefaultColor: Color
    @Published var fontActiveColor: Color
    
    init() {
        let defaultTheme = AppThemeSettings.defaultTheme.settings
        self.name = defaultTheme.name
        self.bodyTextColor = defaultTheme.bodyTextColor
        self.buttonActiveColor = defaultTheme.buttonActiveColor
        self.buttonDefaultColor = defaultTheme.buttonDefaultColor
        self.fontActiveColor = defaultTheme.fontActiveColor
    }
    
    init(theme: ThemeSettings) {
        self.name = theme.name
        self.bodyTextColor = theme.bodyTextColor
        self.buttonActiveColor = theme.buttonActiveColor
        self.buttonDefaultColor = theme.buttonDefaultColor
        self.fontActiveColor = theme.fontActiveColor
    }
    
    func setTheme(theme: ThemeSettings) {
        self.name = theme.name
        self.bodyTextColor = theme.bodyTextColor
        self.buttonActiveColor = theme.buttonActiveColor
        self.buttonDefaultColor = theme.buttonDefaultColor
        self.fontActiveColor = theme.fontActiveColor
    }
}



