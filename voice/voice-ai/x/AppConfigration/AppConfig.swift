//
//  AppConfig.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 18/10/23.
//

import Foundation

class AppConfig {
    
    private var apiKey: String?
    private var deepgramKey: String?

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

            // self.deepgramKey = dictionary["DEEPGRAM_KEY"]
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
}
