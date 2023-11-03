//
//  ThemeManager.swift
//  Voice AI
//
//  Created by Francisco Egloff on 3/11/23.
//

import Foundation

@objc protocol Themable {
    func applyTheme(_ theme: AppTheme)
}

//struct ThemeManager {
//    private var themables: NSHashTable<Themable> = NSHashTable<Themable>.weakObjects()
//    var theme: AppTheme {
//        didSet {
//            guard theme != oldValue else { return }
//            apply()
//        }
//    }
//
//    init(defaultTheme: AppTheme) {
//        self.theme = defaultTheme
//    }
//
//    mutating func register(_ themable: Themable) {
//        themables.add(themable)
//        themable.applyTheme(theme)
//    }
//
//    private mutating func apply() {
//        themables.allObjects.forEach {
//            $0.applyTheme(theme)
//        }
//    }
//}


final class ThemeManager {
    private var themables = NSHashTable<Themable>
        .weakObjects()

    var theme: AppTheme {
        didSet {
            guard theme != oldValue else { return; }
            apply()
        }
    }

    private static var instance: ThemeManager?

    static var shared: ThemeManager {
        if instance == nil {
            instance = ThemeManager(defaultTheme: .base)
        }
        return instance!
    }

    private init(defaultTheme: AppTheme) {
        self.theme = defaultTheme
    }

    func register(_ themable: Themable) {
        themables.add(themable)
        themable.applyTheme(theme)
    }

    private func apply() {
        themables.allObjects.forEach {
            $0.applyTheme(theme)
        }
    }
}
