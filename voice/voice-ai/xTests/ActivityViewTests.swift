
import XCTest
import UIKit

import SwiftUI
import Combine

@testable import Voice_AI


//final class MockActivityView: UIViewControllerRepresentable, ActivityViewProtocol {
//    var activityItems: [Any] = []
//    var applicationActivities: [UIActivity]? = nil
//    var isSharing: Bool = false
//
//    func makeUIViewController(context: Context) -> UIActivityViewController {
//        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
//        controller.completionWithItemsHandler = { _, _, _, _ in
//            self.isSharing = false  // Hide activity indicator when sharing is done
//        }
//        return controller
//    }
//
//    func updateUIViewController(_: UIActivityViewController, context: Context) {}
//}
//
//struct MockUIViewControllerRepresentableContext: UIViewControllerRepresentableContext<MockActivityView> {
//    func coordinator() -> Void { }
//}
//
//class MockContext: NSObject, UIViewControllerRepresentableContext<MockActivityView> {
//    var viewController: UIViewController?
//
//    init(viewController: UIViewController) {
//        self.viewController = viewController
//        super.init()
//    }
//
//    func presentationController(for activityItem: Any) -> UIViewController? {
//        // Return a mock presentation controller
//        return MockPresentationController()
//    }
//
//    func update(activityItem: Any, animated: Bool) {
//        // Do nothing
//    }
//
//    func completion(withItems items: [Any], animated: Bool) {
//        // Do nothing
//    }
//}
//
//class MockPresentationController: UIViewController {
//    // Do nothing
//}

//class MockViewController: UIViewController {
//    var representableContext: Any?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Your view controller's implementation
//        // You can access the `representableContext` property here
//    }
//}

//struct MockActivityView: UIViewControllerRepresentable {
//    typealias UIViewControllerType = MockViewController
//
//    func makeUIViewController(context: Context) -> MockViewController {
//        return MockViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: MockViewController, context: Context) {
//        // Access and use the context here
//        let representableContext = context.coordinator
//        // Perform any necessary updates based on the context
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator()
//    }
//
//    class Coordinator {
//        // Add any additional coordinator logic here
//    }
//}
//
//
//class MockViewController: UIViewController {
//    var representableContext: Any?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Your view controller's implementation
//        // You can access the `representableContext` property here
//    }
//}



class ActivityViewTests: XCTestCase {

//    class MockContext: UIViewControllerRepresentableContext<MockActivityView> {
//            // Implement any required properties or methods for testing
//            // For simplicity, an empty class is used here
//    }
//
//
//
//    func testMakeUIViewController() {
//        let isSharing = Binding(get: { false }, set: { newValue in
//           // self.isSharing = newValue
//        })
//        let testItems = ["Check out Voice AI: Super-Intelligence app!", "https://apps.apple.com/ca/app/voice-ai-super-intelligence/id6470936896"]
//        let activityView = ActivityView(activityItems: testItems, applicationActivities: nil, isSharing: isSharing)
//
//        // Call makeUIViewController with a mock context
//        let context = MockContext(coordinator: nil)
//
//        let viewController = activityView.makeUIViewController(context: context)
//
//        // Assert that the returned view controller is of the correct type
//        XCTAssertTrue(viewController is MockViewController)
//    }
//
//    func testMakeUIViewController() {
//           // Create an instance of ActivityView
//           let activityView = ActivityView()
//
//           // Create a mock context
//           let context = UIViewControllerRepresentableContext<ActivityView>(coordinator: activityView.makeCoordinator())
//
//           // Call makeUIViewController
//           let viewController = activityView.makeUIViewController(context: context)
//
//           // Assert that the returned view controller is of the correct type
//           XCTAssertTrue(viewController is MockViewController)
//       }

    
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
