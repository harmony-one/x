import XCTest
import SwiftUI
@testable import Voice_AI


//    //Given
//    //When
//    //Then

class ActionsViewTests: XCTestCase {
    var actionsView: ActionsView!
    var appSettings: AppSettings!
    var mockActionHandler: MockActionHandler = MockActionHandler()
    var store: Store!
    var sut: ActionsView! // UIViewController!
    let eventOptions: [EventType?] = [.onStart, .onEnd, nil]
    
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
        appSettings = AppSettings.shared
        
        // Initialize actionsView with the mockActionHandler
        actionsView = .init(actionHandler: mockActionHandler)
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
//        mockGenerator = nil
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
    
//    func testVibration() {
//        XCTAssertFalse(mockGenerator.prepareCalled)
//        XCTAssertFalse(mockGenerator.impactOccurredCalled)
//
//        actionsView.vibration()
//
//        XCTAssertTrue(mockGenerator.prepareCalled)
//        XCTAssertTrue(mockGenerator.impactOccurredCalled)
//    }
    
    func testViewButton() {
        let button = buttonReset
        let actionHandler = ActionHandler()
        let viewButton = actionsView.viewButton(button: button, actionHandler: actionHandler)
        XCTAssertNotNil(viewButton)
    }
         
    func getRandomEvent() -> EventType? {
        let eventOptions: [EventType?] = [.onStart, .onEnd, nil]
        return eventOptions.randomElement()!
    }

   
    func testViewButtonPlay () {
        let actionType: ActionType = .play
        
        let button = testButtons.first(where: { $0.action == actionType })!
        let viewButton = actionsView.viewButton(button: button, actionHandler: mockActionHandler)
        
        XCTAssertFalse(mockActionHandler.handleCalled)
        for event in eventOptions {
            actionsView.setLastButtonPressed(action: actionType, event: event)
            if (event != nil) {
                XCTAssertNotNil(event, "Play action return with event \(String(describing: event))")
            } else {
                actionsView.vibration()
                mockActionHandler.handle(actionType: actionType)
                XCTAssertTrue(mockActionHandler.isPlayed, "Action .play called")
            }
        }
        XCTAssertNil(actionsView.getLastButtonPressed(), "Last button pressed is nil")
        XCTAssertNotNil(viewButton)
    }
    
    func testViewButtonOpenSettings () {
        let actionType: ActionType = .openSettings
        
        let button = testButtons.first(where: { $0.action == actionType })!
        let viewButton = actionsView.viewButton(button: button, actionHandler: mockActionHandler)
        
        XCTAssertFalse(mockActionHandler.handleCalled)
        for event in eventOptions {
            actionsView.setLastButtonPressed(action: actionType, event: event)
            if (event != nil) {
                XCTAssertNotNil(event, "Play action return with event \(String(describing: event))")
            } else {
                actionsView.vibration()
                actionsView.openSettingsApp()
                mockActionHandler.handle(actionType: actionType)
                XCTAssertTrue(mockActionHandler.showOpenSettings, "Action .openSettings called")
            }
        }
        XCTAssertNil(actionsView.getLastButtonPressed(), "Last button pressed is nil")
        XCTAssertNotNil(viewButton)
    }
    
    func testViewButtonReset () {
        let actionType: ActionType = .openSettings

        let button = testButtons.first(where: { $0.action == actionType })!
        let viewButton = actionsView.viewButton(button: button, actionHandler: mockActionHandler)
        
        XCTAssertFalse(mockActionHandler.handleCalled)
        for event in eventOptions {
            actionsView.setLastButtonPressed(action: actionType, event: event)
            if (event != nil) {
                XCTAssertNotNil(event, "Play action return with event \(String(describing: event))")
            } else {
                actionsView.vibration()
                mockActionHandler.handle(actionType: actionType)
                
                actionsView.showInAppPurchasesIfNotLoggedIn()
                
                XCTAssertTrue(mockActionHandler.resetCalled, "Action .reset called")
            }
        }
        XCTAssertNil(actionsView.getLastButtonPressed(), "Last button pressed is nil")
        XCTAssertNotNil(viewButton)
    }
    
    
//    func testViewButtonPlayNil () {
//        let actionType: ActionType = .play
//        let button = testButtons.first(where: { $0.action == actionType })!
//        let viewButton = actionsView.viewButton(button: button, actionHandler: mockActionHandler)
//       
//        let event: EventType? = nil // getRandomEvent()
//        XCTAssertFalse(mockActionHandler.handleCalled)
//        actionsView.setLastButtonPressed(action: actionType, event: event)
//        if (event != nil) {
//            XCTAssertNotNil(event, "Play action return")
//        } else {
//            actionsView.vibration()
//            mockActionHandler.handle(actionType: actionType)
//            XCTAssertTrue(mockActionHandler.isPlayed, "Action .play called")
//        }
//        XCTAssertNotNil(viewButton)
//    }
    
//    func testViewButtonReset () {
//        let actionType: ActionType = .reset
//        let showInAppPurchases = Bool.random()
//        
//        let actionHandler = MockActionHandler()
//        let button = testButtons.first(where: { $0.action == actionType })!
//        let expectedActionType: ActionType = actionType
//        
//        actionHandler.handleCalled = false
//        XCTAssertFalse(actionHandler.handleCalled)
//        actionsView.vibration()
//        if (showInAppPurchases) {
//            actionsView.showInAppPurchasesIfNotLoggedIn()
//        }
//        let viewButton = actionsView.viewButton(button: button, actionHandler: actionHandler)
//        actionHandler.handle(actionType: actionType)
//        
//        let isOnStart = Bool.random()
//        if (!isOnStart) {
//            actionsView.setLastButtonPressed(action: button.action, event: .onEnd)
//            XCTAssertNil(actionsView.getLastButtonPressed(), "Last button pressed is onEnd event")
//        }
//        XCTAssertNotNil(viewButton)
//        XCTAssertTrue(actionHandler.handleCalled)
//        XCTAssertEqual(actionHandler.lastActionType, expectedActionType)
//    }
    

//    func testRequestReview() {
//        actionsView.requestReview()
//        // Test that the requestReview function does not throw any errors
//    }
    
    func testHandleOtherActions() async {
        await actionsView.handleOtherActions(actionType: .reset)
        // Test that the handleOtherActions function does not throw any errors
    }
    
    func testCheckUserAuthentication() {
        actionsView.checkUserAuthentication()
        // Test that the checkUserAuthentication function does not throw any errors
    }
}
