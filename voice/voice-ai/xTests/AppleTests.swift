import XCTest
import KeychainSwift

@testable import Voice_AI

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
        let userId = "12345"
        let balance = "100.00"
        let createdAt = "2023-01-01"
        let updatedAt = "2023-02-01"
        let expirationDate = "2023-03-01"
        let isSuscriptionActive:Bool = true

        keychainService.storeUser(id: userId, balance: balance, createdAt: createdAt, updatedAt: updatedAt, expirationDate: expirationDate, isSubscriptionActive: isSuscriptionActive)
  
        XCTAssertEqual(keychainService.retrieveUserid(), userId)
        XCTAssertEqual(keychainService.retrieveBalance(), balance)
        XCTAssertEqual(keychainService.retrieveCreatedAt(), createdAt)
        XCTAssertEqual(keychainService.retrieveUpdatedAt(), updatedAt)
        XCTAssertEqual(keychainService.retrieveExpirationDate(), expirationDate)
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
    
    func testDelete() {
        let key = "userID"
        let value = "testValue"
        keychainService.clearAll()
        keychainService.storeUser(id: key, balance: value, createdAt: nil, updatedAt: nil, expirationDate: nil, isSubscriptionActive:  false)
 
        keychainService.delete(key: key)
        XCTAssertNil(keychainService.retrieveUserid())
        }
}

class AppleSignInManagerTests: XCTestCase {
    
}
