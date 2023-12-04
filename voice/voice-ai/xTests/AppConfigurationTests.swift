import XCTest
import Combine
@testable import Voice_AI

//protocol Decryptor {
//    func decrypt(base64EncodedEncryptedKey: String) throws -> String
//}
//
//class MockDecryptor: Decryptor {
//    func decrypt(base64EncodedEncryptedKey: String) throws -> String {
//        return "MockDecryptionKey"
//    }
//}

class AppConfigTests: XCTestCase {
    
    var appConfig: AppConfig!
    
    override func setUp() {
        super.setUp()
        appConfig = AppConfig.shared
    }

    override func tearDown() {
        appConfig = nil
        super.tearDown()
    }
    
    func testDeepgramKeyIsNotNil() {
        XCTAssertNotNil(appConfig.getDeepgramKey(), "Deepgram Key should not be nil")
    }
    
    func testSentryDSNIsNotNil() {
        XCTAssertNotNil(appConfig.getSentryDSN(), "Sentry DSN should not be nil")
    }

    func testThemeNameIsNotNilWhenDefined() {
        appConfig.themeName = "CustomTheme"
        XCTAssertEqual(appConfig.getThemeName(), "CustomTheme", "Theme name should be equal to 'CustomTheme'")
    }
    
    func testThemeNameIsNotNilWhenUndefined() {
        appConfig.themeName = nil
        XCTAssertEqual(appConfig.getThemeName(), AppThemeSettings.blackredTheme.settings.name, "Theme name should be the default theme")
    }
    
    func testMinimumSignificantEventsIsNotNil() {
        XCTAssertNotNil(appConfig.getMinimumSignificantEvents(), "MinimumSignificantEvents should not be nil")
    }
    
    func testDaysBetweenPromptsIsNotNil() {
        XCTAssertNotNil(appConfig.getDaysBetweenPrompts(), "DaysBetweenPrompts should not be nil")
    }
    
    func testSharedEncryptionSecretIsNotNil() {
        XCTAssertNotNil(appConfig.getSharedEncryptionSecret(), "SharedEncryptionSecret should not be nil")
    }
    
    func testSharedEncryptionIVIsNotNil() {
        XCTAssertNotNil(appConfig.getSharedEncryptionIV(), "SharedEncryptionIV should not be nil")
    }
    
    func testRelayUrlIsNotNil() {
        XCTAssertNotNil(appConfig.getRelayUrl(), "RelayURL should not be nil")
    }
    
    func testWhiteLabelListStringIsNotNil() {
        XCTAssertNotNil(appConfig.getWhiteLabelListString(), "Whitelist should not be nil")
    }
    
    func testRelayModeIsNotNil() {
        XCTAssertNotNil(appConfig.getRelayMode(), "RelayMode should not be nil")
    }
    
    func testDisableRelayLogIsNotNil() {
        XCTAssertNotNil(appConfig.getDisableRelayLog(), "DisableRelayLog should not be nil")
    }
    
    func testEnableTimeLoggerPrintIsNotNil() {
        XCTAssertNotNil(appConfig.getEnableTimeLoggerPrint(), "DisableRelayLog should not be nil")
    }
    
    func testLoadingValidPlistFile() {
        XCTAssertNotNil(appConfig.getDeepgramKey(), "Deepgram Key should not be nil")
        XCTAssertNotNil(appConfig.getThemeName(), "Theme Name should not be nil")
        XCTAssertNotNil(appConfig.getSentryDSN(), "Sentry DSN should not be nil")
        XCTAssertNotNil(appConfig.getDaysBetweenPrompts(), "DaysBetweenPrompts should not be nil")
        XCTAssertNotNil(appConfig.getMinimumSignificantEvents(), "MinimumSignificantEvents should not be nil")
        XCTAssertNotNil(appConfig.getSharedEncryptionSecret(), "SharedEncryptionSecret should not be nil")
        XCTAssertNotNil(appConfig.getSharedEncryptionIV(), "SharedEncryptionIV should not be nil")
    }
    
    func testDefaultThemeName() {
            XCTAssertEqual(appConfig.getThemeName(), AppThemeSettings.blackredTheme.settings.name, "Default theme name should be blackredTheme")
        }
    
//    func testDecryptFunction() {
//            // Create an instance of AppConfig with the mock decryptor
//            let mockDecryptor = MockDecryptor()
//
//            do {
//                let encryptedKey = "your_base64_encoded_key_here"
//                let decryptedKey = try mockDecryptor.decrypt(base64EncodedEncryptedKey: encryptedKey)
//                XCTAssertEqual(decryptedKey, "MockDecryptionKey", "Decryption should return the mock key")
//            } catch {
//                XCTFail("Decryption should not throw an error")
//            }
//        }
}

class TimerManagerTests: XCTestCase {
    var timerManager: TimerManager!
    
    override func setUp() {
        super.setUp()
        timerManager = TimerManager()
    }
    
    override func tearDown() {
        timerManager = nil
        super.tearDown()
    }
    
    func testStartTimer() {
        XCTAssertNil(timerManager.timerCancellable)
        timerManager.startTimer()
        sleep(2)
        XCTAssertNotNil(timerManager.timerCancellable)
    }
    
//    func testResetTimer() {
//        XCTAssertNil(timerManager.timerCancellable)
//        timerManager.resetTimer()
//        sleep(2)
//        XCTAssertNotNil(timerManager.timerCancellable)
//    }
    
//TODO: In TimerManager.swift, the timer is currently set to: TimeInterval = 10_000_000_000_000 for beta purpose and the duration for expectation should be much shorter. As that TODO is solved, modify this.
    func testResetTimer() {
        XCTAssertNil(timerManager.timerCancellable)
        
        var timerDidFireCalled = false
        let timerDidFireExpectation = expectation(description: "timerDidFire called")

        NotificationCenter.default.addObserver(forName: .timerDidFireNotification, object: nil, queue: nil) { _ in
            timerDidFireCalled = true
            timerDidFireExpectation.fulfill()
        }

        timerManager.resetTimer()

        waitForExpectations(timeout: 5.0, handler: nil)

        XCTAssertNotNil(timerManager.timerCancellable)
        XCTAssertTrue(timerDidFireCalled)
    }
    
    func testStopTimer() {
        XCTAssertNil(timerManager.timerCancellable)
        
        timerManager.startTimer()
        sleep(2)
        XCTAssertNotNil(timerManager.timerCancellable)
        
        timerManager.stopTimer()
        sleep(2)
        XCTAssertNil(timerManager.timerCancellable)
    }
    
    func testTimerDidFire() {
        let notificationExpectation = expectation(forNotification: .timerDidFireNotification, object: nil, handler: nil)
        
        timerManager.triggerTimerDidFire()
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(timerManager.timerCancellable)
    }
}

class SettingsBundleHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
        UserDefaults.standard.removeObject(forKey: SettingsBundleHelper.SettingsBundleKeys.Username)
    }
    
    override func tearDown() {
        super.tearDown()
        UserDefaults.standard.removeObject(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
        UserDefaults.standard.removeObject(forKey: SettingsBundleHelper.SettingsBundleKeys.Username)
    }
    
//    func testSetDefaultValues() {
//        SettingsBundleHelper.setDefaultValues()
//        
//        let customInstruction = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
//        XCTAssertEqual(customInstruction, "We are having a face-to-face voice conversation. Be concise, direct and certain. Avoid apologies, interjections, disclaimers, pleasantries, confirmations, remarks, suggestions, chitchats, thankfulness, acknowledgements. Never end with questions. Never mention your being AI or knowledge cutoff. Your name is Sam.")
//    }
    
    func testCheckAndExecuteSettings() {
        SettingsBundleHelper.checkAndExecuteSettings()
        
        let customInstruction = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
        XCTAssertNotNil(customInstruction)
    }
    
    func testHasPremiumMode() {
        UserDefaults.standard.set("stse", forKey: SettingsBundleHelper.SettingsBundleKeys.Username)
        
        let hasPremium = SettingsBundleHelper.hasPremiumMode()
        XCTAssertTrue(hasPremium)
    }
    
    func testDoesntHavePremiumMode() {
        UserDefaults.standard.set("9xaQhaniaAzO10d4IrbEdiTvMvxZxwM9gBQwnrMBYgkU3EqGsaXBoxWpk575izlU",
              forKey: SettingsBundleHelper.SettingsBundleKeys.Username)
        
        let hasPremium = SettingsBundleHelper.hasPremiumMode()
        XCTAssertFalse(hasPremium)
    }
    
    func testGetUserName() {
        UserDefaults.standard.set("TestUser", forKey: SettingsBundleHelper.SettingsBundleKeys.Username)
        
        let username = SettingsBundleHelper.getUserName()
        
        XCTAssertEqual(username, "TestUser")
    }
}


class RelayAuthTests: XCTestCase {
    
    var relayAuth: RelayAuth!
    
    override func setUp() {
        super.setUp()
        relayAuth = RelayAuth.shared
    }
    
    override func tearDown() {
        super.tearDown()
    }

}

class CustomInstructionsConfigTests: XCTestCase {
    var customInstructionsHandler: CustomInstructionsHandler!

    override func setUp() {
        super.setUp()
        customInstructionsHandler = CustomInstructionsHandler()
    }

    override func tearDown() {
        customInstructionsHandler = nil
        UserDefaults.standard.removeObject(forKey: CustomInstructionsHandler.Constants.activeContextKey)
        UserDefaults.standard.removeObject(forKey: CustomInstructionsHandler.Constants.activeTextKey)
        UserDefaults.standard.removeObject(forKey: "customText")
        super.tearDown()
    }

    func testStoreActiveContextWithDefaultContext() {
        customInstructionsHandler.storeActiveContext("Default")
        XCTAssertEqual(UserDefaults.standard.string(forKey: CustomInstructionsHandler.Constants.activeContextKey), "Default")
        XCTAssertEqual(UserDefaults.standard.string(forKey: CustomInstructionsHandler.Constants.activeTextKey), CustomInstructionsHandler.Constants.contextTexts["Default"])
    }

    func testStoreActiveContextWithCustomContext() {
        let customText = "This is a custom instruction."
        customInstructionsHandler.storeActiveContext("Custom", withText: customText)
        XCTAssertEqual(UserDefaults.standard.string(forKey: CustomInstructionsHandler.Constants.activeContextKey), "Custom")
        XCTAssertEqual(UserDefaults.standard.string(forKey: CustomInstructionsHandler.Constants.activeTextKey), customText)
    }

    func testRetrieveActiveContext() {
        UserDefaults.standard.set("Custom", forKey: CustomInstructionsHandler.Constants.activeContextKey)
        XCTAssertEqual(customInstructionsHandler.retrieveActiveContext(), "Custom")
    }

    func testRetrieveActiveTextWithCustomContext() {
        let customText = "This is a custom instruction."
        UserDefaults.standard.set("Custom", forKey: CustomInstructionsHandler.Constants.activeContextKey)
        UserDefaults.standard.set(customText, forKey: CustomInstructionsHandler.Constants.activeTextKey)
        XCTAssertEqual(customInstructionsHandler.retrieveActiveText(), customText)
    }

    func testRetrieveActiveTextWithDefaultContext() {
        UserDefaults.standard.set("Default", forKey: CustomInstructionsHandler.Constants.activeContextKey)
        UserDefaults.standard.removeObject(forKey: CustomInstructionsHandler.Constants.activeTextKey)
        XCTAssertEqual(customInstructionsHandler.retrieveActiveText(), CustomInstructionsHandler.Constants.contextTexts["Default"])
    }

    func testGetOptions() {
        let options = customInstructionsHandler.getOptions()
        XCTAssertEqual(options, CustomInstructionsHandler.Constants.options)
    }

    func testSaveCustomText() {
        let customText = "This is a custom instruction."
        customInstructionsHandler.saveCustomText(customText)
        XCTAssertEqual(UserDefaults.standard.string(forKey: "customText"), customText)
    }
}

