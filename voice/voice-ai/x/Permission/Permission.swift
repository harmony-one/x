import AVFoundation
import Sentry
import Speech

class Permission {
    var handleMicrophoneAccessDeniedCalled = false
    var permissionCheck = false
    var speechRecognitionPermissionStatus = "default"
    
    // Function to set up necessary permissions
    func setup() {
        requestMicrophoneAccess { granted in
            if granted {
                self.requestSpeechRecognitionPermission()
            } else {
                self.handleMicrophoneAccessDenied()
            }
        }
    }
    
    func handleMicrophoneAccessDenied() {
        self.handleMicrophoneAccessDeniedCalled = true
        print("Microphone access denied")
        SentrySDK.capture(message: "Microphone access denied")
    }
    
    // Request access to the microphone
    func requestMicrophoneAccess(
        forceOldVersionForTesting: Bool = false,
        completion: @escaping (Bool) -> Void) {
            if !forceOldVersionForTesting, #available(iOS 14.0, *) {
                AVCaptureDevice.requestAccess(for: .audio) { granted in
                    DispatchQueue.main.async {
                        completion(granted)
                    }
                }
            } else {
                // Fallback on earlier versions
                checkMicrophoneAccess(completion: completion)
            }
        }
    
//    // Fallback function for checking microphone access on earlier iOS versions
//    func checkMicrophoneAccess() -> Bool {
//        let audioSession = AVAudioSession.sharedInstance()
//        var permissionCheck = false
//        do {
//            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: [.defaultToSpeaker, .allowBluetoothA2DP])
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//            try audioSession.setMode(.spokenAudio)
//            try audioSession.setAllowHapticsAndSystemSoundsDuringRecording(true)
//        } catch {
//            print("Error setting up audio engine: \(error.localizedDescription)")
//            SentrySDK.capture(message: "Error setting up audio session: \(error.localizedDescription)")
//        }
//        switch audioSession.recordPermission {
//        case .granted:
//            permissionCheck = true
//        case .denied:
//            permissionCheck = false
//        case .undetermined:
//            print("Request permission here")
//            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
//                if granted {
//                    permissionCheck = true
//                } else {
//                    permissionCheck = false
//                }
//            })
//        default:
//            break
//        }
//        return permissionCheck
//    }
    
    func checkMicrophoneAccess(completion: @escaping (Bool) -> Bool) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: [.defaultToSpeaker, .allowBluetoothA2DP])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.setMode(.spokenAudio)
            try audioSession.setAllowHapticsAndSystemSoundsDuringRecording(true)
        } catch {
            print("Error setting up audio engine: \(error.localizedDescription)")
            SentrySDK.capture(message: "Error setting up audio session: \(error.localizedDescription)")
        }
        let authStatus = audioSession.recordPermission
        self.handleCheckMicrophoneAccessStatus(authStatus, completion: completion)
        return self.permissionCheck
    }
    
    func handleCheckMicrophoneAccessStatus(_ authStatus: AVAudioSession.RecordPermission, completion: @escaping (Bool) -> Void) {
        switch authStatus {
        case .granted:
            self.permissionCheck = true
        case .denied:
            self.permissionCheck = false
        case .undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission{ granted in
                if granted {
                    self.permissionCheck = true
                } else {
                    self.permissionCheck = false
                }
                completion(self.permissionCheck)
            }
        default:
            break
        }
    }
    
    func requestSpeechRecognitionPermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                self.handleSpeechRecognitionAuthorizationStatus(authStatus)
            }
        }
    }
    
    // Handle speech recognition authorization status
    func handleSpeechRecognitionAuthorizationStatus(_ authStatus: SFSpeechRecognizerAuthorizationStatus) {
        switch authStatus {
        case .authorized:
            self.speechRecognitionPermissionStatus = "authorized"
            print("Speech recognition permission: \(self.speechRecognitionPermissionStatus)")
        case .denied:
            self.speechRecognitionPermissionStatus = "denied"
            print("Speech recognition permission: \(self.speechRecognitionPermissionStatus)")
            SentrySDK.capture(message: "User denied speech recognition permission")
        case .notDetermined:
            self.speechRecognitionPermissionStatus = "not determined"
            print("Speech recognition permission: \(self.speechRecognitionPermissionStatus)")
            SentrySDK.capture(message: "Speech recognition not determined")
        case .restricted:
            self.speechRecognitionPermissionStatus = "restricted"
            print("Speech recognition permission: \(self.speechRecognitionPermissionStatus)")
            SentrySDK.capture(message: "Speech recognition restricted")
        @unknown default:
            SentrySDK.capture(message: "Fatal error: New case for speech recognition authorization is available")
            fatalError("New case for speech recognition authorization is available")
        }
    }
}
