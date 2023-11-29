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
    var handleCalled = false
    var isRecording = false
    var showUserGuide = false
    var resetCalled = false
    private var _isPressAndHoldActive = false
    private var _isTapToSpeakActive = false
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
            _isPressAndHoldActive = true
            startRecording()
        case .tapSpeak:
            _isTapToSpeakActive = true
            _isPressAndHoldActive = true
            startRecording()
        case .stopSpeak, .tapStopSpeak:
            _isPressAndHoldActive = false
            _isTapToSpeakActive = false
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
    
    func isPressAndHoldActive() -> Bool {
        return _isPressAndHoldActive
    }
    
    func isTapToSpeakActive() -> Bool {
        return _isTapToSpeakActive
    }
}
