import AVFoundation

class MockAVSpeechSynthesizer: AVSpeechSynthesizer {
    var isSpeakingStub: Bool = false
    var isPausedStub: Bool = false
    var selectedVoiceLanguage: String?

    override var isSpeaking: Bool {
        return isSpeakingStub
    }

    override var isPaused: Bool {
        return isPausedStub
    }
    
    override func speak(_ utterance: AVSpeechUtterance) {
           if let language = utterance.voice?.language {
               selectedVoiceLanguage = language
           }
           // Simulate the speaking behavior by setting isSpeakingStub to true
           isSpeakingStub = true
       }

    override func pauseSpeaking(at boundary: AVSpeechBoundary) -> Bool {
        // Simulate the pausing behavior by setting isPausedStub to true
        isPausedStub = true
        return true // Return true to indicate success
    }
    
    override func continueSpeaking() -> Bool {
        // Simulate the continueSpeaking behavior by setting isPausedStub to false
        isPausedStub = false
        return true // Return true to indicate success
    }
    
    override func stopSpeaking(at boundary: AVSpeechBoundary) -> Bool {
        // Simulate the stopSpeaking behavior by setting isSpeakingStub to false
        isSpeakingStub = false
        return true // Return true to indicate success
    }
}
