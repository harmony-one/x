import Combine
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
    case openSettings
}

struct ButtonData: Identifiable {
    let id = UUID()
    let label: String
    let pressedLabel: String?
    let image: String
    let pressedImage: String?
    let action: ActionType
    let testId: String

    init(label: String, pressedLabel: String? = nil, image: String, pressedImage: String? = nil, action: ActionType, testId: String) {
        self.label = label
        self.pressedLabel = pressedLabel
        self.image = image
        self.pressedImage = pressedImage
        self.action = action
        self.testId = testId
    }
}

protocol ActionHandlerProtocol {
    func reset()
    func syncTapToSpeakState(_ actionType: ActionType)
    func handle(actionType: ActionType)
    func startRecording()
    func stopRecording(cancel: Bool)
    func isTapToSpeakActive() -> Bool
    func isPressAndHoldActive() -> Bool
}

class ActionHandler: ObservableObject, ActionHandlerProtocol {
    @Published var isSynthesizing: Bool = false
    @Published var isRecording: Bool = false
    
    @Published private var _isPressAndHoldActive = false
    var isPressAndHoldActivePublisher: Published<Bool>.Publisher {
        $_isPressAndHoldActive
    }

    @Published private var _isTapToSpeakActive = false
    var isTapToSpeakActivePublisher: Published<Bool>.Publisher {
        $_isTapToSpeakActive
    }
    
    private var lastRecordingStateChangeTime: Int64 = 0

    var resetThrottler = PassthroughSubject<Void, Never>()
    var resetCancellable: AnyCancellable?

    let speechRecognition: SpeechRecognitionProtocol
    var onSynthesizingChanged: ((Bool) -> Void)?

    init(speechRecognition: SpeechRecognitionProtocol = SpeechRecognition.shared) {
        self.speechRecognition = speechRecognition
        resetCancellable = resetThrottler
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink {
                self.reset()
            }
    }

    func isTapToSpeakActive() -> Bool {
        return _isTapToSpeakActive
    }
    
    func isPressAndHoldActive() -> Bool {
        return _isPressAndHoldActive
    }
    
    func reset() {
        isRecording = false
        isSynthesizing = false
        lastRecordingStateChangeTime = 0
        speechRecognition.reset()
        speechRecognition.cancelRetry()
    }

    func syncTapToSpeakState(_ actionType: ActionType) {
        let isItTapToSpeakAction = actionType == .tapSpeak && actionType == .tapStopSpeak
        let resetTapSpeakState = _isTapToSpeakActive && !isItTapToSpeakAction
        if resetTapSpeakState {
            _isTapToSpeakActive = false
            lastRecordingStateChangeTime = 0
            stopRecording(cancel: true)
        }
    }

    func handle(actionType: ActionType) {
        syncTapToSpeakState(actionType)

        print("Run action \(actionType)")

        switch actionType {
        case .reset:
            resetThrottler.send()
        case .surprise:
            if SpeechRecognition.shared.isTimerDidFired {
                return
            }
            speechRecognition.surprise()
        case .play:
            if speechRecognition.isPaused() {
                speechRecognition.continueSpeech()
            } else {
                speechRecognition.pause()
            }
        case .repeatLast:
            speechRecognition.repeate()
        case .openSettings:
            speechRecognition.repeate()
        case .speak:
            _isPressAndHoldActive = true
            startRecording()
        case .tapSpeak:
            _isTapToSpeakActive = true
            startRecording()
        case .stopSpeak, .tapStopSpeak:
            _isPressAndHoldActive = false
            _isTapToSpeakActive = false
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
        }
    }

    func startRecording() {
        if SpeechRecognition.shared.isTimerDidFired {
            return
        }
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

    func stopRecording(cancel: Bool = false) {
        if isRecording {
            isRecording = false
            print("Stopped Recording")
            speechRecognition.stopSpeak(cancel: cancel)
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
