import AVFoundation
import UIKit
import Foundation
import OSLog

protocol TextToSpeechConverterProtocol {
    var isSpeaking: Bool { get }
    func convertTextToSpeech(text: String, pitch: Float, volume: Float, language: String?, timeLogger: TimeLogger?)
    func stopSpeech()
    func pauseSpeech()
    func continueSpeech()
}

// TextToSpeechConverter class responsible for converting text to speech
class TextToSpeechConverter: NSObject, TextToSpeechConverterProtocol {
    var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: "TextToSpeechConverter")
    )
    var timeLogger: TimeLogger?
    // AVSpeechSynthesizer instance to handle speech synthesis
    var synthesizer = AVSpeechSynthesizer()
    let languageCode = getLanguageCode()
    var isSpeaking: Bool {
        return synthesizer.isSpeaking
    }
    
    private(set) var isDefaultVoiceUsed = false
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        timeLogger?.finishTTSFirst()
    }
    
    // Function to convert text to speech with customizable pitch and volume parameters
    func convertTextToSpeech(text: String, pitch: Float = 1.0, volume: Float = 1.0, language: String? = "", timeLogger: TimeLogger?) {
        self.timeLogger = timeLogger
        
        // Create an AVSpeechUtterance with the provided text
        let utterance = AVSpeechUtterance(string: text)
        
        var selectedLanguage: String!
        
        if language != "" {
            selectedLanguage = language
        } else {
            selectedLanguage = languageCode
        }
        
        if let voice = AVSpeechSynthesisVoice(language: selectedLanguage) {
//            if let language = selectedLanguage {
//                self.logger.log("[selectedLanguage] \(language)")
//            } else {
//                self.logger.log("[selectedLanguage] nil")
//            }
            utterance.voice = voice
        } else {
            // this is used just for the unit tests
            isDefaultVoiceUsed = true
            // self.logger.log a message if the specified voice is not available and use the system's default language
            self.logger.log("The specified voice is not available. Defaulting to the system's language.")
        }
                
        // Set the pitch of the speech utterance
        utterance.pitchMultiplier = pitch
        
        // Set the volume of the speech utterance
        utterance.volume = volume
        
        self.logger.log("[TTS] \(text)\n")
        
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
            self.logger.log("Speech paused.")
//            Thread.sleep(forTimeInterval: 1.0)
        } else {
            self.logger.log("Speech is not speaking.")
        }
    }
    
    // Function to continue ongoing speech
    func continueSpeech() {
        // Check if the synthesizer is currently speaking and continue speaking
        if synthesizer.isSpeaking {
            synthesizer.continueSpeaking()
        }
    }
    
    func isPremiumOrEnhancedVoice(voiceIdentifier: String) -> Bool {
        let lowercasedIdentifier = voiceIdentifier.lowercased()
        return lowercasedIdentifier.contains("premium")
    }
        
    func checkAndPromptForPremiumVoice() {
        let currentVoice = AVSpeechSynthesisVoice(language: getLanguageCode())
        guard let currentVoiceIdentifier = currentVoice?.identifier else {
            return
        }
        print("Is the voice premium? \(isPremiumOrEnhancedVoice(voiceIdentifier: currentVoiceIdentifier))")

        if !isPremiumOrEnhancedVoice(voiceIdentifier: currentVoiceIdentifier) {
            showDownloadVoicePrompt()
        }
    }
    
    func showDownloadVoicePrompt() {
        // The prompt should guide the user on how to download a premium voice
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            let okAction = UIAlertAction(title: String(localized: "button.ok"), style: .default)
            AlertManager.showAlertForSettings(title: "Enhance Your Experience", message: "Download a premium voice for a better experience. Go to Settings > Accessibility > Spoken Content > Voices to choose and download a premium voice.", actions: [okAction])
        }
    }
}

extension TextToSpeechConverter: AVSpeechSynthesizerDelegate {}
