import XCTest
import StoreKit
@testable import Voice_AI

class ReviewRequesterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "reviewRequestCount")
        UserDefaults.standard.removeObject(forKey: "lastReviewRequestDate")
        UserDefaults.standard.removeObject(forKey: "significantEventsCount")
    }

    override func tearDown() {
        super.tearDown()
        UserDefaults.standard.removeObject(forKey: "reviewRequestCount")
        UserDefaults.standard.removeObject(forKey: "lastReviewRequestDate")
        UserDefaults.standard.removeObject(forKey: "significantEventsCount")
    }

//    TODO: this calls on shouldPromptForReview() which sets significantEventsCount to 0
//    func testLogSignificantEvent() {
//        let reviewRequester = ReviewRequester.shared
//        reviewRequester.logSignificantEvent()
//        XCTAssertEqual(reviewRequester.significantEventsCount, 1)
//        
//    }

    func testTryPromptForReview() {
        let reviewRequester = ReviewRequester.shared

        reviewRequester.tryPromptForReview()

        XCTAssertNotNil(reviewRequester.lastReviewRequestDate)
        XCTAssertEqual(reviewRequester.significantEventsCount, 0)
    }

}
