import XCTest
@testable import Voice_AI
import Mixpanel

class AppSettingsTests: XCTestCase {
    func testGetEpochWithValidDateString() {
        let dateString = "2023-12-14T22:15:00.000Z"
        let epoch = AppSettings.getEpoch(dateString: dateString)
        XCTAssertNotNil(epoch)
    }

    func testGetEpochWithInvalidDateString() {
        let dateString = "InvalidDate"
        let epoch = AppSettings.getEpoch(dateString: dateString)
        XCTAssertNil(epoch)
    }

    func testGetEpochWithNilDateString() {
        let epoch = AppSettings.getEpoch(dateString: nil)
        XCTAssertNil(epoch)
    }

    func testIsDateStringInFutureWithValidDateString() {
        let dateString = "2024-01-01T00:00:00.000Z"
        XCTAssertTrue(AppSettings.isDateStringInFuture(dateString))
    }

    func testIsDateStringInFutureWithPastDateString() {
        let dateString = "2022-01-01T00:00:00.000Z"
        XCTAssertFalse(AppSettings.isDateStringInFuture(dateString))
    }

    func testIsDateStringInFutureWithInvalidDateString() {
        let dateString = "InvalidDate"
        XCTAssertFalse(AppSettings.isDateStringInFuture(dateString))
    }

}

class MixpanelManagerTests: XCTestCase {
//    
//    override func setUp() {
//        super.setUp()
//        // Initialize Mixpanel for testing (You may need to set up a test token)
//        Mixpanel.initialize(token: "your_test_mixpanel_token", trackAutomaticEvents: false)
//    }
//
//    override func tearDown() {
//        // Clean up any Mixpanel state after each test
//        Mixpanel.mainInstance().reset()
//        super.tearDown()
//    }
    
    func testTrackEvent() {
        let mixpanelManager = MixpanelManager.shared
        let eventName = "Test Event"
        let eventProperties: [String: MixpanelType] = ["Key1": "Value1", "Key2": 42]
        
        mixpanelManager.trackEvent(name: eventName, properties: eventProperties)

        
    }
}

