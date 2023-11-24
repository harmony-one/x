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
            "expirationDate": "2023-11-30T23:59:59Z"
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
        let api = UserAPI()
        let appleId = "testAppleId"
        
        // When
        api.getUserBy(appleId: appleId)
//        print(**************** \(user))
        // Then
        // Assert that the network request is made correctly
        // Assert that the correct data is stored in KeychainService
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
    
}

