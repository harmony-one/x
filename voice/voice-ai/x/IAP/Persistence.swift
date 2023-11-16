import Foundation

class Persistence {
    static let creditsCountKey = "creditsCount"
    private static let storage = UserDefaults()
    
    static let booster3DayPurchaseTimeKey = "booster3DayPurchaseTime"

    static func increaseConsumablesCount(creditsAmount: Int) {
        let currentValue = storage.integer(forKey: Persistence.creditsCountKey)
        storage.set(currentValue + creditsAmount, forKey: Persistence.creditsCountKey)
    }
    
    static func updateBooster3DayPurchaseTime(){
        storage.set(Date().timeIntervalSince1970, forKey: Self.booster3DayPurchaseTimeKey)
    }
    
    static func getBoosterPurchaseTime() -> Date {
      //  let epoch = storage.double(forKey: Self.booster3DayPurchaseTimeKey)
        
        let dateString = KeychainService.shared.retrieveExpirationDate()
        if let expirationDate =  Persistence.getEpoch(dateString: dateString) {
            return Date(timeIntervalSince1970: expirationDate)
        }
        return Date()
    }
    
    
    static func getEpoch(dateString: String?) -> TimeInterval? {

        guard let dateString = dateString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        if let date = dateFormatter.date(from: dateString) {
            return date.timeIntervalSince1970
        }
    
        return nil

    }
}
