import XCTest
@testable import Voice_AI


//struct SpeechRecognitionProtocolTest: SpeechRecognitionProtocol {}
//
//func testReset() {
//    let test = SpeechRecognitionProtocolTest()
//    XCTAssertEqual(true,test.reset())
//}



class SpeechRecognitionTests: XCTestCase {

    // Test the `isPaused()` function
    func testIsPaused() {
        // Create a mock SpeechRecognition object
        let mockSpeechRecognition = MockSpeechRecognition()

        // Call the `isPaused()` function
        let paused = mockSpeechRecognition.isPaused()

        // Assert that the `isPausedCalled` property is set to `true`
        XCTAssertTrue(mockSpeechRecognition.isPausedCalled)
    }

    // Test the `reset()` function
    func testReset() {
        // Create a mock SpeechRecognition object
        let mockSpeechRecognition = MockSpeechRecognition()

        // Call the `reset()` function
        mockSpeechRecognition.reset()

        // Assert that the `resetCalled` property is set to `true`
        XCTAssertTrue(mockSpeechRecognition.resetCalled)
    }

    // Test the `speak()` function
    func testSpeak() {
        // Create a mock SpeechRecognition object
        let mockSpeechRecognition = MockSpeechRecognition()

        // Call the `speak()` function
        mockSpeechRecognition.speak()

        // Assert that the `speakCalled` property is set to `true`
        XCTAssertTrue(mockSpeechRecognition.speakCalled)
    }

    // Test the `randomFacts()` function
    func testRandomFacts() {
        // Create a mock SpeechRecognition object
        let mockSpeechRecognition = MockSpeechRecognition()

        // Call the `randomFacts()` function
        mockSpeechRecognition.randomFacts()

        // Assert that the `randomFactsCalled` property is set to `true`
        XCTAssertTrue(mockSpeechRecognition.randomFactsCalled)
    }

    // Test the `continueSpeech()` function
    func testContinueSpeech() {
        // Create a mock SpeechRecognition object
        let mockSpeechRecognition = MockSpeechRecognition()

        // Call the `continueSpeech()` function
        mockSpeechRecognition.continueSpeech()

        // Assert that the `continueSpeechCalled` property is set to `true`
        XCTAssertTrue(mockSpeechRecognition.continueSpeechCalled)
    }

    // Test the `pause()` function
    func testPause() {
        // Create a mock SpeechRecognition object
        let mockSpeechRecognition = MockSpeechRecognition()

        // Call the `pause()` function
        mockSpeechRecognition.pause()

        // Assert that the `pauseCalled` property is set to `true`
        XCTAssertTrue(mockSpeechRecognition.pauseCalled)
    }

    func testIsPlaningPublisherGetter() {
        let mockSpeechRecognition = MockSpeechRecognition()
        
        let isPlayingPublisher = mockSpeechRecognition.isPlaingPublisher

         // Assert: Verify the result
         var isPlaying: Bool = false
         let cancellable = isPlayingPublisher.sink { isPlaying = $0 }
         
         // At this point, isPlaying should be false by default
         XCTAssertFalse(isPlaying, "isPlaying should initially be false")
         
         // You can modify _isPlaying to change the value
        mockSpeechRecognition.setIsPlaying(true)
         
         // After changing the value, isPlaying should be true
         XCTAssertTrue(isPlaying, "isPlaying should be true after modifying _isPlaying")

         // Clean up the subscription
         cancellable.cancel()
    }
    
    // Test the `repeate()` function
    func testRepeate() {
        // Create a mock SpeechRecognition object
        let mockSpeechRecognition = MockSpeechRecognition()

        // Call the `repeate()` function
        mockSpeechRecognition.repeate()

        // Assert that the `repeateCalled` property is set to `true`
        XCTAssertTrue(mockSpeechRecognition.repeateCalled)
    }
}
