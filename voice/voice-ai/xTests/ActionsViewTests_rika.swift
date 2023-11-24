import XCTest
@testable import Voice_AI

//class ActionsViewTests2: XCTestCase {
//    var actionsView: ActionsView!
//    var appSettings: AppSettings!
//    var mockGenerator: MockGenerator!
//
//    override func setUp() {
//        super.setUp()
//        appSettings = AppSettings()
//        actionsView = ActionsView()
//        mockGenerator = MockGenerator()
//        ActionsView.generator = mockGenerator
//    }
//
//    override func tearDown() {
//        actionsView = nil
//        appSettings = nil
//        mockGenerator = nil
//        super.tearDown()
//    }
//
//    func testInitialization() {
//        // Test the initialization of the ActionsView instance
//        XCTAssertNotNil(actionsView)
//        // You can add more assertions for properties and states here
//    }
//
//    func testChangeTheme() {
//        let themeName = "defaultTheme"
//        XCTAssertNotEqual(actionsView.currentTheme.name, themeName)
//        actionsView.changeTheme(name: themeName)
//        XCTAssertEqual(actionsView.currentTheme.name, themeName)
//    }
//
//    func testVibration() {
//        XCTAssertFalse(mockGenerator.prepareCalled)
//        XCTAssertFalse(mockGenerator.impactOccurredCalled)
//
//        actionsView.vibration()
//
//        XCTAssertTrue(mockGenerator.prepareCalled)
//        XCTAssertTrue(mockGenerator.impactOccurredCalled)
//    }
//
////    func testOpenSettingsApp() {
////        XCTAssertFalse(actionsView.appSettings.isOpened)
////
////        actionsView.openSettingsApp()
////
////        XCTAssertTrue(actionsView.appSettings.isOpened)
////    }
////
////    func testHandleOtherActions() async {
////    }
////
////    func testCheckUserAuthentication() {
////    }
////
////    func testShowPurchaseDialog() {
////    }
////
////    func testShowInAppPurchasesIfNotLoggedIn() {
////    }
//}
