import XCTest
import KeychainSwift

@testable import Voice_AI

protocol APIServiceProtocol {
    func getUser(completion: @escaping (Result<User, Error>) -> Void)
}

class KeychainServiceTests: XCTestCase {
    
    var keychainService: KeychainService!
    
    override func setUp() {
        super.setUp()
        keychainService = KeychainService.shared
    }
    
    override func tearDown() {
        keychainService.clearAll()
        super.tearDown()
    }
    
    func testStoreUserCredentials() {
        let appleId = "testAppleId"
        let fullName = "John Doe"
        let email = "john@example.com"
        
        keychainService.storeUserCredentials(appleId: appleId, fullName: fullName, email: email)

        XCTAssertEqual(keychainService.retrieveAppleID(), appleId)
        XCTAssertEqual(keychainService.retrieveFullName(), fullName)
        XCTAssertEqual(keychainService.retrieveEmail(), email)
    }
    
    func testStoreUser() {
        let user = User(id: "12345", balance: 100, createdAt: "2023-01-01", updatedAt: "2023-02-01", expirationDate: "2023-03-01", isSubscriptionActive: true, appVersion: "16.0", address: "testAddress")

        keychainService.storeUser(user: user)

        XCTAssertEqual(keychainService.retrieveUserid(), user.id)
        XCTAssertEqual(keychainService.retrieveBalance(), String(user.balance!))
        XCTAssertEqual(keychainService.retrieveCreatedAt(), user.createdAt)
        XCTAssertEqual(keychainService.retrieveUpdatedAt(), user.updatedAt)
        XCTAssertEqual(keychainService.retrieveExpirationDate(), user.expirationDate)
        XCTAssertEqual(keychainService.retrieveIsSubscriptionActive(), user.isSubscriptionActive)
        XCTAssertEqual(keychainService.retrieveAppVersion(), user.appVersion)
        XCTAssertEqual(keychainService.retrieveAddress(), user.address)
    }
    
    func testIsAppleIdAvailable() {
        let appleId = "testAppleId"
        keychainService.storeUserCredentials(appleId: appleId, fullName: nil, email: nil)
        
        let isAvailable = keychainService.isAppleIdAvailable()
        
        XCTAssertTrue(isAvailable)
    }
    
    func testDeleteUserCredentials() {
        let appleId = "testAppleId"
        keychainService.storeUserCredentials(appleId: appleId, fullName: nil, email: nil)
    
        keychainService.deleteUserCredentials()
       
        XCTAssertNil(keychainService.retrieveAppleID())
        XCTAssertNil(keychainService.retrieveFullName())
        XCTAssertNil(keychainService.retrieveEmail())
    }
    
    func testRetrievePrivateKey() {
        let isAvailable = keychainService.retrievePrivateKey()
        
        XCTAssertNotNil(isAvailable)
    }
    
    func testDelete() {
        let appleId = "testAppleId"
        keychainService.storeUserCredentials(appleId: appleId, fullName: nil, email: nil)
    
        keychainService.delete(key: "appleId")
       
        XCTAssertNil(keychainService.retrieveAppleID())
    }
}
