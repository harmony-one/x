import XCTest
import SwiftUI
@testable import Voice_AI


//extension UIView {
//    func findView<T>(ofType type: T.Type) -> T? where T: UIView {
//        return subviews.compactMap { $0 as? T ?? $0.findView(ofType: T.self) }.first
//    }
//}

//    //Given
//    //When
//    //Then


func findGridButton(for actionType: ActionType, in actionsView: ActionsView, callback: (any View) -> Void) {
    let _ = actionsView.baseView(colums: 2, buttons: []) // Ensure the view is loaded

    // Simulate a tap on the "Surprise ME!" button
    for button in actionsView.buttonsPortrait {
        actionsView.viewButton(button: button, actionHandler: MockActionHandler()) { view in
            callback(view)
        }
    }
}

class ActionsViewTests: XCTestCase {
    var actionsView: ActionsView!
    var appSettings: AppSettings!
    var mockActionHandler: MockActionHandler = MockActionHandler()
    var store: Store!
    var sut: ActionsView! // UIViewController!
    
    let buttonReset = ButtonData(label: "New Session", image: "new session", action: .reset, testId: "button-newSession")
    let buttonTapSpeak = ButtonData(label: "Tap to Speak", pressedLabel: "Tap to SEND", image: "square", action: .speak, testId: "button-tapToSpeak")
    let buttonSurprise = ButtonData(label: "Surprise ME!", image: "surprise me", action: .surprise, testId: "button-surpriseMe")
    let buttonSpeak = ButtonData(label: "Press & Hold", image: "press & hold", action: .speak, testId: "button-press&hold")
//    let buttonRepeat = ButtonData(label: "More Actions", image: "repeat last", action: .repeatLast, testId: "button-repeatLast")
    let buttonMore = ButtonData(label: "More Actions", image: "more action", action: .repeatLast, testId: "button-repeatLast")
    let buttonPlay = ButtonData(label: "Pause / Play", image: "pause play", pressedImage: "play", action: .play, testId: "button-playPause")
    var testButtons: [ButtonData] = []
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "ActionsView") as? ActionsView
        store = Store()
        appSettings = AppSettings.shared
        // Initialize actionsView with the mockActionHandler
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
    

    func testVewButtonSurprise () {
        let actionType: ActionType = .surprise

        guard let sut = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ActionsView") as? ActionsView else {
            XCTFail("Failed to instantiate the view controller")
            return
        }
        let button = testButtons.first(where: { $0.action == actionType })!
        _ = sut.baseView(colums: 2, buttons:testButtons)
        let gridButton:GridButton = sut.viewButton(button: button, actionHandler: self.mockActionHandler) as! GridButton
        
        gridButton.action() //.sendAction(for: .touchUpInside)

        XCTAssertTrue(mockActionHandler.isSurprised)

    }

//    func testOpenSettingsApp() {
//        actionsView.openSettingsApp()
//        // Test that the openSettingsApp function does not throw any errors
//    }
//    
     
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
