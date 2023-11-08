//
//  AppConfig.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 18/10/23.
//

import Foundation
import Sentry

class AppConfig {
    
    private var apiKey: String?
    private var deepgramKey: String?
    private var sentryDSN: String?

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
            
            self.sentryDSN = dictionary["SENTRY_DSN"]

            // self.deepgramKey = dictionary["DEEPGRAM_KEY"]
        } catch {
            SentrySDK.capture(message: "Error starting audio engine: \(error.localizedDescription)")
            fatalError(error.localizedDescription)
        }
    }

    func getAPIKey() -> String? {
        return self.apiKey
    }
    
    func getSentryDSN() -> String? {
        return self.sentryDSN
    }
    
    func getDeepgramKey() -> String? {
        return self.deepgramKey
    }
}
