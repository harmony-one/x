import AVFoundation
import UIKit
import Sentry
import Speech
import OSLog

class Permission {
    var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: "RelayAuth")
    )
    var handleMicrophoneAccessDeniedCalled = false
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
        self.logger.log("Microphone access denied")
        SentrySDK.capture(message: "Microphone access denied")
        self.showAlertForSettings("Microphone")
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
                let granted = checkMicrophoneAccess()
                completion(granted)
            }
        }
    
    // Fallback function for checking microphone access on earlier iOS versions
    func checkMicrophoneAccess() -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        var permissionCheck = false
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: [.defaultToSpeaker, .allowBluetoothA2DP, .allowAirPlay])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.setMode(.spokenAudio)
            try audioSession.setAllowHapticsAndSystemSoundsDuringRecording(true)
        } catch {
            self.logger.log("Error setting up audio engine: \(error.localizedDescription)")
            SentrySDK.capture(message: "Error setting up audio session: \(error.localizedDescription)")
        }
        switch audioSession.recordPermission {
        case .granted:
            permissionCheck = true
        case .denied:
            permissionCheck = false
        case .undetermined:
            self.logger.log("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                if granted {
                    permissionCheck = true
                } else {
                    permissionCheck = false
                }
            })
        default:
            break
        }
        return permissionCheck
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
            self.logger.log("Speech recognition permission: \(self.speechRecognitionPermissionStatus, privacy: .public)")
        case .denied:
            self.speechRecognitionPermissionStatus = "denied"
            self.logger.log("Speech recognition permission: \(self.speechRecognitionPermissionStatus, privacy: .public)")
            SentrySDK.capture(message: "User denied speech recognition permission")
            self.showAlertForSettings("Speech Recognition")
            
        case .notDetermined:
            self.speechRecognitionPermissionStatus = "not determined"
            self.logger.log("Speech recognition permission: \(self.speechRecognitionPermissionStatus, privacy: .public)")
            SentrySDK.capture(message: "Speech recognition not determined")
        case .restricted:
            self.speechRecognitionPermissionStatus = "restricted"
            self.logger.log("Speech recognition permission: \(self.speechRecognitionPermissionStatus, privacy: .public)")
            SentrySDK.capture(message: "Speech recognition restricted")
        @unknown default:
            SentrySDK.capture(message: "Fatal error: New case for speech recognition authorization is available")
            fatalError("New case for speech recognition authorization is available")
        }
    }
    
    private func showAlertForSettings(_ permissionType: String) {
        self.logger.log("Attempting to show alert for \(permissionType) permission")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
                    self.logger.log("No active window scene found")
                    return
                }
                
                let alert = UIAlertController(title: "\(permissionType) Permission Required",
                                              message: "Voice AI requires \(permissionType) access to work, go to Settings to enable.",
                                              preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(settingsUrl, options: [:]) { _ in
                        // Re-check permission after returning from settings
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.setup()
                        }
                    }
                }
                
                alert.addAction(settingsAction)
                
                if let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                    rootViewController.present(alert, animated: true, completion: nil)
                    self.logger.log("Alert presented for \(permissionType) permission")
                } else {
                    self.logger.log("No root view controller found to present the alert")
                }
            }
        }
    }
    
}
