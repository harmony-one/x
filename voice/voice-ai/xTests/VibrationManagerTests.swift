import XCTest
@testable import Voice_AI

    class VibrationManagerTests: XCTestCase {
        var vibrationManager: VibrationManager!
        
        override func setUp() {
            super.setUp()
            vibrationManager = VibrationManager.shared
        }

        override func tearDown() {
            vibrationManager.stopVibration()
            super.tearDown()
        }
        
        func testStartVibration() {
            vibrationManager.startVibration()
            XCTAssertTrue(vibrationManager.isVibrating,  "VibrationManager should be in a vibrating state")
            XCTAssertNotNil(vibrationManager.timer,   "Timer should be initialized when starting vibration")
        }
        
        func testStopVibration() {
            vibrationManager.startVibration()
            vibrationManager.stopVibration()
            XCTAssertFalse(vibrationManager.isVibrating, "VibrationManager should not be in a vibrating state after stopping")
            XCTAssertNil(vibrationManager.timer, "Timer should be nil after stopping vibration")
        }
        
        func testVibrate() {
            // Check if generator is created when it's nil
            vibrationManager.isVibrating = true
            vibrationManager.generator = nil // Simulate a nil generator
            vibrationManager.vibrate()

            XCTAssertNotNil(vibrationManager.generator, "generator should have been created")
            
            // Check is impactOccurred() and prepare() are called when generator is created
            let mockGenerator = MockGenerator(style: .medium)
            vibrationManager.generator = mockGenerator

            vibrationManager.isVibrating = true
            vibrationManager.vibrate()

            XCTAssertTrue(mockGenerator.impactOccurredCalled, "impactOccured() should have been called")
            XCTAssertTrue(mockGenerator.prepareCalled, "prepare() should have been called")
        }
        
        func testVibrateOnce() {
            // Check if generator is created when it's nil
            vibrationManager.isVibrating = true
            vibrationManager.generator = nil // Simulate a nil generator
            vibrationManager.vibrate()

            XCTAssertNotNil(vibrationManager.generator, "generator should have been created")
            
            // Check is impactOccurred() and prepare() are called when generator is created
            let mockGenerator = MockGenerator(style: .medium)
            vibrationManager.generator = mockGenerator

            vibrationManager.isVibrating = true
            vibrationManager.vibrateOnce()

            XCTAssertTrue(mockGenerator.impactOccurredCalled, "impactOccured() should have been called")
            XCTAssertTrue(mockGenerator.prepareCalled, "prepare() should have been called")
        }
    }

