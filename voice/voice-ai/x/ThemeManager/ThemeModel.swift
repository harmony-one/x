//
//  ThemeModel.swift
//  Voice AI
//
//  Created by Francisco Egloff on 3/11/23.
//

import Foundation
import UIKit

struct ThemeSettings {
    let appBgColor: UIColor
//    let highlightedBgColor: UIColor
    let textColor: UIColor
    let buttonActiveColor: UIColor
    let buttonDefaultColor: UIColor
}

@objc enum AppTheme: Int {
    case her
    case black
    case base
    var settings: ThemeSettings {
        switch self {
        case .her: return ThemeSettings.herTheme
        case .black: return ThemeSettings.blackTheme
        case .base: return ThemeSettings.baseTheme
        }
    }
}
