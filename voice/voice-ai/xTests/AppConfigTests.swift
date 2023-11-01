import XCTest
@testable import Voice_AI

class AppConfigTests: XCTestCase {
    
    var appConfig: AppConfig!
    
    override func setUp() {
        super.setUp()
        appConfig = AppConfig()
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

    func testLoadingValidPlistFile() {
        XCTAssertNotNil(appConfig.getAPIKey(), "API Key should not be nil")
        XCTAssertNotNil(appConfig.getDeepgramKey(), "Deepgram Key should not be nil")
    }
}
