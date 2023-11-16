import CryptoSwift
import DeviceCheck
import Foundation
import Sentry
import SwiftyJSON

class AppConfig {
    // Shared singleton instance
    static let shared = AppConfig()
    private var relay: RelayAuth = .init()
    private var relayBaseUrl: String?
    private var openaiBaseUrl: String?
    private var openaiKey: String?

    private var sharedEncryptionSecret: String?
    private var sharedEncryptionIV: String?
    private var deepgramKey: String?
    private var minimumSignificantEvents: Int?
    private var daysBetweenPrompts: Int?
    private var sentryDSN: String?
    private var whitelist: [String]? = []
    
    var themeName: String?

    init() {
        self.loadConfiguration()
        if self.openaiKey != nil, self.openaiKey != "" {
            // if a local key is assigned (for debugging), do not request from server
            return
        }
        Task {
            self.openaiKey = await self.relay.setup()
//            await self.requestOpenAIKey()
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
        guard let relayBaseUrl = self.relayBaseUrl else {
            print("Relay URL not set")
            SentrySDK.capture(message: "Relay URL not set")
            return
        }
        let s = URLSession(configuration: .default)
        guard let url = URL(string: "\(relayBaseUrl)/soft/key") else {
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
//                print("Got key", key)
            } catch {
                print("[AppConfig][requestOpenAIKey] error processing key response", error)
                SentrySDK.capture(message: "[AppConfig][requestOpenAIKey] error processing key response \(error)")
            }
        }
        t.resume()
    }
    
    
    public func checkWhiteList() async -> Bool  {
        guard let username = SettingsBundleHelper.getUserName() else {
            return false
        }
        
        guard let relayUrl = self.relayUrl else {
            print("Relay URL not set")
            SentrySDK.capture(message: "Relay URL not set")
            return false
        }

        guard let url = URL(string: "\(relayUrl)/whitelist") else {
            print("Invalid Relay URL")
            SentrySDK.capture(message: "Invalid Relay URL")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["username": username]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("[AppConfig][checkWhiteList] error JSONSerialization", error)
            SentrySDK.capture(message: "[AppConfig][checkWhiteList] JSONSerialization \(error)")
            return false
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let res = try JSON(data: data)
            guard let status = res["status"].bool else {
                print("[AppConfig][checkWhiteList] status false \(res)")
                return false
            }
            return status
        } catch {
            print("[AppConfig][checkWhiteList] error processing whitelist response", error)
            SentrySDK.capture(message: "[AppConfig][checkWhiteList] error processing whitelist response \(error)")
            return false
        }
    }
    
    private func loadConfiguration() {
        guard let path = Bundle.main.path(forResource: "AppConfig", ofType: "plist") else {
            fatalError("Unable to locate plist file")
        }
        
        let fileURL = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: fileURL)
            guard let dictionary = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
                fatalError("Unable to convert plist into dictionary")
            }
            
            self.sentryDSN = dictionary["SENTRY_DSN"] as? String

            self.sharedEncryptionSecret = dictionary["SHARED_ENCRYPTION_SECRET"] as? String
            self.sharedEncryptionIV = dictionary["SHARED_ENCRYPTION_IV"] as? String
            self.relayBaseUrl = dictionary["RELAY_BASE_URL"] as? String

            self.themeName = dictionary["THEME_NAME"] as? String
            self.deepgramKey = dictionary["DEEPGRAM_KEY"] as? String
            self.openaiKey = dictionary["API_KEY"] as? String
            self.openaiBaseUrl = dictionary["OPENAI_BASE_URL"] as? String
            
            // Convert the string values to Int
            if let eventsString = dictionary["MINIMUM_SIGNIFICANT_EVENTS"] as? String,
               let events = Int(eventsString)
            {
                self.minimumSignificantEvents = events
            }
            
            if let daysString = dictionary["DAYS_BETWEEN_PROMPTS"] as? String,
               let days = Int(daysString)
            {
                self.daysBetweenPrompts = days
            }
            
            if let whitelistString = dictionary["WHITELIST"] as? [String] {
                self.whitelist = whitelistString
            }
            
        } catch {
            SentrySDK.capture(message: "Error starting audio engine: \(error.localizedDescription)")
            fatalError(error.localizedDescription)
        }
    }
    
    func getOpenAIKey() -> String? {
        return self.openaiKey
    }
    
    func getOpenAIBaseUrl() -> String? {
        return self.openaiBaseUrl
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

    func getSharedEncryptionSecret() -> String? {
        return self.sharedEncryptionSecret
    }
    
    func getSharedEncryptionIV() -> String? {
        return self.sharedEncryptionIV
    }
    
    func getRelayUrl() -> String? {
        return self.relayBaseUrl
    }
    
    func getWhitelist() -> [String]? {
        return self.whitelist
    }
    
    func renewRelayAuth() {
        Task{
            self.openaiKey = await self.relay.refresh()
        }
    }
}
