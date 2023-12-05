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
    var mixpanelManager: MixpanelManager!
        
    override func setUp() {
        super.setUp()
        mixpanelManager = MixpanelManager.shared
    }

    override func tearDown() {
        mixpanelManager = nil
        super.tearDown()
    }
    
    func testTrackEvent() {
        let eventName = "Test Event"
        let eventProperties: [String: MixpanelType] = ["Key1": "Value1", "Key2": 42]

        let expectation = XCTestExpectation(description: "Event tracking completed")
        mixpanelManager.trackEvent(name: eventName, properties: eventProperties)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        let lastTrackedEvent = mixpanelManager.getLastTrackedEvent()
        XCTAssertEqual(lastTrackedEvent, eventName)
    }
}

