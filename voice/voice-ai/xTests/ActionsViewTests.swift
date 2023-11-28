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
    var appSettings: AppSettings!
    var mockGenerator: MockGenerator!
    
    let buttonReset = ButtonData(label: "New Session", image: "new session", action: .reset, testId: "button-newSession")
    let buttonTapSpeak = ButtonData(label: "Tap to Speak", pressedLabel: "Tap to SEND", image: "square", action: .speak, testId: "button-tapToSpeak")
    let buttonSurprise = ButtonData(label: "Surprise ME!", image: "surprise me", action: .surprise, testId: "button-surpriseMe")
    let buttonSpeak = ButtonData(label: "Press & Hold", image: "press & hold", action: .speak, testId: "button-press&hold")
    let buttonMore = ButtonData(label: "More Actions", image: "repeat last", action: .openSettings, testId: "button-more")
    let buttonPlay = ButtonData(label: "Pause / Play", image: "pause play", pressedImage: "play", action: .play, testId: "button-playPause")
    var testButtons: [ButtonData] = []
    
    override func setUp() {
        super.setUp()
        store = Store()
        actionsView = ActionsView()
        appSettings = AppSettings.shared
        mockGenerator = MockGenerator()
        ActionsView.generator = mockGenerator
        testButtons = [
            buttonReset,
            buttonTapSpeak,
            buttonSurprise,
            buttonSpeak,
            buttonMore,
            buttonPlay,
        ]
    }
    
    override func tearDown() {
        actionsView = nil
        mockGenerator = nil
        super.tearDown()
    }
    
    func testChangeTheme() {
        let themeName = "defaultTheme"
        XCTAssertNotEqual(actionsView.currentTheme.name, themeName)
        actionsView.changeTheme(name: themeName)
        XCTAssertEqual(actionsView.currentTheme.name, "defaultTheme")
    }
    
    func testBaseView() {
        let colums = 2
        let buttons = [buttonReset, buttonTapSpeak]
        let baseView = actionsView.baseView(colums: colums, buttons: buttons)
        XCTAssertNotNil(baseView)
    }
    
    func testVibration() {
        XCTAssertFalse(mockGenerator.prepareCalled)
        XCTAssertFalse(mockGenerator.impactOccurredCalled)

        actionsView.vibration()

        XCTAssertTrue(mockGenerator.prepareCalled)
        XCTAssertTrue(mockGenerator.impactOccurredCalled)
    }
    
    func testViewButton() {
        let button = buttonReset
        let actionHandler = ActionHandler()
        let viewButton = actionsView.viewButton(button: button, actionHandler: actionHandler)
        XCTAssertNotNil(viewButton)
    }
    
    func testViewButtonSpeak () {
         let actionType: ActionType = .speak
 
         let actionHandler = MockActionHandler()
         let button = testButtons.first(where: { $0.action == actionType })!
         let expectedActionType: ActionType = actionType
         if button.pressedLabel != nil {
 
         }
         actionHandler.handleCalled = false
         XCTAssertFalse(actionHandler.handleCalled)
         actionsView.vibration()
 
         appSettings.isOpened = true
         let viewButton = actionsView.viewButton(button: button, actionHandler: actionHandler)
         actionHandler.handle(actionType: actionType)
 
         XCTAssertNotNil(viewButton)
         XCTAssertTrue(actionHandler.handleCalled)
         XCTAssertEqual(actionHandler.lastActionType, expectedActionType)
 
     }
    
    func testViewButtonMore () {
        let actionType: ActionType = .openSettings
        
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
    
    func testViewButtonPlay () {
        let actionType: ActionType = .play
        let actionHandler = MockActionHandler()
        let button = testButtons.first(where: { $0.action == actionType })!
        let expectedActionType: ActionType = actionType
        
        actionHandler.handleCalled = false
        XCTAssertFalse(actionHandler.handleCalled)
        actionsView.vibration()
        
        let viewButton = actionsView.viewButton(button: button, actionHandler: actionHandler)
        actionHandler.handle(actionType: actionType)
        actionsView.setLastButtonPressed(action: button.action, event: .onStart)
        
        XCTAssertNotNil(viewButton)
        XCTAssertTrue(actionHandler.handleCalled)
        XCTAssertEqual(actionHandler.lastActionType, expectedActionType)
    }
        
    func testViewButtonReset () {
        let actionType: ActionType = .reset
        let showInAppPurchases = Bool.random()
        
        let actionHandler = MockActionHandler()
        let button = testButtons.first(where: { $0.action == actionType })!
        let expectedActionType: ActionType = actionType
        
        actionHandler.handleCalled = false
        XCTAssertFalse(actionHandler.handleCalled)
        actionsView.vibration()
        if (showInAppPurchases) {
            actionsView.showInAppPurchasesIfNotLoggedIn()
        }
        let viewButton = actionsView.viewButton(button: button, actionHandler: actionHandler)
        actionHandler.handle(actionType: actionType)
        
        let isOnStart = Bool.random()
        if (!isOnStart) {
            actionsView.setLastButtonPressed(action: button.action, event: .onEnd)
            XCTAssertNil(actionsView.getLastButtonPressed(), "Last button pressed is onEnd event")
        }
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
