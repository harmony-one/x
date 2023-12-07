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

class SurpriseIntentTests: XCTestCase {
    func testPerform() async {
        let surpriseIntent = SurpriseIntent()
        let expectation = expectation(description: "SurpriseIntent perform completed")
        
        do {
            let intentResult = try await surpriseIntent.perform()
            XCTAssertNotNil(intentResult)
            expectation.fulfill()
        } catch {
            XCTFail("SurpriseIntent perform threw an error: \(error)")
        }
        await waitForExpectations(timeout: 5)
    }
}

class PlayPauseIntentTests: XCTestCase {
    func testPerform() async {
        let playPauseIntent = PlayPauseIntent()
        let expectation = expectation(description: "PlayPauseIntent perform completed")
        
        do {
            let intentResult = try await playPauseIntent.perform()
            XCTAssertNotNil(intentResult)
            expectation.fulfill()
        } catch {
            XCTFail("PlayPauseIntent perform threw an error: \(error)")
        }
        await waitForExpectations(timeout: 5)
    }
}

class NewSessionIntentTests: XCTestCase {
    func testPerform() async {
        let newSessionIntent = NewSessionIntent()
        let expectation = expectation(description: "NewSessionIntent perform completed")
        
        do {
            let intentResult = try await newSessionIntent.perform()
            XCTAssertNotNil(intentResult)
            expectation.fulfill()
        } catch {
            XCTFail("NewSessionIntent perform threw an error: \(error)")
        }
        await waitForExpectations(timeout: 5)
    }
}

//@available(iOS 16.0, *)
//class VoiceAIShortcutsTests: XCTestCase {
//
//    func testAppShortcuts() {
//
//        
//        // Get the app shortcuts from the provider
//        let appShortcuts = VoiceAIShortcuts.appShortcuts
//        
//        // Assert that the appShortcuts array is not empty
//        XCTAssertFalse(appShortcuts.isEmpty)
//        
//        // Verify that each app shortcut contains an AppIntent
//        for appShortcut in appShortcuts {
//            XCTAssertTrue(appShortcut.intent is (any AppIntent), "Shortcut should contain an AppIntent")
//        }
//    }
//}
