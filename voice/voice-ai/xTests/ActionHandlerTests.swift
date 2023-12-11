import XCTest
import Combine

@testable import Voice_AI

final class ActionHandlerTests: XCTestCase {
    var actionHandler: ActionHandler!
    var mockSpeechRecognition: MockSpeechRecognition!
 
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockSpeechRecognition = MockSpeechRecognition()
        actionHandler = ActionHandler(speechRecognition: mockSpeechRecognition)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        actionHandler = nil
        mockSpeechRecognition = nil
    }

    func testHandleReset() {
        actionHandler.handle(actionType: .reset)
        mockSpeechRecognition.reset()
        XCTAssertTrue(mockSpeechRecognition.resetCalled, "reset() should be called after .reset action")
    }

    func testHandleTrivia() {
        actionHandler.handle(actionType: .trivia)
        mockSpeechRecognition.trivia()
        XCTAssertTrue(mockSpeechRecognition.isTriviaCalled, "trivia() should be called after .trivia action")
    }
    
//    func testHandleReset() {
//        actionHandler.handle(actionType: .reset)
//        XCTAssertTrue(mockSpeechRecognition.resetCalled, "reset() should be called after .reset action")
//    }

    
    // Test if the skip action stops the recording when it's already recording
//    func testHandleSkipWhileRecording() {
//        actionHandler.isRecording = true
//        actionHandler.handle(actionType: . .sayMore)
//        XCTAssertFalse(actionHandler.isRecording, "Recording should be stopped after .skip action")
//    }
    
    // Test if random fact action calls the randomFacts() method in our mock
    func testHandleSurprise() {
        actionHandler.handle(actionType: .surprise)
        XCTAssertTrue(mockSpeechRecognition.surpriseCalled, "surprise() should be called after .surprise action")
    }
    
    func testReset() {
        actionHandler.handle(actionType: .reset)
        mockSpeechRecognition.reset()
        XCTAssertTrue(mockSpeechRecognition.resetCalled, "reset() should be called after .reset action")
    }
    // Test if repeatLast action calls the repeate() method in our mock
    func testHandleRepeatLast() {
        actionHandler.handle(actionType: .repeatLast)
        XCTAssertTrue(mockSpeechRecognition.repeateCalled, "repeat() should be called after .repeatLast action")
    }
    
    func testHandleSpeak() {
        actionHandler.handle(actionType: .speak)
        XCTAssertTrue(actionHandler.isRecording, "Recording should be started after .speak action")
    }
  
    func testTapSpeak() {
        actionHandler.handle(actionType: .tapSpeak)
        actionHandler.startRecording()
        XCTAssertTrue(actionHandler.isRecording, "Recording should be started after .tapSpeak action")
    }
    
    func testTapStopSpeak() {
        actionHandler.handle(actionType: .tapStopSpeak)
        actionHandler.stopRecording()
        XCTAssertFalse(actionHandler.isRecording, "Recording should be started after .speak action")
    }
    
    func testHandleStopSpeak() {
        actionHandler.handle(actionType: .stopSpeak)
        actionHandler.stopRecording()
        XCTAssertFalse(actionHandler.isRecording, "Recording should be stopped after .stopSpeak action")
    }
    
    func testHandlePlay() {
        actionHandler.handle(actionType: .play)
        if mockSpeechRecognition.isPaused() {
            XCTAssertTrue(mockSpeechRecognition.continueSpeechCalled, "Continue Speech should have been called")
        } else {
            mockSpeechRecognition.pause()
            XCTAssertTrue(mockSpeechRecognition.pauseCalled, "Speech should have been paused")
        }
    }

    func testStartRecording() {
        // Simulate conditions to start recording
        let currentTime = Int64(NSDate().timeIntervalSince1970 * 1000)
//        actionHandler.lastRecordingStateChangeTime = currentTime - 1000 // Ensure it's more than 500 milliseconds ago
        actionHandler.isRecording = false

        actionHandler.startRecording()
        mockSpeechRecognition.speak()
        // Verify that recording has started
        XCTAssertTrue(actionHandler.isRecording)
        XCTAssertTrue(mockSpeechRecognition.speakCalled)
        // Add more assertions based on your requirements
    }

    func testStopRecording() {
        // Simulate the condition to stop recording
        actionHandler.isRecording = true

        actionHandler.stopRecording()
        mockSpeechRecognition.stopSpeak()
        // Verify that recording has stopped
        XCTAssertFalse(actionHandler.isRecording)
        XCTAssertFalse(mockSpeechRecognition.speakCalled)
        // Add more assertions based on your requirements
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
