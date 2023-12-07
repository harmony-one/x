import XCTest
import SwiftUI

class CreateUserTests: XCTestCase {

    func testUserDecoding() throws {
        let json = """
        {
            "id": "123",
            "deviceId": "device123",
            "appleId": "apple123",
            "balance": 100,
            "createdAt": "2023-11-20T12:00:00Z",
            "updatedAt": "2023-11-20T13:00:00Z",
            "expirationDate": "2023-11-30T23:59:59Z",
            "isSubscriptionActive": false,
            "appVersion": "1.0.0"
        }
        """.data(using: .utf8)!

        let user = try JSONDecoder().decode(User.self, from: json)

        XCTAssertEqual(user.id, "123")
        XCTAssertEqual(user.deviceId, "device123")
        XCTAssertEqual(user.appleId, "apple123")
        XCTAssertEqual(user.balance, 100)
        XCTAssertEqual(user.createdAt, "2023-11-20T12:00:00Z")
        XCTAssertEqual(user.updatedAt, "2023-11-20T13:00:00Z")
        XCTAssertEqual(user.expirationDate, "2023-11-30T23:59:59Z")
        XCTAssertEqual(user.isSubscriptionActive, false)
        XCTAssertEqual(user.appVersion, "1.0.0")
    }

    func testUserDecodingWithMissingFields() throws {
        let json = """
        {
            "id": "123",
            "deviceId": "device123"
        }
        """.data(using: .utf8)!
   
        let user = try JSONDecoder().decode(User.self, from: json)
 
        XCTAssertEqual(user.id, "123")
        XCTAssertEqual(user.deviceId, "device123")
        XCTAssertNil(user.appleId)
        XCTAssertNil(user.balance)
        XCTAssertNil(user.createdAt)
        XCTAssertNil(user.updatedAt)
        XCTAssertNil(user.expirationDate)
        XCTAssertNil(user.appVersion)
    }
    
    func testUserDecodingWithInvalidData() {
        let json = """
        {
            "id": "123",
            "balance": "invalid"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(User.self, from: json)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
}




class UserAPITests: XCTestCase {
    var keychainService: KeychainService!
    var api: UserAPI!
 
    override func setUp() {
        super.setUp()
        api = UserAPI()
        keychainService = KeychainService.shared
    }
    
    override func tearDown() {
        keychainService.clearAll()
        api = nil
        super.tearDown()
    }
    
    func testRegister() {
        let appleId = "testAppleId"
        let fullName = "John Doe"
        let email = "john@example.com"
        keychainService.storeUserCredentials(appleId: appleId, fullName: fullName, email: email)

        api.register(appleId: appleId)
        
        let isAvailable = self.keychainService.isAppleIdAvailable()
        XCTAssertTrue(isAvailable, "The correct data is stored in KeychainService")
    }
    
    func testGetUserBy() {
        // Given
        let appleId = "testAppleId"
        let fullName = "John Doe"
        let email = "john@example.com"
        keychainService.storeUserCredentials(appleId: appleId, fullName: fullName, email: email)
        api.register(appleId: appleId)
        
        // When
        api.getUserBy(appleId: appleId)
        let storedUserID = KeychainService.shared.retrieveAppleID()
        
        // Then
        XCTAssertEqual(storedUserID, "testAppleId", "Stored user ID should match the mock user ID")
    }
    
    func testGetUserByID() {
        // Given
        let appleId = "testAppleId"
        let fullName = "John Doe"
        let email = "john@example.com"
        keychainService.storeUserCredentials(appleId: appleId, fullName: fullName, email: email)
        api.register(appleId: appleId)
        
        // When
        api.getUserByID()
        let storedUserID = KeychainService.shared.retrieveAppleID()
        
        // Then
        XCTAssertEqual(storedUserID, "testAppleId", "Stored user ID should match the mock user ID")
    }
    
    func testIsSubscriptionActive() {
        // Given
        let id = "testId"
        let appleId = "testAppleId"
        let balance = "0"
        let createdAt = "0"
        let updatedAt = "0"
        let expirationDate = "0"
        let isSubscriptionActive = false
        let appVersion = "16.0"
        keychainService.storeUser(id: id, balance: balance, createdAt: createdAt, updatedAt: updatedAt, expirationDate: expirationDate, isSubscriptionActive: isSubscriptionActive, appVersion: appVersion)
        api.register(appleId: appleId)
        
        // When
        api.getUserByID()
        let storedIsSubscriptionActive = KeychainService.shared.retrieveIsSubscriptionActive()
        
        // Then
        XCTAssertEqual(storedIsSubscriptionActive, false, "Should be inactive by default")
    }
    
    func testPurchase() {
        // Given
        let api = UserAPI()
        let transactionId = "testTransactionId"
        
        // When
        api.purchase(transactionId: transactionId)
        
        // Then
        // Assert that the network request is made correctly
        // Assert that the correct data is stored in KeychainService

    }
    
    func testGetDeviceID() {
        let deviceID = DeviceInfo.getDeviceID()
        print("****** \(deviceID)")
        XCTAssertNotNil(deviceID)
        XCTAssertNotEqual(deviceID, "Not available", "Device Info found")
        XCTAssertTrue(deviceID.count > 0)
    }
    
}

