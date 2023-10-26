//
//  TextToSpeechConverter.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 17/10/23.
//

import Foundation
import AVFoundation

// TextToSpeechConverter class responsible for converting text to speech
class TextToSpeechConverter {
    // AVSpeechSynthesizer instance to handle speech synthesis
    let synthesizer = AVSpeechSynthesizer()
    
    // Function to convert text to speech with customizable pitch and volume parameters
    func convertTextToSpeech(text: String, pitch: Float = 1.0, volume: Float = 1.0, language: String = "en-US") {
        // Create an AVSpeechUtterance with the provided text
        let utterance = AVSpeechUtterance(string: text)
        
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.en-US.Ava") ?? AVSpeechSynthesisVoice(identifier: "com.apple.speech.voice.compact.en-US.Samantha")
        
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
