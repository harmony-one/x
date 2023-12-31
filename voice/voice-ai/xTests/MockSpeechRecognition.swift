import AVFoundation
import Combine
@testable import Voice_AI
import XCTest

class MockSpeechRecognition: SpeechRecognitionProtocol {
    var isTriviaCalled: Bool = false
    var isPausedCalled: Bool = false
    var resetCalled: Bool = false
    var speakCalled: Bool = false
    var surpriseCalled: Bool = false
    var continueSpeechCalled: Bool = false
    var pauseCalled: Bool = false
    var repeateCalled: Bool = false
    
    private var _isPlaying = false
    private var _isPausing = false
    
    private var isPlayingSubject = PassthroughSubject<Bool, Never>()
    private var isPausingSubject = PassthroughSubject<Bool, Never>()

    // Define a custom publisher and use isPlayingSubject to emit values
    var isPlayingPublisher: AnyPublisher<Bool, Never> {
        return isPlayingSubject.eraseToAnyPublisher()
    }
    
    var isPausingPublisher: AnyPublisher<Bool, Never> {
        return isPausingSubject.eraseToAnyPublisher()
    }

    // Implement a method to update the value and notify subscribers
    func setIsPlaying(_ isPlaying: Bool) {
        _isPlaying = isPlaying
        isPlayingSubject.send(isPlaying)
    }
    
    func setIsPausing(_ isPausing: Bool) {
        _isPausing = isPausing
        isPausingSubject.send(isPausing)
    }
    
    func pause(feedback: Bool?) {}
    
    func surprise() {
        surpriseCalled = true
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
        speakCalled = false
    }

    
    func sayMore() {}
    
    func play() {
        if isPaused() {
            continueSpeech()
        } else {
            pause()
        }
    }
    
    func cancelRetry() {}
    
    func stopSpeak(cancel: Bool?) {}
    
    func cancelSpeak() {}

    func trivia() {
        isTriviaCalled = true
    }
    
    func playText(text: String) {}
    
    func talkToMe() {}
}
