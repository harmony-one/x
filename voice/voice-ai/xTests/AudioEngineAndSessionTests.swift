//
//  AudioEngineAudioSessionTests.swift
//  Voice AITests
//
//  Created by Nagesh Kumar Mishra on 02/11/23.
//

import XCTest
import AVFoundation
@testable import Voice_AI // Replace with your app's module name

class MockAudioSession: AVAudioSessionProtocol {
    
    func setMode(_ options: AVAudioSession.Mode) throws {
    }
    
    var shouldFailSetup = false
    
    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, options: AVAudioSession.CategoryOptions) throws {
        if shouldFailSetup {
            throw NSError(domain: "MockAudioSessionErrorDomain", code: 123, userInfo: nil)
        }
    }
    
    func setActive(_ active: Bool, options: AVAudioSession.SetActiveOptions) throws {
        if shouldFailSetup {
            throw NSError(domain: "MockAudioSessionErrorDomain", code: 456, userInfo: nil)
        }
    }
}

final class AudioEngineAndSessionTests: XCTestCase {
    var speechRecognition: SpeechRecognition!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        speechRecognition = SpeechRecognition()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        speechRecognition = nil
        
    }
    
    func testSetupAudioSession() {
        // Ensure that audio session setup succeeds
        speechRecognition.setupAudioSession()
        XCTAssertTrue(speechRecognition.getISAudioSessionSetup())
    }
    
    func testSetupAudioEngine() {
        // Ensure that audio engine setup succeeds
        speechRecognition.setupAudioEngine()
        let inputNode = speechRecognition.getAudioEngine().inputNode
        speechRecognition.startSpeechRecognition()
        XCTAssertTrue(speechRecognition.getAudioEngine().isRunning)
    }
    
    // Test scenarios where audio session setup might fail (e.g., permission issues or unsupported audio modes)
    func testAudioSessionSetupFailure() {
        // For this test, you can use a mock AVAudioSession that simulates failure scenarios.
        // Ensure that isAudioSessionSetup remains false in case of failure.
        let mockAudioSession = MockAudioSession()
        mockAudioSession.shouldFailSetup = true
        speechRecognition.audioSession = mockAudioSession
        
        speechRecognition.setupAudioSession()
        
        XCTAssertFalse(speechRecognition.getISAudioSessionSetup())
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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
