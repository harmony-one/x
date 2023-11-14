import Foundation

class Persistence {
    static let creditsCountKey = "creditsCount"
    private static let storage = UserDefaults()

    static let booster3DayPurchaseTimeKey = "booster3DayPurchaseTime"

    static func increaseConsumablesCount(creditsAmount: Int) {
        let currentValue = storage.integer(forKey: Persistence.creditsCountKey)
        storage.set(currentValue + creditsAmount, forKey: Persistence.creditsCountKey)
    }

    static func updateBooster3DayPurchaseTime() {
        storage.set(Date().timeIntervalSince1970, forKey: Self.booster3DayPurchaseTimeKey)
    }

    static func getBoosterPurchaseTime() -> Date {
        let epoch = storage.double(forKey: Self.booster3DayPurchaseTimeKey)
        return Date(timeIntervalSince1970: epoch)
    }
}
