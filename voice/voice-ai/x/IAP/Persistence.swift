import Foundation

class Persistence {
    static let creditsCountKey = "creditsCount"
    private static let storage = UserDefaults()

    static func increaseConsumablesCount(creditsAmount: Int) {
        let currentValue = storage.integer(forKey: Persistence.creditsCountKey)
        storage.set(currentValue + creditsAmount, forKey: Persistence.creditsCountKey)
    }
}
