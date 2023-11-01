//
//  ActionHandler.swift
//  Voice AITests
//
//  Created by Nagesh Kumar Mishra on 29/10/23.
//

import Foundation

enum ActionType {
    case reset
    case skip
    case randomFact
    case play
    case repeatLast
    case speak
}

struct ButtonData: Identifiable {
    let id = UUID()
    let label: String
    let image: String
    let action: ActionType
}

class ActionHandler: ObservableObject {
    @Published var isRecording: Bool = false
    @Published var isSynthesizing: Bool = false
    
    let speechRecognition: SpeechRecognitionProtocol
    var onSynthesizingChanged: ((Bool) -> Void)?
    
    init(speechRecognition: SpeechRecognitionProtocol = SpeechRecognition.shared) {
        self.speechRecognition = speechRecognition
    }
    
    func handle(actionType: ActionType) {
        switch actionType {
        case .reset:
            self.isRecording = false
            self.isSynthesizing = false
            speechRecognition.reset()
        case .skip:
            stopRecording()
        case .randomFact:
            speechRecognition.randomFacts()
        case .play:
            if speechRecognition.isPaused() {
                speechRecognition.continueSpeech()
            } else {
                speechRecognition.pause()
            }
        case .repeatLast:
            speechRecognition.repeate()
        case .speak:
            if self.isRecording == false {
                startRecording()
                SpeechRecognition.shared.speak()
            } else {
                // Introducing a delay before stopping the recording
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.stopRecording()
                }
            }
        }
    }
    
    func startRecording() {
        isRecording = true
        print("Started Recording...")
        // Add any other logic to start recording if necessary
    }
    
    func stopRecording() {
        if isRecording {
            isRecording = false
            print("Stopped Recording")
            speechRecognition.stopSpeak()
            // Simulating delay before triggering a synthesizing state change
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.isSynthesizing = true
                self.onSynthesizingChanged?(true)
                // Simulating delay to end the synthesizing state
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.isSynthesizing = false
                    self.onSynthesizingChanged?(false)
                }
            }
        }
    }
    
}
