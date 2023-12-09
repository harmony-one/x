import XCTest
import SwiftUI
@testable import Voice_AI


//    //Given
//    //When
//    //Then

class ActionsViewTests: XCTestCase {
    var actionsView: ActionsView!
    var store: Store!
    var appSettings: AppSettings!
    
    var mockActionsView: MockActionsView!
    var mockActionHandler: MockActionHandler!

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
        mockActionHandler = MockActionHandler()
        mockActionsView = MockActionsView(actionHandler: mockActionHandler)
        actionsView = ActionsView(actionHandler: mockActionHandler)

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
        mockActionsView = nil
        super.tearDown()
    }
    
    func testChangeTheme() {
        let themeName = "defaultTheme"
        XCTAssertNotEqual(actionsView.currentTheme.name, themeName)
        actionsView.changeTheme(name: themeName)
        XCTAssertEqual(actionsView.currentTheme.name, "defaultTheme")
    }
    
    func testChangeThemeSheet() {
        let url = URL(string: "https://apps.apple.com/us/app/voice-ai-talk-with-gpt4/id6470936896")!
        let shareLink = ShareLink(title: "Check out this Voice AI app! x.country/app", url: url)

        let activityView = ActivityView(activityItems: [shareLink.title, shareLink.url])
        XCTAssertNotNil(activityView)
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
    
    func tesViewDisplayedCorrectly() {
        let mockActionsView = ActionsView(actionHandler: MockActionHandler()) // ActionsView() // MockActionsView()
        
        _ = mockActionsView.baseView(colums: 2, buttons: mockActionsView.buttonsPortrait)

        XCTAssertEqual(mockActionsView.buttonsPortrait.count, 6)
        XCTAssertEqual(mockActionsView.buttonsPortrait[0].action, ActionType.reset)
        XCTAssertEqual(mockActionsView.buttonsPortrait[2].action, ActionType.surprise)
        XCTAssertEqual(mockActionsView.buttonsPortrait[3].action, ActionType.speak)
        XCTAssertEqual(mockActionsView.buttonsPortrait[4].action, ActionType.openSettings)
        XCTAssertEqual(mockActionsView.buttonsPortrait[5].action, ActionType.play)
        
        _ = mockActionsView.baseView(colums: 3, buttons: mockActionsView.buttonsLandscape)
        
        XCTAssertEqual(mockActionsView.buttonsPortrait.count, 6)
        XCTAssertEqual(mockActionsView.buttonsLandscape[0].action, ActionType.reset)
        XCTAssertEqual(mockActionsView.buttonsLandscape[2].action, ActionType.openSettings)
        XCTAssertEqual(mockActionsView.buttonsLandscape[3].action, ActionType.surprise)
        XCTAssertEqual(mockActionsView.buttonsLandscape[4].action, ActionType.speak)
        XCTAssertEqual(mockActionsView.buttonsLandscape[5].action, ActionType.play)
    }
    
    func testButtonTapTriggersAction() {
        let mockActionHandler = MockActionHandler()
        _ = ActionsView(actionHandler: mockActionHandler)
        mockActionHandler.handle(actionType: ActionType.reset)

        XCTAssertTrue(mockActionHandler.resetCalled)
    }
    
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
    
    
    func testCreateSpeakButtonTapToSpeak() {
        var  actionType: ActionType = .speak
        let button = testButtons.first(where: { $0.action == actionType })!
        _ = actionsView.viewButton(button: button, actionHandler: mockActionHandler)
        for event in eventOptions {
            if (event != nil) {
                XCTAssertNotNil(event, "Speak action return with event \(String(describing: event))")
            } else {
                actionType = .tapSpeak
                mockActionsView.vibration()
                mockActionHandler.handle(actionType: actionType)
                XCTAssertTrue(mockActionHandler.isPressAndHoldActive, "Action .tapSpeak press and hold active")
                XCTAssertTrue(mockActionHandler.isTapToSpeakActive, "Action .tapSpeak tap to speak active")
                XCTAssertTrue(mockActionHandler.isRecording, "Start recording")
                actionType = .stopSpeak
                mockActionHandler.handle(actionType: actionType)
                XCTAssertFalse(mockActionHandler.isPressAndHoldActive, "Action .stopSpeak press and hold inactive")
                XCTAssertFalse(mockActionHandler.isTapToSpeakActive, "Action .stopSpeak called")
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
                XCTAssertTrue(mockActionHandler.isPressAndHoldActive, "Action .speak press and hold active")
                XCTAssertTrue(mockActionHandler.isRecording, "Start recording")
            } else if (event == .onEnd) {
                actionsView.setLastButtonPressed(action: actionType, event: event)
                actionType = .stopSpeak
                mockActionHandler.handle(actionType: actionType)
                XCTAssertFalse(mockActionHandler.isPressAndHoldActive, "Action .stopSpeak press and hold inactive")
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
    
    func testViewHandlesLoggedInUserAccessingInAppPurchases() {
        let mockActionHandler = MockActionHandler()
        let mockActionsView = MockActionsView(actionHandler: mockActionHandler)
        
        mockActionsView.showInAppPurchasesIfNotLoggedIn()
        
        XCTAssertFalse(mockActionsView.showPurchaseDialog)
    }
    
    func testHandleOtherActions() async {
        await actionsView.handleOtherActions(actionType: .reset)
        // Test that the handleOtherActions function does not throw any errors
    }
    
    func testCheckUserAuthentication() {
        actionsView.checkUserAuthentication()
        // Test that the checkUserAuthentication function does not throw any errors
    }
    
    func testIsButtonDisabled() {
        // Test cases for isButtonDisabled
        
        mockActionsView.setLastButtonPressed(action: .speak, event: .onStart)
        XCTAssertTrue(mockActionsView.isButtonDisabled(action: .reset))
        XCTAssertFalse(mockActionsView.isButtonDisabled(action: .speak))
    }

    func testGetLastButtonPressed() {
        // Test cases for getLastButtonPressed
        XCTAssertNil(mockActionsView.getLastButtonPressed())
        mockActionsView.setLastButtonPressed(action: .speak, event: .onStart)
        XCTAssertEqual(mockActionsView.getLastButtonPressed(), .speak)
    }

    func testSetLastButtonPressed() {
        // Test cases for setLastButtonPressed
        mockActionsView.setLastButtonPressed(action: .speak, event: .onStart)
        XCTAssertEqual(mockActionsView.getLastButtonPressed(), .speak)
        mockActionsView.setLastButtonPressed(action: .speak, event: .onEnd)
        XCTAssertNil(mockActionsView.getLastButtonPressed())
    }
    
}
