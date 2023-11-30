import XCTest
import SwiftUI
import UIKit
@testable import Voice_AI

class SettingsViewTests: XCTestCase {
    var settingsView: SettingsView!
    var store: Store = Store()
    var appSettings: AppSettings = AppSettings()

    override func setUp() {
        super.setUp()
        settingsView = SettingsView()
//            .environmentObject(Store()) as? SettingsView
//            .environmentObject(appSettings) as? SettingsView
    }

    override func tearDown() {
        settingsView = nil
        super.tearDown()
    }
    
    func testGetUserNameWithEmail() {
        let keychainService = KeychainService.shared
        keychainService.clearAll()
        
        let appleId = "testAppleId"
        let fullName = "John Doe"
        let email = "john@example.com"
        
        keychainService.storeUserCredentials(appleId: appleId, fullName: fullName, email: email)

        let userName = settingsView.getUserName()
        XCTAssertEqual(userName, "john@example.com", "Username should be retrieved email")
    }
    
    func testGetUserNameWithoutEmail() {
        let keychainService = KeychainService.shared
        keychainService.clearAll()
        
        let appleId = "testUserId"
        let fullName = "Jane Doe"
        
        keychainService.storeUserCredentials(appleId: appleId, fullName: fullName, email: nil)

        let userName = settingsView.getUserName()
        XCTAssertEqual(userName, "User id not found")
    }

    func testGetUserNameSignIn() {
        let keychainService = KeychainService.shared
        keychainService.clearAll()
        
        XCTAssertEqual(settingsView.getUserName(), "Sign In")
    }
    
    func testConvertEmptyMessagesToTranscript() {
        let transcript = settingsView.convertMessagesToTranscript(messages: [])

        XCTAssertTrue(transcript.isEmpty, "Transcript should be empty when there are no messages")
    }
    
    func testConvertMessagesToTranscript() {
        // Assuming Message is a struct or class with 'role' and 'content' properties
        let messages = [
            Message(role: "user", content: "Hello, how are you?"),
            Message(role: "GPT", content: "I'm good, thank you!"),
            Message(role: "user", content: "What's the weather today?")
        ]

        let expectedTranscript = "User: Hello, how are you?\nGPT: I'm good, thank you!\nUser: What's the weather today?\n"
        let actualTranscript = settingsView.convertMessagesToTranscript(messages: messages)

        XCTAssertEqual(actualTranscript, expectedTranscript, "Transcript should correctly format the messages")
    }
    
    func testSaveTranscript() {
        XCTAssertNoThrow(settingsView.saveTranscript())
    }
    
    func testActionSheetContent() {
        let actionSheet = settingsView.actionSheet()
        
        XCTAssertNotNil(actionSheet)
    }
    
    func testTweet() {
        XCTAssertNoThrow(settingsView.tweet())
    }
    
    func testOpenSystemSettings() {
        XCTAssertNoThrow(settingsView.openSystemSettings())
    }
    
    func testPerformSignIn() {
        XCTAssertNoThrow(settingsView.performSignIn())
    }
    
    func testShowPurchaseDialog() {
        XCTAssertNoThrow(settingsView.showPurchaseDialog())
    }
}
