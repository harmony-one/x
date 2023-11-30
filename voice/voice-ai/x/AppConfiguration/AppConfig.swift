import CryptoSwift
import DeviceCheck
import Foundation
import Sentry
import SwiftyJSON

class AppConfig {
    // Shared singleton instance
    static let shared = AppConfig()
    private var relay: RelayAuth = .shared
    private var relayBaseUrl: String?
    private var relayMode: String?
    private var disableRelayLog: Bool?
    private var enableTimeLoggerPrint: Bool?
    
    private var openaiBaseUrl: String?
    private var openaiKey: String?
    
    private var sharedEncryptionSecret: String?
    private var sharedEncryptionIV: String?
    private var deepgramKey: String?
    private var minimumSignificantEvents: Int?
    private var daysBetweenPrompts: Int?
    private var sentryDSN: String?
    private var whiteLabelList: [String]?
    private var serverAPIKey: String?
    
    var themeName: String?
    
    init() {
        loadConfiguration()
        
        if openaiKey != nil, openaiKey != "" {
            // if a local key is assigned (for debugging), do not request from server
            return
        }
        Task {
            if self.relayMode == nil || self.relayMode == "server" {
                var setting = await self.relay.getRelaySetting()
                if setting == nil {
                    setting = RelaySetting(mode: "soft", openaiBaseUrl: "https://api.openai.com/v1")
                } else {
                    self.relayMode = setting!.mode ?? "soft"
                    if self.openaiBaseUrl == nil {
                        self.openaiBaseUrl = setting!.openaiBaseUrl
                    }
                }
            }
            if self.relayMode == "hard" {
                self.openaiKey = await self.relay.setup()
            } else {
                await self.requestOpenAIKey()
            }
        }
    }
    
    private func decrypt(base64EncodedEncryptedKey: String) throws -> String {
        let encryptedKey = Data(base64Encoded: base64EncodedEncryptedKey)
        guard let encryptedKey = encryptedKey else {
            throw NSError(domain: "Invalid encoded encrypted key", code: -1)
        }
        
        let ivObject = [UInt8](sharedEncryptionIV!.data(using: .utf8)!.sha256()[0..<16])
        let sharedKey = [UInt8](sharedEncryptionSecret!.data(using: .utf8)!.sha256()[0..<32])
        let aes = try AES(key: sharedKey, blockMode: CBC(iv: ivObject))
        let dBytes = try aes.decrypt(encryptedKey.bytes)
        let dKey = String(data: Data(dBytes), encoding: .utf8)
        guard let key = dKey else {
            throw NSError(domain: "Key is not a string", code: -3)
        }
        return key
    }
    
    private func requestOpenAIKey() async {
        guard let relayBaseUrl = relayBaseUrl else {
            print("Relay URL not set")
            SentrySDK.capture(message: "Relay URL not set")
            return
        }
        let session = URLSession(configuration: .default)
        guard let url = URL(string: "\(relayBaseUrl)/soft/key") else {
            print("Invalid Relay URL")
            SentrySDK.capture(message: "Invalid Relay URL")
            return
        }
        guard let token = await relay.getDeviceToken() else {
            return
        }
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-DEVICE-TOKEN")
        let task = session.dataTask(with: request) { data, _, err in
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
            } catch {
                print("[AppConfig][requestOpenAIKey] error processing key response", error)
                SentrySDK.capture(message: "[AppConfig][requestOpenAIKey] error processing key response \(error)")
            }
        }
        task.resume()
    }
    
    /// Checks the whitelist.
    ///
    /// This method retrieves the `USER_NAME` from the settings, validates the user against a whitelist,
    /// and returns a boolean indicating the validation result.
    public func checkWhiteLabelList() async -> Bool {
        guard let username = SettingsBundleHelper.getUserName() else {
            return false
        }
        
        guard let relayUrl = relayBaseUrl else {
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
            
            sentryDSN = dictionary["SENTRY_DSN"] as? String
            
            sharedEncryptionSecret = dictionary["SHARED_ENCRYPTION_SECRET"] as? String
            sharedEncryptionIV = dictionary["SHARED_ENCRYPTION_IV"] as? String
            relayBaseUrl = dictionary["RELAY_BASE_URL"] as? String
            relayMode = dictionary["RELAY_MODE"] as? String
            disableRelayLog = dictionary["DISABLE_RELAY_LOG"] as? Bool
            enableTimeLoggerPrint = dictionary["ENABLE_TIME_LOGGER_PRINT"] as? Bool
            
            themeName = dictionary["THEME_NAME"] as? String
            deepgramKey = dictionary["DEEPGRAM_KEY"] as? String
            openaiKey = dictionary["API_KEY"] as? String
            openaiBaseUrl = dictionary["OPENAI_BASE_URL"] as? String
            serverAPIKey = dictionary["SERVER_API_Key"] as? String
            
            // Convert the string values to Int
            if let eventsString = dictionary["MINIMUM_SIGNIFICANT_EVENTS"] as? String,
               let events = Int(eventsString) {
                minimumSignificantEvents = events
            }
            
            if let daysString = dictionary["DAYS_BETWEEN_PROMPTS"] as? String,
               let days = Int(daysString) {
                daysBetweenPrompts = days
            }
            
            if let whiteLabelListString = dictionary["WHITELIST"] as? [String] {
                whiteLabelList = whiteLabelListString
            }
        } catch {
            SentrySDK.capture(message: "Error starting audio engine: \(error.localizedDescription)")
            fatalError(error.localizedDescription)
        }
    }
    
    func getOpenAIKey() -> String? {
        return openaiKey
    }
    
    func getOpenAIBaseUrl() -> String? {
        return openaiBaseUrl
    }
    
    func getSentryDSN() -> String? {
        return sentryDSN
    }
    
    func getDeepgramKey() -> String? {
        return deepgramKey
    }
    
    // Getter methods for the review prompt configuration
    func getMinimumSignificantEvents() -> Int? {
        return minimumSignificantEvents
    }
    
    func getDaysBetweenPrompts() -> Int? {
        return daysBetweenPrompts
    }
    
    func getThemeName() -> String {
        return themeName ?? AppThemeSettings.blackredTheme.settings.name // AppThemeSettings.defaultTheme.settings.name
    }
    
    func getSharedEncryptionSecret() -> String? {
        return sharedEncryptionSecret
    }
    
    func getSharedEncryptionIV() -> String? {
        return sharedEncryptionIV
    }
    
    func getRelayUrl() -> String? {
        return relayBaseUrl
    }
    
    func getWhiteLabelListString() -> [String]? {
        return whiteLabelList
    }
    
    func renewRelayAuth() {
        Task {
            if self.relayMode == "hard" {
                let newToken = await self.relay.refresh()
                if newToken != nil {
                    self.openaiKey = newToken
                }
            } else {
                await self.requestOpenAIKey()
            }
        }
    }
    
    func getRelayMode() -> String? {
        return relayMode
    }
    
    func getDisableRelayLog() -> Bool {
        return disableRelayLog ?? false
    }
    
    func getEnableTimeLoggerPrint() -> Bool {
        return enableTimeLoggerPrint ?? false
    }
    
    func getServerAPIKey() -> String? {
        return serverAPIKey
    }
}
