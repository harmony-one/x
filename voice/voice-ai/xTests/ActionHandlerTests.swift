//
//  xTests.swift
//  xTests
//
//  Created by Aaron Li on 10/13/23.
//

import XCTest
@testable import Voice_AI

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
        
    }
    
    // Test if the skip action stops the recording when it's already recording
    func testHandleSkipWhileRecording() {
        actionHandler.isRecording = true
        actionHandler.handle(actionType: .skip)
        XCTAssertFalse(actionHandler.isRecording)
    }
    
    // Test if random fact action calls the randomFacts() method in our mock
    func testHandleRandomFact() {
        actionHandler.handle(actionType: .randomFact)
        XCTAssertTrue(mockSpeechRecognition.randomFactsCalled)
    }
    
    // Test if repeatLast action calls the repeate() method in our mock
    func testHandleRepeatLast() {
        actionHandler.handle(actionType: .repeatLast)
        XCTAssertTrue(mockSpeechRecognition.repeateCalled)
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