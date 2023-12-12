import Foundation
import SwiftUI

class MockActionsView: ActionsViewProtocol {
    var showOpenSetting: Bool = false
    var showPurchaseDialog: Bool = false
    var showInAppPurchases: Bool = false
    var isVibrating: Bool = false
    var isSpeakButtonPressed: Bool = false
    var buttonsPortrait: [ButtonData] = []
    var lastButtonPressed: ActionType?
    
    init(actionHandler: ActionHandlerProtocol? = nil) {
        let buttonReset = ButtonData(label: "New Session", image: "new session", action: .reset, testId: "button-newSession")
        let buttonTapSpeak = ButtonData(label: "Tap to Speak", pressedLabel: "Tap to SEND", image: "square", action: .speak, testId: "button-tapToSpeak")
        let buttonSurprise = ButtonData(label: "Surprise ME!", image: "surprise me", action: .surprise, testId: "button-surpriseMe")
        let buttonSpeak = ButtonData(label: "Press & Hold", image: "press & hold", action: .speak, testId: "button-press&hold")
        let buttonMore = ButtonData(label: "More Actions", image: "repeat last", action: .openSettings, testId: "button-more")
        let buttonPlay = ButtonData(label: "Pause / Play", image: "pause play", pressedImage: "play", action: .play, testId: "button-playPause")
        
        buttonsPortrait = [
            buttonReset,
            buttonTapSpeak,
            buttonSurprise,
            buttonSpeak,
            /*buttonRepeat*/
            buttonMore,
            buttonPlay
        ]
    }
    
    func openSettingsApp() {
        self.showOpenSetting = true
    }
    
    func openPurchaseDialog() {
        self.showPurchaseDialog = true
    }
    
    func showInAppPurchasesIfNotLoggedIn() {
        self.showInAppPurchases = true
    }
    
    func vibration() {
        self.isVibrating = true
    }
    
    func setLastButtonPressed (action: ActionType, event: EventType?) {
        if event == .onStart {
            self.lastButtonPressed = action
        }
        
        if event == .onEnd {
            self.lastButtonPressed = nil
        }
    }
    
    func isButtonDisabled (action: ActionType) -> Bool {
        return (self.lastButtonPressed != nil) && self.lastButtonPressed != action
    }
    
    func getLastButtonPressed() -> ActionType? {
        return self.lastButtonPressed
    }
}

class MockActionHandler: ActionHandlerProtocol {
    @Published var isSynthesizing: Bool = false
    var isSynthesizingPublished: Published<Bool> { _isSynthesizing }
    var isSynthesizingPublisher: Published<Bool>.Publisher { $isSynthesizing }
    
    @Published var isRecording: Bool = false
    var isRecordingPublished: Published<Bool> { _isRecording }
    var isRecordingPublisher: Published<Bool>.Publisher { $isRecording }
    
    @Published var isTapToSpeakActive: Bool = false
    var isTapToSpeakActivePublished: Published<Bool> { _isTapToSpeakActive }
    var isTapToSpeakActivePublisher: Published<Bool>.Publisher { $isTapToSpeakActive }
    
    @Published var isPressAndHoldActive: Bool = false
    var isPressAndHoldActivePublished: Published<Bool> { _isPressAndHoldActive }
    var isPressAndHoldActivePublisher: Published<Bool>.Publisher { $isPressAndHoldActive }
    
    var handleCalled = false
    var showUserGuide = false
    var resetCalled = false
    
    var isRepeated = false
    var isPlayed: Bool = false
    var isSurprised = false
    var showOpenSettings = false
    var isTrivia = false

    func handle(actionType: ActionType) {
        handleCalled = true
        switch actionType {
        case .reset:
            resetCalled = true
            print("reset")
            // resetThrottler.send()
        case .surprise:
            isSurprised = true
        case .play:
            isPlayed = true
        case .repeatLast:
            isRepeated = true
        case .speak:
            isPressAndHoldActive = true
            startRecording()
        case .tapSpeak:
            isTapToSpeakActive = true
            isPressAndHoldActive = true
            startRecording()
        case .stopSpeak, .tapStopSpeak:
            isPressAndHoldActive = false
            isTapToSpeakActive = false
            stopRecording()
        case .userGuide:
            showUserGuide = true
        case .openSettings:
            showOpenSettings = true
        case .trivia:
            isTrivia = true
        }
    }
    
    func reset() {
        
    }
    
    func syncTapToSpeakState(_ actionType: ActionType) {
        
    }
//    func handle(actionType: ActionType)
    func startRecording() {
        isRecording = true
    }
    
    func stopRecording(cancel: Bool = false) {
        isRecording = false
    }

}
