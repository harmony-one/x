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
    let thinking: String?

    init(label: String, pressedLabel: String? = nil, image: String, pressedImage: String? = nil, action: ActionType, testId: String, thinking: String? = nil) {
        self.label = label
        self.pressedLabel = pressedLabel
        self.image = image
        self.pressedImage = pressedImage
        self.action = action
        self.testId = testId
        self.thinking = thinking
    }
}

protocol ActionHandlerProtocol {

    var isSynthesizing: Bool { get }
    var isSynthesizingPublished: Published<Bool> { get }
    var isSynthesizingPublisher: Published<Bool>.Publisher { get }
    
    var isRecording: Bool { get }
    var isRecordingPublished: Published<Bool> { get }
    var isRecordingPublisher: Published<Bool>.Publisher { get }
    
    var isTapToSpeakActive: Bool { get }
    var isTapToSpeakActivePublished: Published<Bool> { get }
    var isTapToSpeakActivePublisher: Published<Bool>.Publisher { get }
    
    var isPressAndHoldActive: Bool { get }
    var isPressAndHoldActivePublished: Published<Bool> { get }
    var isPressAndHoldActivePublisher: Published<Bool>.Publisher { get }
    
    func reset()
    func syncTapToSpeakState(_ actionType: ActionType)
    func handle(actionType: ActionType)
    func startRecording()
    func stopRecording(cancel: Bool)

}

class ActionHandler: ActionHandlerProtocol, ObservableObject {
    @Published var isSynthesizing: Bool = false
    var isSynthesizingPublished: Published<Bool> { _isSynthesizing }
    var isSynthesizingPublisher: Published<Bool>.Publisher { $isSynthesizing }
    
    @Published var isRecording: Bool = false
    var isRecordingPublished: Published<Bool> { _isRecording }
    var isRecordingPublisher: Published<Bool>.Publisher { $isRecording }
    
    @Published var isTapToSpeakActive: Bool = false
    var isTapToSpeakActivePublished: Published<Bool> { _isTapToSpeakActive }
    var isTapToSpeakActivePublisher: Published<Bool>.Publisher { $isTapToSpeakActive }
    
    @Published var isPressAndHoldActive: Bool = false
    var isPressAndHoldActivePublished: Published<Bool> { _isPressAndHoldActive }
    var isPressAndHoldActivePublisher: Published<Bool>.Publisher { $isPressAndHoldActive }

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
    
    func reset() {
        isRecording = false
        isSynthesizing = false
        lastRecordingStateChangeTime = 0
        speechRecognition.reset()
        speechRecognition.cancelRetry()
    }

    func syncTapToSpeakState(_ actionType: ActionType) {
        let isItTapToSpeakAction = actionType == .tapSpeak && actionType == .tapStopSpeak
        let resetTapSpeakState = isTapToSpeakActive && !isItTapToSpeakAction
        if resetTapSpeakState {
            isTapToSpeakActive = false
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
            isPressAndHoldActive = true
            startRecording()
        case .tapSpeak:
            isTapToSpeakActive = true
            startRecording()
        case .stopSpeak, .tapStopSpeak:
            isPressAndHoldActive = false
            isTapToSpeakActive = false
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
            VibrationManager.shared.startVibration()
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
