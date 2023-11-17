import XCTest
import StoreKit

class PersistenceTests: XCTestCase {

    func testIncreaseConsumablesCount() {
        let initialCreditsCount = UserDefaults.standard.integer(forKey: Persistence.creditsCountKey)
        let creditsAmount = 5

        Persistence.increaseConsumablesCount(creditsAmount: creditsAmount)

        let updatedCreditsCount = UserDefaults.standard.integer(forKey: Persistence.creditsCountKey)
        XCTAssertEqual(updatedCreditsCount, initialCreditsCount + creditsAmount)
    }

    func testUpdateBooster3DayPurchaseTime() {
        let expectedTime = Date()

        Persistence.updateBooster3DayPurchaseTime()

        let savedTime = UserDefaults.standard.double(forKey: Persistence.booster3DayPurchaseTimeKey)
        let savedDate = Date(timeIntervalSince1970: savedTime)
        XCTAssertEqual(savedDate.timeIntervalSince(expectedTime), 0, accuracy: 0.1)
    }

    func testGetBoosterPurchaseTime() {
        let expectedTime = Date()
        UserDefaults.standard.set(expectedTime.timeIntervalSince1970, forKey: Persistence.booster3DayPurchaseTimeKey)

        let purchaseTime = Persistence.getBoosterPurchaseTime()

        XCTAssertEqual(purchaseTime.timeIntervalSince(expectedTime), 0, accuracy: 0.1)
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: Persistence.creditsCountKey)
        UserDefaults.standard.removeObject(forKey: Persistence.booster3DayPurchaseTimeKey)
    }

}

class StoreTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    override func tearDown() {
        store = nil
        super.tearDown()
    }

    func testRequestProducts() {
        let expectation = XCTestExpectation(description: "Request Products")

        Task {
                await store.requestProducts()
                XCTAssertNotNil(store.products, "products array should not be empty")
                expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
