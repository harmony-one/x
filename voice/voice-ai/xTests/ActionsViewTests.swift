import XCTest
import SwiftUI
@testable import Voice_AI


//    //Given
//    //When
//    //Then

class ActionsViewTests: XCTestCase {
    var actionsView: ActionsView!
    
    var mockActionsView: MockActionsView!
    var mockActionHandler: MockActionHandler = MockActionHandler()

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

        mockActionsView = MockActionsView()
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
    
    func testViewButtonDisabled() {
        for button in testButtons {
            let viewButton = actionsView.viewButton(button: button, actionHandler: mockActionHandler)
            actionsView.setLastButtonPressed(action: button.action, event: nil)
            let disabled = actionsView.isButtonDisabled(action: button.action)
            XCTAssertFalse(disabled, "Button disabled")
            XCTAssertNotNil(viewButton)
        }
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
                mockActionsView.vibration()
                mockActionHandler.handle(actionType: actionType)
                XCTAssertTrue(mockActionHandler.isPlayed, "Action .play called")
                XCTAssertTrue(mockActionsView.isVibrating, "The phone is vibrating")
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
                XCTAssertNotNil(event, "OpenSettings action return with event \(String(describing: event))")
            } else {
                mockActionsView.vibration()
                mockActionHandler.handle(actionType: actionType)
                mockActionsView.openSettingsApp()
                XCTAssertTrue(mockActionHandler.showOpenSettings, "Action .openSettings called")
                XCTAssertTrue(mockActionsView.showOpenSetting, "Open Settings Menu opened")
                XCTAssertTrue(mockActionsView.isVibrating, "The phone is vibrating")
            }
        }
        XCTAssertNil(actionsView.getLastButtonPressed(), "Last button pressed is nil")
        XCTAssertNotNil(viewButton)
    }
    
    func testCreateSpeakButtonTapToSpeak() {
        var  actionType: ActionType = .speak
        let button = testButtons.first(where: { $0.action == actionType })!
        let viewButton = actionsView.viewButton(button: button, actionHandler: mockActionHandler)
        for event in eventOptions {
            if (event != nil) {
                XCTAssertNotNil(event, "Speak action return with event \(String(describing: event))")
            } else {
                actionType = .tapSpeak
                mockActionsView.vibration()
                mockActionHandler.handle(actionType: actionType)
                XCTAssertTrue(mockActionHandler.isPressAndHoldActive(), "Action .tapSpeak press and hold active")
                XCTAssertTrue(mockActionHandler._isTapToSpeakActive, "Action .tapSpeak tap to speak active")
                XCTAssertTrue(mockActionHandler.isRecording, "Start recording")
                actionType = .stopSpeak
                mockActionHandler.handle(actionType: actionType)
                XCTAssertFalse(mockActionHandler.isPressAndHoldActive(), "Action .stopSpeak press and hold inactive")
                XCTAssertFalse(mockActionHandler._isTapToSpeakActive, "Action .stopSpeak called")
                XCTAssertFalse(mockActionHandler.isRecording, "Stop recording")
                XCTAssertTrue(mockActionsView.isVibrating, "The phone is vibrating")
            }
        }
    }
    
    func testCreateSpeakButtonSimultaneousGesture() {
        var  actionType: ActionType = .speak
        for event in eventOptions {
            if (event == .onStart) {
                actionsView.setLastButtonPressed(action: actionType, event: event)
                mockActionHandler.handle(actionType: actionType)
                XCTAssertTrue(mockActionHandler.isPressAndHoldActive(), "Action .speak press and hold active")
                XCTAssertTrue(mockActionHandler.isRecording, "Start recording")
            } else if (event == .onEnd) {
                actionsView.setLastButtonPressed(action: actionType, event: event)
                actionType = .stopSpeak
                mockActionHandler.handle(actionType: actionType)
                XCTAssertFalse(mockActionHandler.isPressAndHoldActive(), "Action .stopSpeak press and hold inactive")
                XCTAssertFalse(mockActionHandler.isRecording, "Stop recording")
            }
        }
    }
    
    func testViewButtonReset () {
        let actionType: ActionType = .reset

        let button = testButtons.first(where: { $0.action == actionType })!
        let viewButton = actionsView.viewButton(button: button, actionHandler: mockActionHandler)
        
        for event in eventOptions {
            actionsView.setLastButtonPressed(action: actionType, event: event)
            if (event != nil) {
                XCTAssertNotNil(event, "Reset action return with event \(String(describing: event))")
            } else {
                mockActionsView.vibration()
                mockActionHandler.handle(actionType: actionType)
                mockActionsView.showInAppPurchasesIfNotLoggedIn()
                XCTAssertTrue(mockActionsView.showInAppPurchases, "In App Purchases")
                XCTAssertTrue(mockActionHandler.resetCalled, "Action .reset called")
                XCTAssertTrue(mockActionsView.isVibrating, "The phone is vibrating")
            }
        }
        XCTAssertNil(actionsView.getLastButtonPressed(), "Last button pressed is nil")
        XCTAssertNotNil(viewButton)
    }
    
    func testViewButtonSurprise () {
        let actionType: ActionType = .surprise

        let button = testButtons.first(where: { $0.action == actionType })!
        let viewButton = actionsView.viewButton(button: button, actionHandler: mockActionHandler)
 
        for event in eventOptions {
            actionsView.setLastButtonPressed(action: actionType, event: event)
            if (event != nil) {
                XCTAssertNotNil(event, "Surprise action return with event \(String(describing: event))")
            } else {
                
                mockActionsView.vibration()
                mockActionHandler.handle(actionType: actionType)
    
                XCTAssertTrue(mockActionHandler.isSurprised, "Action .surprise called")
                XCTAssertTrue(mockActionsView.isVibrating, "The phone is vibrating")
            }
        }
        XCTAssertNil(actionsView.getLastButtonPressed(), "Last button pressed is nil")
        XCTAssertNotNil(viewButton)
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
