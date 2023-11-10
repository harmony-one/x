import XCTest
@testable import Voice_AI

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

    func testAPIKeyIsNotNil() {
        XCTAssertNotNil(appConfig.getAPIKey(), "API Key should not be nil")
    }

    func testDeepgramKeyIsNotNil() {
        XCTAssertNotNil(appConfig.getDeepgramKey(), "Deepgram Key should not be nil")
    }
    
    func testSentryDSNIsNotNil() {
        XCTAssertNotNil(appConfig.getSentryDSN(), "Sentry DSN should not be nil")
    }

    func testThemeNameIsNotNil() {
        XCTAssertNotNil(appConfig.getThemeName(), "Theme Name should not be nil")
    }
    
    func testMinimumSignificantEventsIsNotNil() {
        XCTAssertNotNil(appConfig.getMinimumSignificantEvents(), "MinimumSignificantEvents be nil")
    }
    
    func getDaysBetweenPromptsIsNotNil() {
        XCTAssertNotNil(appConfig.getDaysBetweenPrompts(), "DaysBetweenPrompts should not be nil")
    }
    
    func testLoadingValidPlistFile() {
        XCTAssertNotNil(appConfig.getAPIKey(), "API Key should not be nil")
        XCTAssertNotNil(appConfig.getDeepgramKey(), "Deepgram Key should not be nil")
        XCTAssertNotNil(appConfig.getThemeName(), "Theme Name should not be nil")
        XCTAssertNotNil(appConfig.getSentryDSN(), "Sentry DSN should not be nil")
        XCTAssertNotNil(appConfig.getDaysBetweenPrompts(), "DaysBetweenPrompts should not be nil")
        XCTAssertNotNil(appConfig.getMinimumSignificantEvents(), "MinimumSignificantEvents be nil")
    }
}
