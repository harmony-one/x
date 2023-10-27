//
//  AudioPlayer.swift
//  Voice AI
//
//  Created by Nagesh Kumar Mishra on 23/10/23.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject {
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?

    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "beep", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.numberOfLoops = 0 // Play once, as the loop will be handled by the Timer
            audioPlayer?.play()

            // Schedule a Timer to play the sound every 2 seconds
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(playSoundWithDelay), userInfo: nil, repeats: true)
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
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
