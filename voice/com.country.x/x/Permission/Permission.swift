import AVFoundation
import Speech

struct Permission {
    // Function to set up necessary permissions
    func setup() {
        requestMicrophoneAccess { granted in
            if granted {
                print("Permission: mic access granted")
            } else {
                print("Permission: mic access denied")
            }
        }
    }
    
    // Request access to the microphone
    func requestMicrophoneAccess(completion: @escaping (Bool) -> Void) {
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}
