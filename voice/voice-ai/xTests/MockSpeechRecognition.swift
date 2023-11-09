//
//  MockSpeechRecognition.swift
//  Voice AITests
//
//  Created by Nagesh Kumar Mishra on 29/10/23.
//

import XCTest
import AVFoundation
@testable import Voice_AI


// Mock class that mimics the behavior of our SpeechRecognition class.
class MockSpeechRecognition: SpeechRecognitionProtocol {
    func cancelSpeak() {
        
    }
    
    var isPausedCalled: Bool = false
    var resetCalled: Bool = false
    var speakCalled: Bool = false
    var randomFactsCalled: Bool = false
    var continueSpeechCalled: Bool = false
    var pauseCalled: Bool = false
    var repeateCalled: Bool = false

    func pause(feedback: Bool?) {
        
    }
    
    func isPaused() -> Bool {
        isPausedCalled = true
        return false
    }

    func reset(feedback: Bool?) {
        resetCalled = true
    }

    func speak() {
        speakCalled = true
    }

    func randomFacts() {
        randomFactsCalled = true
    }

    func continueSpeech() {
        continueSpeechCalled = true
    }

    func pause() {
        pauseCalled = true
    }

    func repeate() {
        repeateCalled = true
    }
    
    func stopSpeak() {
        
    }
    
    func sayMore() {
    
    }
    
    
    func play() {
        if self.isPaused() {
            self.continueSpeech()
        } else {
            self.pause()
        }
        
    }
    
}
