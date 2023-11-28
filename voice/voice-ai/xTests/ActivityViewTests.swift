
import XCTest
@testable import Voice_AI


class ActivityViewTests: XCTestCase {

    func testActivityViewInitialization() {
        let testItems = ["Check out Voice AI: Super-Intelligence app!", "https://apps.apple.com/ca/app/voice-ai-super-intelligence/id6470936896"]
        let activityView = ActivityView(activityItems: testItems, applicationActivities: nil)

        XCTAssertNotNil(activityView, "ActivityView should be initialized")
        XCTAssertEqual(activityView.activityItems as? [String], testItems, "Activity items did not match")
    }

}
