//
//  MockActionHandler.swift
//  Voice AITests
//
//  Created by Francisco Egloff on 23/11/23.
//

import Foundation


class MockActionsView: ActionsViewProtocol {
    var showOpenSetting: Bool = false
    var showPurchaseDialog: Bool = false
    var showInAppPurchases: Bool = false
    var isVibrating: Bool = false
    
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
