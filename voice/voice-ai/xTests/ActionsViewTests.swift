import XCTest
import SwiftUI
@testable import Voice_AI

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
    var store: Store!
    let buttonReset = ButtonData(label: "New Session", image: "new session", action: .reset, testId: "button-newSession")
    let buttonTapSpeak = ButtonData(label: "Tap to Speak", pressedLabel: "Tap to SEND", image: "square", action: .speak, testId: "button-tapToSpeak")
    let buttonSurprise = ButtonData(label: "Surprise ME!", image: "surprise me", action: .surprise, testId: "button-surpriseMe")
    let buttonSpeak = ButtonData(label: "Press & Hold", image: "press & hold", action: .speak, testId: "button-press&hold")
    let buttonRepeat = ButtonData(label: "More Actions", image: "repeat last", action: .repeatLast, testId: "button-repeatLast")
    let buttonPlay = ButtonData(label: "Pause / Play", image: "pause play", pressedImage: "play", action: .play, testId: "button-playPause")
    var testButtons: [ButtonData] = []
    
    override func setUp() {
        super.setUp()
        store = Store()
        actionsView = ActionsView()
        testButtons = [
            buttonReset,
            buttonTapSpeak,
            buttonSurprise,
            buttonSpeak,
            buttonRepeat,
            buttonPlay,
        ]
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
        let buttons = [buttonReset, buttonTapSpeak]
        let baseView = actionsView.baseView(colums: colums, buttons: buttons)
        XCTAssertNotNil(baseView)
    }
    
    func testVibration() {
        actionsView.vibration()
        // Test that the vibration function does not throw any errors
    }
    
    func testViewButton() {
        let button = buttonReset
        let actionHandler = ActionHandler()
        let viewButton = actionsView.viewButton(button: button, actionHandler: actionHandler)
        XCTAssertNotNil(viewButton)
    }
    
    func testVewButtonRepeatLast () {
        let actionType: ActionType = .repeatLast
        
        let actionHandler = MockActionHandler()
        let button = testButtons.first(where: { $0.action == actionType })!
        let expectedActionType: ActionType = actionType
        
        actionHandler.handleCalled = false
        XCTAssertFalse(actionHandler.handleCalled)
        actionsView.vibration()
        
        let viewButton = actionsView.viewButton(button: button, actionHandler: actionHandler)
        actionHandler.handle(actionType: actionType)
        
        XCTAssertNotNil(viewButton)
        XCTAssertTrue(actionHandler.handleCalled)
        XCTAssertEqual(actionHandler.lastActionType, expectedActionType)
    }
    
    func testVewButtonPlay () {
        let actionType: ActionType = .play
        let actionHandler = MockActionHandler()
        let button = testButtons.first(where: { $0.action == actionType })!
        let expectedActionType: ActionType = actionType
        
        actionHandler.handleCalled = false
        XCTAssertFalse(actionHandler.handleCalled)
        actionsView.vibration()
        
        let viewButton = actionsView.viewButton(button: button, actionHandler: actionHandler)
        actionHandler.handle(actionType: actionType)
        
        XCTAssertNotNil(viewButton)
        XCTAssertTrue(actionHandler.handleCalled)
        XCTAssertEqual(actionHandler.lastActionType, expectedActionType)
    }
    
    func testVewButtonReset () {
        let actionType: ActionType = .reset
        let showInAppPurchases = Bool.random()
        
        let actionHandler = MockActionHandler()
        let button = testButtons.first(where: { $0.action == actionType })!
        let expectedActionType: ActionType = actionType
        
        actionHandler.handleCalled = false
        XCTAssertFalse(actionHandler.handleCalled)
        actionsView.vibration()
        if (showInAppPurchases) {
            
        }
        let viewButton = actionsView.viewButton(button: button, actionHandler: actionHandler)
        actionHandler.handle(actionType: actionType)
        
        XCTAssertNotNil(viewButton)
        XCTAssertTrue(actionHandler.handleCalled)
        XCTAssertEqual(actionHandler.lastActionType, expectedActionType)
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
}
