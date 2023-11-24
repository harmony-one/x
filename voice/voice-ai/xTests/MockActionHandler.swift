//
//  MockActionHandler.swift
//  Voice AITests
//
//  Created by Francisco Egloff on 23/11/23.
//

import Foundation

class MockActionHandler: ActionHandlerProtocol {
    var handleCalled = false
    var isRecording = false
    var showUserGuide = false
    var _isPressAndHoldActive = false
    var _isTapToSpeakActive = false
    var isRepeated = false
    var isPlayed = false
    var isSurprised = false

    func handle(actionType: ActionType) {
        print("*********** handle ******")
        handleCalled = true
        switch actionType {
        case .reset:
            print("reset")
            // resetThrottler.send()
        case .surprise:
            print("*********** suprise ******")
            isSurprised = false
        case .play:
            isPlayed = true
        case .repeatLast:
            isRepeated = true
        case .speak:
            _isPressAndHoldActive = true
            startRecording()
        case .tapSpeak:
            _isTapToSpeakActive = true
            startRecording()
        case .stopSpeak, .tapStopSpeak:
            _isPressAndHoldActive = false
            _isTapToSpeakActive = false
            stopRecording()
        case .userGuide:
            showUserGuide = true
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
