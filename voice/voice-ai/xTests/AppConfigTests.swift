import XCTest
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
