import XCTest
import Speech
@testable import Voice_AI

class PermissionTests: XCTestCase {
    
    func testSetup_MicrophoneAccessDenied() {
            let permission = MockPermission()
            permission.setup()
            XCTAssertTrue(permission.handleMicrophoneAccessDeniedCalled)
        }
    
    // for default iOS version
    func testRequestMicrophoneAccessGranted_DefaultVersion() {
        let permission = Permission()
        let expectation = self.expectation(description: "Microphone access granted")
        
        permission.requestMicrophoneAccess { granted in
            XCTAssertTrue(granted)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // for versions earlier than iOS14
    func testRequestMicrophoneAccessGranted_OldVersion() {
        let permission = Permission()
        let expectation = self.expectation(description: "Microphone access granted")
        
        permission.requestMicrophoneAccess(forceOldVersionForTesting: true) { granted in
            XCTAssertTrue(granted)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    

//    func testCheckMicrophoneAccessGranted() {
//        let permission = Permission()
//        XCTAssertTrue(permission.checkMicrophoneAccess())
//    }
}
