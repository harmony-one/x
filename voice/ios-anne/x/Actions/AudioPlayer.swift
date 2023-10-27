import Foundation
import AVFoundation

class AudioPlayer: NSObject {
    
    var audioPlayer: AVAudioPlayer?
    var audioData: [Data] = []
    
    func addData(data: Data) {
        audioData.append(data)
    }
    
    func play() {
        do {
            audioPlayer = try AVAudioPlayer(data: audioData[0])
            audioPlayer?.numberOfLoops = -1 // Play continuously
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

    func stopSound() {
        audioPlayer?.stop()
    }

}
