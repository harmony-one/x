import Foundation
import AppIntents

import XCTest
@testable import Voice_AI

class IntentManagerTests: XCTestCase {
    var intentManager: IntentManager!
    var mockSpeechRecognition: MockSpeechRecognition!
        
    override func setUp() {
        super.setUp()
        intentManager = IntentManager.shared
    }
    
    override func tearDown() {
        intentManager = nil
        super.tearDown()
    }
    
    func testSetActionHandler() {
        let actionHandler = ActionHandler()
        intentManager.setActionHandler(actionHandler: actionHandler)
        XCTAssertNotNil(intentManager.actionHandler)
    }
    
    func testHandleAction() {
        mockSpeechRecognition = MockSpeechRecognition()
        let actionHandler = ActionHandler(speechRecognition: mockSpeechRecognition)
        intentManager.setActionHandler(actionHandler: actionHandler)
        intentManager.handleAction(action: .surprise)
        XCTAssertTrue(mockSpeechRecognition.surpriseCalled, "surprise() should be called after .surprise action")
        
    }
    
    func testShowSettings() {
        intentManager.showSettings()
        XCTAssertEqual(AppSettings.shared.type, .settings)
    }
}

class AppSettingsIntentTests: XCTestCase {
    func testPerform() async {
            let appSettingsIntent = AppSettingsIntent()
            let expectation = expectation(description: "AppSettingsIntent perform completed")
            
            do {
                let intentResult = try await appSettingsIntent.perform()
                XCTAssertNotNil(intentResult)
                expectation.fulfill()
            } catch {
                XCTFail("AppSettingsIntent perform threw an error: \(error)")
            }
            await waitForExpectations(timeout: 5)
        }
}
