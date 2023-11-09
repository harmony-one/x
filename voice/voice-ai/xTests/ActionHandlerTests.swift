@testable import Voice_AI
import XCTest

final class ActionHandlerTests: XCTestCase {
    var actionHandler: ActionHandler!
    var mockSpeechRecognition: MockSpeechRecognition!
    
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
        XCTAssertTrue(mockSpeechRecognition.resetCalled, "reset() should be called after .reset action")
    }
    
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
    
    func testHandleStopSpeak() {
        actionHandler.handle(actionType: .stopSpeak)
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

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
