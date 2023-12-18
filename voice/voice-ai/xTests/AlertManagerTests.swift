import XCTest
@testable import Voice_AI

class MockViewController: UIViewController {
    var showAlertExpectation: XCTestExpectation?
    var alertTitle: String?
    var alertMessage: String?
    var alertActions: [UIAlertAction] = []

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        if let alert = viewControllerToPresent as? UIAlertController {
            alertTitle = alert.title
            alertMessage = alert.message
            alertActions = alert.actions
            showAlertExpectation?.fulfill()
        }
    }
}

class AlertManagerTests: XCTestCase {

    var alertManager: AlertManager!
    var mockViewController: MockViewController!

    override func setUp() {
        super.setUp()
        mockViewController = MockViewController()
        alertManager = AlertManager(viewControllerProvider: { [weak self] in
            return self?.mockViewController
        })
    }

    func testShowAlertForSettings() {
        let expectation = self.expectation(description: "Show alert expectation")

        let testTitle = "Test Title"
        let testMessage = "Test Message"
        let testAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        mockViewController.showAlertExpectation = expectation

        alertManager.showAlertForSettings(title: testTitle, message: testMessage, actions: [testAction])

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertEqual(mockViewController.alertTitle, testTitle)
        XCTAssertEqual(mockViewController.alertMessage, testMessage)
        XCTAssertEqual(mockViewController.alertActions.count, 1)
        XCTAssertEqual(mockViewController.alertActions.first?.title, "OK")
    }
}

