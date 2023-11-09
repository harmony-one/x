import AVFoundation
import Foundation
import Sentry

protocol AVAudioSessionProtocol {
    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, options: AVAudioSession.CategoryOptions) throws
    func setActive(_ active: Bool, options: AVAudioSession.SetActiveOptions) throws
    func setMode(_ options: AVAudioSession.Mode) throws
}

class AVAudioSessionWrapper: AVAudioSessionProtocol {
    private let avAudioSession: AVAudioSession

    init() {
        self.avAudioSession = AVAudioSession.sharedInstance()
    }

    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, options: AVAudioSession.CategoryOptions) throws {
        try avAudioSession.setCategory(category, mode: mode, options: options)
    }

    func setActive(_ active: Bool, options: AVAudioSession.SetActiveOptions) throws {
        try avAudioSession.setActive(active, options: options)
    }

    func setMode(_ mode: AVAudioSession.Mode) throws {
        try avAudioSession.setMode(mode)
    }
}

class AudioPlayer: NSObject {
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?

    func playSound(_ isLoop: Bool = true, _ resource: String = "beep") {
        playSoundWithSettings(isLoop, resource)
    }

    func playSoundWithSettings(_ loop: Bool = true, _ resource: String = "beep") {
        guard let soundURL = Bundle.main.url(forResource: resource, withExtension: "mp3") else {
            print("Sound file not found")

            SentrySDK.capture(message: "Sound file not found")

            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.numberOfLoops = 0 // Play once, as the loop will be handled by the Timer
            audioPlayer?.play()

            // Schedule a Timer to play the sound every 2 seconds
            if loop {
                timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(playSoundWithDelay), userInfo: nil, repeats: true)
            }
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
            SentrySDK.capture(message: "Error playing sound: \(error.localizedDescription)")
        }
    }

    func stopSound() {
        audioPlayer?.stop()
        timer?.invalidate() // Stop the timer when stopping the sound
    }

    @objc func playSoundWithDelay() {
        if audioPlayer?.isPlaying == false {
            audioPlayer?.currentTime = 0
            audioPlayer?.play()
        }
    }
}
