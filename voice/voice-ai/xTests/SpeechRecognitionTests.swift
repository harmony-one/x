@testable import Voice_AI
import XCTest
import StoreKit
import SwiftUI

// struct SpeechRecognitionProtocolTest: SpeechRecognitionProtocol {}
//
// func testReset() {
//    let test = SpeechRecognitionProtocolTest()
//    XCTAssertEqual(true,test.reset())
// }

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
    
    var speechRecognition: MockSpeechRecognition!

   override func setUp() {
       super.setUp()
       speechRecognition = MockSpeechRecognition()
   }
    
    // Test the `isPaused()` function
    func testIsPaused() {
        // Create a mock SpeechRecognition object
        let mockSpeechRecognition = MockSpeechRecognition()

        // Call the `isPaused()` function
        _ = mockSpeechRecognition.isPaused()

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

    // Test the `surprise()` function
    func testSurprise() {
        // Create a mock SpeechRecognition object
        let mockSpeechRecognition = MockSpeechRecognition()

        // Call the `surprise()` function
        mockSpeechRecognition.surprise()

        // Assert that the `surpriseCalled` property is set to `true`
        XCTAssertTrue(mockSpeechRecognition.surpriseCalled)
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
    
    func testIsPlayingPublisherGetter() {
        let mockSpeechRecognition = MockSpeechRecognition()

        let isPlayingPublisher = mockSpeechRecognition.isPlayingPublisher

        // Assert: Verify the result
        var isPlaying = false
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
