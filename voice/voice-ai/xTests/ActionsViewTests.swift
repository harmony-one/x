import XCTest
import SwiftUI
@testable import Voice_AI


//    //Given
//    //When
//    //Then
class MockActionHandler: ActionHandler {
    var handleCalled = false
    var lastActionType: ActionType?

    override func handle(actionType: ActionType) {
        handleCalled = true
        lastActionType = actionType
    }
}


class ActionsViewTests: XCTestCase {
    
    var actionsView: ActionsView!
    
    override func setUp() {
        super.setUp()
        actionsView = ActionsView()
//        _ = actionsView.environmentObject(Store())
    }
    
    override func tearDown() {
        actionsView = nil
        super.tearDown()
    }
    
    func testChangeTheme() {
        actionsView.changeTheme(name: "defaultTheme")
        XCTAssertEqual(actionsView.currentTheme.name, "defaultTheme")
    }
    
    func testBaseView() {
        let colums = 2
        let buttons = [
            ButtonData(label: "Button 1", image: "image1", action: .reset),
            ButtonData(label: "Button 2", image: "image2", action: .speak)
        ]
        let baseView = actionsView.baseView(colums: colums, buttons: buttons)
        XCTAssertNotNil(baseView)
    }
    
    func testVibration() {
        actionsView.vibration()
        // Test that the vibration function does not throw any errors
    }
    
    func testViewButton() {
        let button = ButtonData(label: "Button", image: "image", action: .reset)
        let actionHandler = ActionHandler()
        let viewButton = actionsView.viewButton(button: button, actionHandler: actionHandler)
        XCTAssertNotNil(viewButton)
    }
    
    
//    func testViewButtonClosure1() {
//        
//        let actionHandler = MockActionHandler()
//        let button = ButtonData(label: "Test Button", image: "", action: .repeatLast)
//        let expectedActionType: ActionType = .repeatLast
//        
//        actionHandler.handleCalled = false
//        
//        let viewButton = actionsView.viewButton(button: button, actionHandler: actionHandler)
//        actionHandler.handle(actionType: .repeatLast)
//        
//        XCTAssertNotNil(viewButton)
//        XCTAssertTrue(actionHandler.handleCalled)
//        XCTAssertEqual(actionHandler.lastActionType, .repeatLast)
//        
//    }
    
    func testOpenSettingsApp() {
        actionsView.openSettingsApp()
        // Test that the openSettingsApp function does not throw any errors
    }
    
    func testRequestReview() {
        actionsView.requestReview()
        // Test that the requestReview function does not throw any errors
    }
    
    func testHandleOtherActions() async {
        await actionsView.handleOtherActions(actionType: .reset)
        // Test that the handleOtherActions function does not throw any errors
    }
    
    func testCheckUserAuthentication() {
        actionsView.checkUserAuthentication()
        // Test that the checkUserAuthentication function does not throw any errors
    }
    
    func testShowPurchaseDiglog() {
        actionsView.showPurchaseDiglog()
        // Test that the showPurchaseDiglog function does not throw any errors
    }
    
    // Add more test cases for other functions and properties in the ActionsView struct
    
}




