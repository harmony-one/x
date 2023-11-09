import AVFoundation
@testable import Voice_AI
import XCTest

class AudioPlayerTests: XCTestCase {
    var audioPlayer: AudioPlayer!

    override func setUp() {
        super.setUp()
        audioPlayer = AudioPlayer()
    }

    override func tearDown() {
        audioPlayer = nil
        super.tearDown()
    }

    func testPlaySound() {
        // Test playing a sound without looping
        audioPlayer.playSound(false, "beep")
        XCTAssertNotNil(audioPlayer.audioPlayer, "AudioPlayer should not be nil")
        XCTAssertNil(audioPlayer.timer, "Timer should be nil when not looping")
    }

    func testPlaySoundWithSettings() {
        // Test playing a sound with looping
        audioPlayer.playSoundWithSettings(true, "beep")
        XCTAssertNotNil(audioPlayer.audioPlayer, "AudioPlayer should not be nil")
        XCTAssertNotNil(audioPlayer.timer, "Timer should not be nil when looping")
    }

//    func testStopSound() {
//        // Test stopping the sound
//        audioPlayer.playSound(true, "beep")
//        audioPlayer.stopSound()
//        XCTAssertFalse(audioPlayer.audioPlayer!.isPlaying, "AudioPlayer should not be playing after stopping")
//        XCTAssertNil(audioPlayer.timer, "Timer should be nil after stopping")
//    }

    func testPlaySoundWithDelay() {
        // Test playing sound with a delay
        audioPlayer.playSound(true, "beep")
        audioPlayer.playSoundWithDelay()
        XCTAssertEqual(audioPlayer.audioPlayer!.currentTime, 0, "AudioPlayer currentTime should be reset")
        XCTAssertTrue(audioPlayer.audioPlayer!.isPlaying, "AudioPlayer should be playing after delay")
    }
}
