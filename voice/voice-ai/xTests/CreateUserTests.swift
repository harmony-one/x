import XCTest

class CreateUserTests: XCTestCase {

    func testUserDecoding() throws {
        // Given
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
        
        // When
        let user = try JSONDecoder().decode(User.self, from: json)
        
        // Then
        XCTAssertEqual(user.id, "123")
        XCTAssertEqual(user.deviceId, "device123")
        XCTAssertEqual(user.appleId, "apple123")
        XCTAssertEqual(user.balance, 100)
        XCTAssertEqual(user.createdAt, "2023-11-20T12:00:00Z")
        XCTAssertEqual(user.updatedAt, "2023-11-20T13:00:00Z")
        XCTAssertEqual(user.expirationDate, "2023-11-30T23:59:59Z")
    }

    func testUserDecodingWithMissingFields() throws {
        // Given
        let json = """
        {
            "id": "123",
            "deviceId": "device123"
        }
        """.data(using: .utf8)!
        
        // When
        let user = try JSONDecoder().decode(User.self, from: json)
        
        // Then
        XCTAssertEqual(user.id, "123")
        XCTAssertEqual(user.deviceId, "device123")
        XCTAssertNil(user.appleId)
        XCTAssertNil(user.balance)
        XCTAssertNil(user.createdAt)
        XCTAssertNil(user.updatedAt)
        XCTAssertNil(user.expirationDate)
    }
    
    func testUserDecodingWithInvalidData() {
        // Given
        let json = """
        {
            "id": "123",
            "balance": "invalid"
        }
        """.data(using: .utf8)!
        
        // When/Then
        XCTAssertThrowsError(try JSONDecoder().decode(User.self, from: json)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
}
