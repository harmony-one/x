import Foundation
import UIKit

enum ActionType {
    case reset
//    case sayMore
    case surprise
    case play
    case repeatLast
    case speak
    case tapSpeak
    case tapStopSpeak
    case stopSpeak
    case userGuide
}

struct ButtonData: Identifiable {
    let id = UUID()
    let label: String
    let pressedLabel: String?
    let image: String
    let pressedImage: String?
    let action: ActionType
    
    init(label: String, pressedLabel: String? = nil, image: String, pressedImage: String? = nil, action: ActionType) {
        self.label = label
        self.pressedLabel = pressedLabel
        self.image = image
        self.pressedImage = pressedImage
        self.action = action
        
    }
}

class ActionHandler: ObservableObject {
    @Published var isRecording: Bool = false
    @Published var isSynthesizing: Bool = false
    @Published var isTapToSpeakActive = false
    private var lastRecordingStateChangeTime: Int64 = 0
    
    let speechRecognition: SpeechRecognitionProtocol
    var onSynthesizingChanged: ((Bool) -> Void)?
    
    init(speechRecognition: SpeechRecognitionProtocol = SpeechRecognition.shared) {
        self.speechRecognition = speechRecognition
    }
    
    func syncTapToSpeakState (_ actionType: ActionType) {
        let isItTapToSpeakAction = actionType == .tapSpeak && actionType == .tapStopSpeak;
        let resetTapSpeakState = self.isTapToSpeakActive && !isItTapToSpeakAction
        if (resetTapSpeakState) {
            self.isTapToSpeakActive = false
            self.speechRecognition.cancelSpeak()
        }
    }
    
    func handle(actionType: ActionType) {
        syncTapToSpeakState(actionType)
        
        switch actionType {
        case .reset:
            self.isRecording = false
            self.isSynthesizing = false
            self.lastRecordingStateChangeTime = 0
            speechRecognition.reset()
        case .surprise:
            speechRecognition.surprise()
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
        case .tapSpeak:
            self.isTapToSpeakActive = true
            self.startRecording()
        case .stopSpeak, .tapStopSpeak:
            self.isTapToSpeakActive = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.stopRecording()
            }
        case .userGuide:
            let url = URL(string: "https://x.country/voice")
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                print("Cannot open URL")
            }
//        case .sayMore:
//            speechRecognition.sayMore()
            
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
