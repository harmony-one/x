import XCTest
@testable import Voice_AI

class PermissionTests: XCTestCase {

    func testRequestMicrophoneAccess_Granted() {
        let permission = Permission()
        let expectation = self.expectation(description: "Microphone access granted")

        permission.requestMicrophoneAccess { granted in
            XCTAssertTrue(granted)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testCheckMicrophoneAccess_Granted() {
        let permission = Permission()
        XCTAssertTrue(permission.checkMicrophoneAccess())
    }
}
