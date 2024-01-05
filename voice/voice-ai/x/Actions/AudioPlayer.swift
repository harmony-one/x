import AVFoundation
import Foundation
import Sentry
import OSLog

protocol AVAudioSessionProtocol {
    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, options: AVAudioSession.CategoryOptions) throws
    func setActive(_ active: Bool, options: AVAudioSession.SetActiveOptions) throws
    func setMode(_ options: AVAudioSession.Mode) throws
}

class AVAudioSessionWrapper: AVAudioSessionProtocol {
    private let avAudioSession: AVAudioSession

    init() {
        avAudioSession = AVAudioSession.sharedInstance()
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

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: "AVAudioSessionWrapper")
    )
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var completion: (() -> Void)?
    
    
    func playSound(_ isLoop: Bool = true, _ resource: String = "beep") {
        playSoundWithSettings(isLoop, resource)
    }
    
    func playSoundWithSettings(_ loop: Bool = true, _ resource: String = "beep") {
        guard let soundURL = Bundle.main.url(forResource: resource, withExtension: "mp3") else {
            self.logger.log("Sound file not found")
            
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
            self.logger.log("Error playing sound: \(error.localizedDescription)")
            SentrySDK.capture(message: "Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func playSoundTTS(fromData data: Data, completion: @escaping () -> Void) {
            do {
                audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.numberOfLoops = 0
                audioPlayer?.play()
                self.completion = completion
            } catch {
                logger.log("Error playing sound from data: \(error.localizedDescription)")
                SentrySDK.capture(message: "Error playing sound from data: \(error.localizedDescription)")
                completion() // Ensure to call completion even in case of an error
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
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        completion?()
        completion = nil
    }
}
