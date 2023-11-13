import CryptoSwift
import DeviceCheck
import Foundation
import Sentry
import SwiftyJSON

class AppConfig {
    // Shared singleton instance
    static let shared = AppConfig()
    private var openaiKey: String?
    private var relayUrl: String?
    private var sharedEncryptionSecret: String?
    private var sharedEncryptionIV: String?
    private var deepgramKey: String?
    private var minimumSignificantEvents: Int?
    private var daysBetweenPrompts: Int?
    private var sentryDSN: String?
    
    private var themeName: String?

    init() {
        self.loadConfiguration()
        if openaiKey != nil && openaiKey != "" {
            // if a local key is assigned (for debugging), do not request from server
            return
        }
        Task {
            await self.requestOpenAIKey()
        }
    }
    
    private func decrypt(base64EncodedEncryptedKey: String) throws -> String {
        let encryptedKey = Data(base64Encoded: base64EncodedEncryptedKey)
        guard let encryptedKey = encryptedKey else {
            throw NSError(domain: "Invalid encoded encrypted key", code: -1)
        }
        
        let iv = [UInt8](self.sharedEncryptionIV!.data(using: .utf8)!.sha256()[0..<16])
        let sharedKey = [UInt8](self.sharedEncryptionSecret!.data(using: .utf8)!.sha256()[0..<32])
        let aes = try AES(key: sharedKey, blockMode: CBC(iv: iv))
        let dBytes = try aes.decrypt(encryptedKey.bytes)
        let dKey = String(data: Data(dBytes), encoding: .utf8)
        guard let key = dKey else {
            throw NSError(domain: "Key is not a string", code: -3)
        }
        return key
    }
    
    private func requestOpenAIKey() async {
        guard let relayUrl = self.relayUrl else {
            print("Relay URL not set")
            SentrySDK.capture(message: "Relay URL not set")
            return
        }
        let s = URLSession(configuration: .default)
        guard let url = URL(string: "\(relayUrl)/key") else {
            print("Invalid Relay URL")
            SentrySDK.capture(message: "Invalid Relay URL")
            return
        }
        var token = ""
        do {
            let d = try await DCDevice.current.generateToken()
            print("token", d)
            token = d.base64EncodedString()
        } catch {
            SentrySDK.capture(message: "Error generating device token")
            print(error)
            return
        }
        var r = URLRequest(url: url)
        r.setValue(token, forHTTPHeaderField: "X-DEVICE-TOKEN")
        let t = s.dataTask(with: r) { data, _, err in
            if let err = err {
                print("[AppConfig][requestOpenAIKey] cannot get key", err)
                SentrySDK.capture(message: "Cannot get key. Error: \(err)")
                return
            }
            do {
                let res = try JSON(data: data!)
                let eeKey = res["key"].string
                guard let eeKey = eeKey else {
                    print("[AppConfig][requestOpenAIKey] response has no key", res)
                    SentrySDK.capture(message: "[AppConfig][requestOpenAIKey]  response has no key")
                    return
                }
                // TODO: decrypt key
                let key = try self.decrypt(base64EncodedEncryptedKey: eeKey)
                self.openaiKey = key
                print("Got key", key)
            } catch {
                print("[AppConfig][requestOpenAIKey] error processing key response", error)
                SentrySDK.capture(message: "[AppConfig][requestOpenAIKey] error processing key response \(error)")
            }
        }
        t.resume()
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
            
            self.sentryDSN = dictionary["SENTRY_DSN"]

            self.sharedEncryptionSecret = dictionary["SHARED_ENCRYPTION_SECRET"]
            self.sharedEncryptionIV = dictionary["SHARED_ENCRYPTION_IV"]
            self.relayUrl = dictionary["RELAY_URL"]

            self.themeName = dictionary["THEME_NAME"]
            self.deepgramKey = dictionary["DEEPGRAM_KEY"]
            self.openaiKey = dictionary["API_KEY"]
            
            // Convert the string values to Int
            if let eventsString = dictionary["MINIMUM_SIGNIFICANT_EVENTS"],
               let events = Int(eventsString)
            {
                self.minimumSignificantEvents = events
            }
            
            if let daysString = dictionary["DAYS_BETWEEN_PROMPTS"],
               let days = Int(daysString)
            {
                self.daysBetweenPrompts = days
            }
            
        } catch {
            SentrySDK.capture(message: "Error starting audio engine: \(error.localizedDescription)")
            fatalError(error.localizedDescription)
        }
    }
    
    func getOpenAIKey() -> String? {
        return self.openaiKey
    }
    
    func getSentryDSN() -> String? {
        return self.sentryDSN
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
