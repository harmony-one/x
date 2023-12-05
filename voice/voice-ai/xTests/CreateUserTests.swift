import XCTest
import Foundation
@testable import Voice_AI

class UserTests: XCTestCase {
    
    func testDecodingCompleteData() {
        let json = """
        {
            "id": "123",
            "deviceId": "device123",
            "appleId": "apple123",
            "balance": 100,
            "createdAt": "2021-01-01T00:00:00Z",
            "updatedAt": "2021-01-02T00:00:00Z",
            "expirationDate": "2022-01-01T00:00:00Z",
            "isSubscriptionActive": true,
            "appVersion": "1.0.0"
        }
        """.data(using: .utf8)!

        do {
            let user = try JSONDecoder().decode(User.self, from: json)
            XCTAssertEqual(user.id, "123")
            XCTAssertEqual(user.deviceId, "device123")
            XCTAssertEqual(user.appleId, "apple123")
            XCTAssertEqual(user.balance, 100)
            XCTAssertEqual(user.createdAt, "2021-01-01T00:00:00Z")
            XCTAssertEqual(user.updatedAt, "2021-01-02T00:00:00Z")
            XCTAssertEqual(user.expirationDate, "2022-01-01T00:00:00Z")
            XCTAssertEqual(user.isSubscriptionActive, true)
            XCTAssertEqual(user.appVersion, "1.0.0")
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }

//    func testDecodingPartialData() {
//        // Similar to the above but with missing fields in the JSON
//    }
//
//    func testDecodingInvalidData() {
//        // Provide JSON with incorrect data types and assert an error is thrown
//    }

//    func testDecodingEmptyData() {
//        let json = "{}".data(using: .utf8)!
//        do {
//            let user = try JSONDecoder().decode(User.self, from: json)
//              Assert default or nil values
//        } catch {
//            XCTFail("Decoding failed: \(error)")
//        }
//    }
}
