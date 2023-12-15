import XCTest
import StoreKit
import SwiftUI
import KeychainSwift
@testable import Voice_AI

class PersistenceTests: XCTestCase {
    private let keychain = KeychainSwift()
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
    
    func testGetBoosterPurchaseTimeNotNil() {
        keychain.set("2023-12-31T23:59:59.999Z", forKey: "expirationDate")
        XCTAssertNotNil(Persistence.getBoosterPurchaseTime())
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
            XCTAssertFalse(store.products.isEmpty, "products array should not be empty")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestProductsError() {
        let expectation = XCTestExpectation(description: "Request Products")

        Task {
            try await store.requestProducts(simulateError: true)
            XCTAssertTrue(store.products.isEmpty, "products array should be empty")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}

//class ActivityIndicatorViewTests: XCTestCase {
//    var app: XCUIApplication!
//
//        override func setUp() {
//            super.setUp()
//            app = XCUIApplication()
//            app.launch()
//        }
//
//        func testProgressViewIsVisibleWhenIsShowingIsTrue() {
//            // Set isShowing to true
//            app.switches["isShowingSwitch"].tap()
//            
//            // Verify that the ProgressView is visible
//            XCTAssertTrue(app.progressIndicators["progressView"].exists)
//        }
//}
