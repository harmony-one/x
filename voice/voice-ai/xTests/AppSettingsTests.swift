import XCTest
@testable import Voice_AI

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
