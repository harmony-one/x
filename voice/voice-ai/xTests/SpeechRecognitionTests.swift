@testable import Voice_AI
import XCTest
import StoreKit
import SwiftUI

class RandomFactTests: XCTestCase {
    func testGetTitle() {

        let title = getTitle()

        // Check if the title is not empty
        XCTAssertFalse(title.isEmpty, "The title should not be empty")

        // Check if the title is one of the top articles
        XCTAssertTrue(topArticles.contains(title),
                      "The title should be one of the top articles")
    }
}

class SpeechRecognitionTests: XCTestCase {
    
    var speechRecognition: SpeechRecognition!
    var textToSpeechConverter: TextToSpeechConverter!

    override func setUpWithError() throws {
        super.setUp()
        speechRecognition = SpeechRecognition.shared
        textToSpeechConverter = TextToSpeechConverter()
    }

    override func tearDownWithError() throws {
        speechRecognition = nil
        textToSpeechConverter = nil
        super.tearDown()
    }
    
    func testRegisterTTS() {
         let mockSynthesizer = MockAVSpeechSynthesizer()
         speechRecognition.textToSpeechConverter.synthesizer = mockSynthesizer
         speechRecognition.registerTTS()

         XCTAssertTrue(mockSynthesizer.delegate === speechRecognition)

         mockSynthesizer.reset()
     }
    
    func testGetAudioEngine() {
        let audioEngine = speechRecognition.getAudioEngine()

        XCTAssertNotNil(audioEngine)
    }
    
    func testGetISAudioSessionSetup() {
        speechRecognition.setupAudioSession()

        XCTAssertTrue(speechRecognition.getISAudioSessionSetup())
    }
    
    func testStartSpeechRecognition() {
        let expectation = XCTestExpectation(description: "Audio engine should start running")

        speechRecognition.startSpeechRecognition()

        DispatchQueue.global().async {
            if self.speechRecognition.getAudioEngine().isRunning {
                expectation.fulfill()
            } else {
                XCTFail("Audio engine is NOT running.")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testIsPaused() {
        speechRecognition.pause()
        
        XCTAssertTrue(speechRecognition.isPaused(), "isPaused should return true")
    }
    
    func testCheckContextChangeTrue() {
            let userDefaults = UserDefaults.standard
            let customInstruction = "Custom instruction"
        
            speechRecognition.conversation = [Message(role: "system", content: "Initial context")]
            userDefaults.set(customInstruction, forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)

            XCTAssertTrue(speechRecognition.checkContextChange(), "checkContextChange should return true")

//            userDefaults.removeObject(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
        }
    
    func testCheckContextChangeFalse() {
        let userDefaults = UserDefaults.standard

        speechRecognition.conversation = []

        userDefaults.set("Custom instruction", forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)

        XCTAssertFalse(speechRecognition.checkContextChange(), "checkContextChange should return false")
    }
    
    func testCheckContextChangeFalseWithContextMatch() {
        let userDefaults = UserDefaults.standard
        let customInstruction = "Initial context"

        speechRecognition.conversation = [Message(role: "system", content: customInstruction)]

        userDefaults.set(customInstruction, forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)

        XCTAssertFalse(speechRecognition.checkContextChange(), "checkContextChange should return false")
    }
    
    func testCheckContextChangeNoSystemMessage() {
        speechRecognition.conversation = [Message(role: "user", content: "User message")]

        let result = speechRecognition.checkContextChange()

        XCTAssertFalse(result, "checkContextChange should return false when no 'system' role message is present")
    }
    
    func testPause() {
        speechRecognition.pause()
        XCTAssertTrue(speechRecognition.isPaused())
    }
    
    func testContinueSpeechPaused() {
        let mockSynthesizer = MockAVSpeechSynthesizer()
        speechRecognition.textToSpeechConverter.synthesizer = mockSynthesizer
        speechRecognition.continueSpeech()
        XCTAssertFalse(speechRecognition.isPaused())
    }
    
    func testContinueSpeechSpeaking() {
        let mockSynthesizer = MockAVSpeechSynthesizer()
        mockSynthesizer.isSpeakingStub = true
        speechRecognition.textToSpeechConverter.synthesizer = mockSynthesizer
        speechRecognition.continueSpeech()
        XCTAssertFalse(speechRecognition.isPaused())
    }
    
    func testCancelSpeak() {
        // isCapturing = false, calling function but no assertions are made
        speechRecognition.cancelSpeak()
        
        // isCapturing = true
        speechRecognition.setup()
        speechRecognition.cancelSpeak()
        XCTAssertTrue(speechRecognition.recognitionTaskCanceled ?? false)
    }
    
    func testHandleTimerDidFire() {
        speechRecognition.handleTimerDidFire()
        XCTAssertTrue(speechRecognition.isTimerDidFired)
    }
    
    func testSurprise() {
        let expectation = self.expectation(description: "Surprise method should complete")
        speechRecognition.surprise()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSayMore() {
        let expectation = self.expectation(description: "sayMore method should complete")
        speechRecognition.sayMore()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSpeak() {
        let expectation = self.expectation(description: "speak method should complete")
        speechRecognition.speak()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testStopSpeak() {
        let expectation = self.expectation(description: "stopSpeak method should complete")
        speechRecognition.stopSpeak()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRepeateActiveSession() {
        let expectation = self.expectation(description: "repeateActiveSession method should complete")
        speechRecognition.repeateActiveSession(startPoint: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    //TODO: cover case for speechRecognition.isRepeatingCurrentSession = true
    func testRepeate() {
        let expectation = self.expectation(description: "repeate method should complete")
        speechRecognition.repeate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
//    TODO: FIX-------

    // struct SpeechRecognitionProtocolTest: SpeechRecognitionProtocol {}
    //
    // func testReset() {
    //    let test = SpeechRecognitionProtocolTest()
    //    XCTAssertEqual(true,test.reset())
    // }

//    func testIsPlayingPublisher() {
//        // Given
//        var receivedIsPlayingValues: [Bool] = []
//        let expectation = XCTestExpectation(description: "Received values from isPlayingPublisher")
//
//        // When
//        let publisher = speechRecognition.isPlayingPublisher
//        let cancellable = publisher.sink { value in
//            receivedIsPlayingValues.append(value)
//            expectation.fulfill()
//        }
//
//        // Simulate changes in the isPlaying state
//        speechRecognition._isPlaying = true
//        speechRecognition._isPlaying = false
//        speechRecognition._isPlaying = true
//
//        // Then
//        wait(for: [expectation], timeout: 1.0)
//        XCTAssertEqual(receivedIsPlayingValues, [false, true, false, true])
//
//        cancellable.cancel()
//    }

//    func testIsPausedPublisher() {
//        // Given
//        var receivedIsPausedValues: [Bool] = []
//        let expectation = XCTestExpectation(description: "Received values from isPausedPublisher")
////        var speechRecognition: MockSpeechRecognition = MockSpeechRecognition()
//        
//        // When
//        let publisher = speechRecognition.isPlayingPublisher
//        let cancellable = publisher.sink { value in
//            receivedIsPausedValues.append(value)
//            expectation.fulfill()
//        }
//
//        // Simulate changes in the isPaused state using the mock
//        speechRecognition.setIsPausing(true)
//        speechRecognition.setIsPausing(false)
//        speechRecognition.setIsPausing(true)
//
//        // Then
//        wait(for: [expectation], timeout: 5.0)
//        XCTAssertEqual(receivedIsPausedValues, [true, false, true])
//
//        cancellable.cancel()
//    }
//    
//    func testIsPlayingPublisherGetter() {
//        let mockSpeechRecognition = MockSpeechRecognition()
//
//        let isPlayingPublisher = mockSpeechRecognition.isPlayingPublisher
//
//        // Assert: Verify the result
//        var isPlaying = false
//        let cancellable = isPlayingPublisher.sink { isPlaying = $0 }
//
//        // At this point, isPlaying should be false by default
//        XCTAssertFalse(isPlaying, "isPlaying should initially be false")
//
//        // You can modify _isPlaying to change the value
//        mockSpeechRecognition.setIsPlaying(true)
//
//        // After changing the value, isPlaying should be true
//        XCTAssertTrue(isPlaying, "isPlaying should be true after modifying _isPlaying")
//
//        // Clean up the subscription
//        cancellable.cancel()
//    }
//

}
