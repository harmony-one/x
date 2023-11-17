import XCTest
@testable import Voice_AI

class APIEnvironmentTests: XCTestCase {

    var keychainService: KeychainService!

    override func setUp() {
        super.setUp()
        keychainService = KeychainService.shared
    }

    override func tearDown() {
        super.tearDown()
        keychainService.clearAll()
    }

    func testGetUser() {
        keychainService.storeUser(id: "123", balance: nil, createdAt: nil, updatedAt: nil, expirationDate: nil)

        let userPath = APIEnvironment.getUser()
        XCTAssertEqual(userPath, "users/123")
    }

    func testPurchase() {
        keychainService.storeUser(id: "456", balance: nil, createdAt: nil, updatedAt: nil, expirationDate: nil)

        let purchasePath = APIEnvironment.purchase()
        XCTAssertEqual(purchasePath, "users/456/purchase")
    }

    func testGetUserByAppleID() {
        let appleID = "testAppleID"
        let userPath = APIEnvironment.getUser(byAppleID: appleID)
        XCTAssertEqual(userPath, "users/appleId/\(appleID)")
    }

    func testGetUserEmpty() {
        keychainService.deleteUserCredentials()

        let userPath = APIEnvironment.getUser()
        XCTAssertEqual(userPath, "")
    }

    func testPurchaseEmpty() {
        keychainService.deleteUserCredentials()

        let purchasePath = APIEnvironment.purchase()
        XCTAssertEqual(purchasePath, "")
    }
}
