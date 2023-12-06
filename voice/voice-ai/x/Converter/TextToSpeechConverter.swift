import AVFoundation
import Foundation

protocol TextToSpeechConverterProtocol {
    var isSpeaking: Bool { get }
    func convertTextToSpeech(text: String, pitch: Float, volume: Float, language: String?)
    func stopSpeech()
    func pauseSpeech()
    func continueSpeech()
}

// TextToSpeechConverter class responsible for converting text to speech
class TextToSpeechConverter: TextToSpeechConverterProtocol {
    
    // AVSpeechSynthesizer instance to handle speech synthesis
    var synthesizer = AVSpeechSynthesizer()
    let languageCode = getLanguageCode()
    var isSpeaking: Bool {
        return synthesizer.isSpeaking
    }
    
    private(set) var isDefaultVoiceUsed = false
    
    // Function to convert text to speech with customizable pitch and volume parameters
    func convertTextToSpeech(text: String, pitch: Float = 1.0, volume: Float = 1.0, language: String? = "") {
        // Create an AVSpeechUtterance with the provided text
        let utterance = AVSpeechUtterance(string: text)
        
        var selectedLanguage: String!
        
        if language != "" {
            selectedLanguage = language
        } else {
            selectedLanguage = languageCode
        }
        
        if let voice = AVSpeechSynthesisVoice(language: selectedLanguage) {
            print("[selectedLanguage] \(String(describing: selectedLanguage))")
            utterance.voice = voice
        } else {
            // this is used just for the unit tests
            isDefaultVoiceUsed = true
            // Print a message if the specified voice is not available and use the system's default language
            print("The specified voice is not available. Defaulting to the system's language.")
        }
                
        // Set the pitch of the speech utterance
        utterance.pitchMultiplier = pitch
        
        // Set the volume of the speech utterance
        utterance.volume = volume
        
        // Speak the provided utterance using the AVSpeechSynthesizer
        synthesizer.speak(utterance)
    }
    
    // Function to stop ongoing speech
    func stopSpeech() {
        // Check if the synthesizer is currently speaking and stop it immediately
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    // Function to pause ongoing speech
    func pauseSpeech() {
        // Check if the synthesizer is currently speaking and pause it immediately
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
            print("Speech paused.")
//            Thread.sleep(forTimeInterval: 1.0)
        } else {
            print("Speech is not speaking.")
        }
    }
    
    // Function to continue ongoing speech
    func continueSpeech() {
        // Check if the synthesizer is currently speaking and continue speaking
        if synthesizer.isSpeaking {
            synthesizer.continueSpeaking()
        }
    }
}
