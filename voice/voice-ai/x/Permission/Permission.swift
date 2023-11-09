import AVFoundation
import Speech
import Sentry

struct Permission {
    // Function to set up necessary permissions
    func setup() {
        requestMicrophoneAccess { granted in
            if granted {
                requestSpeechRecognitionPermission()
            } else {
                print("Microphone access denied")
                SentrySDK.capture(message: "Microphone access denied")
            }
        }
    }
    
    // Request access to the microphone
    func requestMicrophoneAccess(completion: @escaping (Bool) -> Void) {
        if #available(iOS 14.0, *) {
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        } else {
            // Fallback on earlier versions
            let granted = checkMicrophoneAccess()
            completion(granted)
        }
    }

    // Fallback function for checking microphone access on earlier iOS versions
    func checkMicrophoneAccess() -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        var granted = false
        audioSession.requestRecordPermission { grantedPermission in
            granted = grantedPermission
        }
        return granted
    }
    
    // Request access to speech recognition
    func requestSpeechRecognitionPermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorized")
                case .denied:
                    print("User denied speech recognition permission")
                    SentrySDK.capture(message: "User denied speech recognition permission")
                    break;
                case .notDetermined:
                    print("Speech recognition not determined")
                    SentrySDK.capture(message: "Speech recognition not determined")
                    break;
                case .restricted:
                    print("Speech recognition restricted")
                    SentrySDK.capture(message: "Speech recognition restricted")
                    break;
                @unknown default:
                    SentrySDK.capture(message: "Fatal error: New case for speech recognition authorization is available")
                    fatalError("New case for speech recognition authorization is available")
                    break;
                }
            }
        }
    }
}
