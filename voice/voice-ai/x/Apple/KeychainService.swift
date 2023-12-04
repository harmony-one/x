import KeychainSwift

class KeychainService {
    static let shared = KeychainService()
    private let keychain = KeychainSwift()
    
    private init() {}
    
    func storeUserCredentials(appleId: String, fullName: String?, email: String?) {
        keychain.set(appleId, forKey: "appleId")
        if let fullName = fullName {
            keychain.set(fullName, forKey: "fullName")
        }
        if let email = email {
            keychain.set(email, forKey: "email")
        }
    }
    
    func storeUser(id: String?, balance: String?, createdAt: String?, updatedAt: String?, expirationDate: String?, isSubscriptionActive: Bool?, appVersion: String?) {
        if let id = id {
            keychain.set(id, forKey: "userID")
        }
        if let balance = balance {
            keychain.set(balance, forKey: "balance")
        }
        if let createdAt = createdAt {
            keychain.set(createdAt, forKey: "createdAt")
        }
        if let updatedAt = updatedAt {
            keychain.set(updatedAt, forKey: "updatedAt")
        }
        if let expirationDate = expirationDate {
            keychain.set(expirationDate, forKey: "expirationDate")
            AppSettings.shared.premiumUseExpires = AppSettings.shared.convertDateStringToLocalFormat(inputDateString: expirationDate, inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") ?? expirationDate
        }
        if let isSubscriptionActive = isSubscriptionActive {
            keychain.set(String(isSubscriptionActive), forKey: "isSubscriptionActive")
        }
        if let appVersion = appVersion {
            keychain.set(appVersion, forKey: "appVersion")
        }
    }
        
    func isAppleIdAvailable() -> Bool {
        return keychain.get("appleId") != nil
    }
        
    func retrieveBalance() -> String? {
        return keychain.get("balance")
    }
    
    func retrieveCreatedAt() -> String? {
        return keychain.get("createdAt")
    }
    
    func retrieveUpdatedAt() -> String? {
        return keychain.get("updatedAt")
    }
    
    func retrieveFullName() -> String? {
        return keychain.get("fullName")
    }
    
    func retrieveEmail() -> String? {
        return keychain.get("email")
    }
    
    func retrieveAppleID() -> String? {
        return keychain.get("appleId")
    }
    
    func retrieveUserid() -> String? {
        return keychain.get("userID")
    }
    
    func retrieveExpirationDate() -> String? {
        return keychain.get("expirationDate")
    }

    func retrieveIsSubscriptionActive() -> Bool {
        let value = keychain.get("isSubscriptionActive")
        return value == "true"
    }

    func retrieveAppVersion() -> String? {
        return keychain.get("appVersion")
    }

    func deleteUserCredentials() {
        keychain.delete("appleId")
        keychain.delete("fullName")
        keychain.delete("email")
    }
    
    func delete(key: String) {
        keychain.delete(key)
    }
    
    func clearAll() {
        keychain.clear()
    }
}
