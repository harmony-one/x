//
//  VibrationManager.swift
//  Voice AI
//
//  Created by Nagesh Kumar Mishra on 25/10/23.
//

import Foundation
import UIKit
import CoreHaptics

// VibrationManager class to handle vibration operations
class VibrationManager {
    static var isVibrating = false // Flag to track vibration status
    static var timer: Timer? // Timer for scheduled vibration

    // Start the vibration loop
    static func startVibration() {
        isVibrating = true
        // Schedule a timer to trigger vibration
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(vibrate), userInfo: nil, repeats: true)
    }

    // Stop the vibration loop
    static func stopVibration() {
        isVibrating = false
        timer?.invalidate() // Invalidate the timer
    }

    // Selector method to trigger vibration
    @objc static func vibrate() {
        // Check if the vibration should continue
        if isVibrating {
            let generator = UIImpactFeedbackGenerator(style: .medium) // Create UIImpactFeedbackGenerator
            generator.prepare() // Prepare the generator
            generator.impactOccurred() // Trigger the haptic feedback
        }
    }
}
