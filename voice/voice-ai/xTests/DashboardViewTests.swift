import XCTest
@testable import Voice_AI

class DashboardViewTests: XCTestCase {
    
    var dashboardView: DashboardView!

    override func setUp() {
        super.setUp()
        dashboardView = DashboardView()
    }

    override func tearDown() {
        dashboardView = nil
        super.tearDown()
    }

    func testDashboardViewInitialization() {
        XCTAssertNotNil(dashboardView, "DashboardView should be initialized")
    }
}
