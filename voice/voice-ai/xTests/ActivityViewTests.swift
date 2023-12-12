
import XCTest
import SwiftUI
import Combine

@testable import Voice_AI

class ActivityViewTests: XCTestCase {

    func testActivityViewInitialization() {
        let isSharing = Binding(get: { false }, set: { newValue in
           // self.isSharing = newValue
        })
        let testItems = ["Check out Voice AI: Super-Intelligence app!", "https://apps.apple.com/ca/app/voice-ai-super-intelligence/id6470936896"]
        let activityView = ActivityView(activityItems: testItems, applicationActivities: nil, isSharing: isSharing)

        XCTAssertNotNil(activityView, "ActivityView should be initialized")
        XCTAssertEqual(activityView.activityItems as? [String], testItems, "Activity items did not match")
    }

}
