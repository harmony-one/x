//
//  AppConfig.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 18/10/23.
//

import Foundation

class AppConfig {
    
    // Shared singleton instance
    static let shared = AppConfig()
    private var apiKey: String?
    private var deepgramKey: String?
    private var minimumSignificantEvents: Int?
    private var daysBetweenPrompts: Int?
    
    private var themeName: String?

    init() {
        loadConfiguration()
    }
    
    private func loadConfiguration() {
        guard let path = Bundle.main.path(forResource: "AppConfig", ofType: "plist") else {
            fatalError("Unable to locate plist file")
        }
        
        let fileURL = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: fileURL)
            guard let dictionary = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: String] else {
                fatalError("Unable to convert plist into dictionary")
            }
            
            self.apiKey = dictionary["API_KEY"]
            
            self.themeName = dictionary["THEME_NAME"]
            // self.deepgramKey = dictionary["DEEPGRAM_KEY"]
            
            // Convert the string values to Int
            if let eventsString = dictionary["MINIMUM_SIGNIFICANT_EVENTS"],
               let events = Int(eventsString) {
                self.minimumSignificantEvents = events
            }
            
            if let daysString = dictionary["DAYS_BETWEEN_PROMPTS"],
               let days = Int(daysString) {
                self.daysBetweenPrompts = days
            }
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getAPIKey() -> String? {
        return self.apiKey
    }
    
    func getDeepgramKey() -> String? {
        return self.deepgramKey
    }
    
    // Getter methods for the review prompt configuration
    func getMinimumSignificantEvents() -> Int? {
        return self.minimumSignificantEvents
    }
    
    func getDaysBetweenPrompts() -> Int? {
        return self.daysBetweenPrompts
    }
    func getThemeName() -> String {
        return self.themeName ?? AppThemeSettings.blackredTheme.settings.name // AppThemeSettings.defaultTheme.settings.name 
    }
}
