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
    case stopSpeak
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
    private var lastRecordingStateChangeTime: Int64 = 0
    
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
            self.lastRecordingStateChangeTime = 0
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
            self.startRecording()
        case .stopSpeak:
            self.stopRecording()
        }
    }
    
    func startRecording() {
        guard lastRecordingStateChangeTime + 500 < Int64(NSDate().timeIntervalSince1970 * 1000) else {
            return
        }
        guard !isRecording else {
            return
        }
        lastRecordingStateChangeTime = Int64(NSDate().timeIntervalSince1970 * 1000)
        isRecording = true
        print("Started Recording...")
        SpeechRecognition.shared.speak()
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
