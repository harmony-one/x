import XCTest
import StoreKit

class PersistenceTests: XCTestCase {
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: Persistence.creditsCountKey)
        UserDefaults.standard.removeObject(forKey: Persistence.booster3DayPurchaseTimeKey)
    }

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
    
    
//    func testGetEpochWithValidDateString() {
//        let dateString = "2023-11-17T12:34:56.789Z"
//        let epochTime = Persistence.getEpoch(dateString: dateString)
//        XCTAssertNotNil(epochTime)
//        XCTAssertEqual(epochTime, 1700224496.789)
//    }
//
//    func testGetEpochWithInvalidDateString() {
//        let invalidDateString = "invalidDateString"
//        let epochTime = Persistence.getEpoch(dateString: invalidDateString)
//
//        XCTAssertNil(epochTime)
//    }
//    
//    func testGetEpochWithNilDateString() {
//        let nilDateString: String? = nil
//        let epochTime = Persistence.getEpoch(dateString: nilDateString)
//
//        XCTAssertNil(epochTime)
//    }

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
            XCTAssertFalse(store.products.isEmpty, "products array should not be empty")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
