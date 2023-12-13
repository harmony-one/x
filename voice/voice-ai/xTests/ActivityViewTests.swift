
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
    
    func testActivityItemsIsEmpty() {
        // Arrange
        let activityItems: [Any] = []
        let applicationActivities: [UIActivity]? = []
        let isSharing = Binding(get: { false }, set: { newValue in
           // self.isSharing = newValue
        })
        
        // Act
        let viewController = ActivityView(activityItems: activityItems, applicationActivities: applicationActivities, isSharing: isSharing)
        
        // Assert
        XCTAssertTrue(viewController.activityItems.isEmpty)
    }
    
    func testIsSharingIsTtrue() {
        // Arrange
        let activityItems: [Any] = []
        let applicationActivities: [UIActivity]? = []
        let isSharing = Binding(get: { true }, set: { newValue in
           // self.isSharing = newValue
        })
        
        // Act
        let viewController = ActivityView(activityItems: activityItems, applicationActivities: applicationActivities, isSharing: isSharing)
        
        // Assert
        XCTAssertTrue(viewController.isSharing)
    }
    
    func testShareLinkUniqueId() {
        // Arrange
        let title = "Test Title"
        let url = URL(string: "https://www.example.com")!
        
        // Act
        let shareLink = ShareLink(title: title, url: url)
        
        // Assert
        XCTAssertNotNil(shareLink.id)
    }
    
    func testShareLinkTitleAndUrl() {
        // Arrange
        let title = "Test Title"
        let url = URL(string: "https://www.example.com")!
        
        // Act
        let shareLink = ShareLink(title: title, url: url)
        
        // Assert
        XCTAssertEqual(shareLink.title, title)
        XCTAssertEqual(shareLink.url, url)
    }
    
}
