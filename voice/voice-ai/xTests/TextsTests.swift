import XCTest
import Foundation
@testable import Voice_AI

class LanguagesTests: XCTestCase {
    
    // Mocking an array of language codes for testing
    let languageCodes = ["en", "fr", "es", "de"]
    
    func testPreferredLanguageExistsInCodes() {
        XCTAssertEqual(getLanguageCode(preferredLanguage: "en"), "en", "Expected 'en' as the language code for preferred language 'en'")
    }
    
    func testPreferredLanguageDoesNotExistInCodes() {
        XCTAssertEqual(getLanguageCode(preferredLanguage: "enj"), "en", "Expected 'en' as the language code for preferred language 'en'")
    }
}
