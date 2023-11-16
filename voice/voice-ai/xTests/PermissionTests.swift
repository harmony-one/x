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
    
    func testHandleSpeechRecognitionAuthorizationStatusAuthorized() {
            let permission = Permission()
            let authStatus: SFSpeechRecognizerAuthorizationStatus = .authorized
            
            permission.handleSpeechRecognitionAuthorizationStatus(authStatus)
            
            XCTAssertEqual(permission.speechRecognitionPermissionStatus, "authorized")
        }
    
    func testHandleSpeechRecognitionAuthorizationStatusDenied() {
            let permission = Permission()
            let authStatus: SFSpeechRecognizerAuthorizationStatus = .denied
            
            permission.handleSpeechRecognitionAuthorizationStatus(authStatus)
            
            XCTAssertEqual(permission.speechRecognitionPermissionStatus, "denied")
        }
    
    func testHandleSpeechRecognitionAuthorizationStatusNotDetermined() {
            let permission = Permission()
            let authStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
            
            permission.handleSpeechRecognitionAuthorizationStatus(authStatus)
            
            XCTAssertEqual(permission.speechRecognitionPermissionStatus, "not determined")
        }

        func testHandleSpeechRecognitionAuthorizationStatusRestricted() {
            let permission = Permission()
            let authStatus: SFSpeechRecognizerAuthorizationStatus = .restricted
            
            permission.handleSpeechRecognitionAuthorizationStatus(authStatus)
            
            XCTAssertEqual(permission.speechRecognitionPermissionStatus, "restricted")
        }


    func testCheckMicrophoneAccessGranted() {
        let permission = Permission()
        XCTAssertTrue(permission.checkMicrophoneAccess())
    }
}
