import CoreHaptics
import Foundation
import UIKit

// VibrationManager class to handle vibration operations
class VibrationManager {
    static let shared = VibrationManager() // Singleton instance
    internal var isVibrating = false // Flag to track vibration status
    internal var timer: Timer? // Timer for scheduled vibration
    internal var generator: UIImpactFeedbackGenerator?
    
    // Private initializer to prevent external instantiation
        private init() {}

    // Start the vibration loop
     func startVibration() {
        isVibrating = true
        // Schedule a timer to trigger vibration
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(vibrate), userInfo: nil, repeats: true)
    }
    
    // Stop the vibration loop
     func stopVibration() {
        isVibrating = false
        timer?.invalidate() // Invalidate the timer
        timer = nil
    }
    
    // Selector method to trigger vibration
    @objc internal func vibrate() {
        // Check if the vibration should continue
        if isVibrating {
            initiateVibration()
        }
    }
    
     func vibrateOnce() {
        initiateVibration()
    }
    
    private func initiateVibration() {
        if generator == nil {
            generator = UIImpactFeedbackGenerator(style: .medium) // Create UIImpactFeedbackGenerator if it doesn't exist
        }
        generator?.prepare() // Prepare the generator
        generator?.impactOccurred() // Trigger the haptic feedback
    }
}
