import XCTest
@testable import Voice_AI

class VibrationManagerTests: XCTestCase {

    func testStartVibration() {
        VibrationManager.startVibration()
        XCTAssertTrue(VibrationManager.isVibrating, "VibrationManager should be in a vibrating state")
        XCTAssertNotNil(VibrationManager.timer, "Timer should be initialized when starting vibration")
    }

    func testStopVibration() {
        VibrationManager.stopVibration()
        XCTAssertFalse(VibrationManager.isVibrating, "VibrationManager should not be in a vibrating state after stopping")
        XCTAssertNil(VibrationManager.timer, "Timer should be nil after stopping vibration")
    }
    
    func testVibrate() {
        // Check if generator is created when it's nil
        VibrationManager.isVibrating = true
        VibrationManager.generator = nil // Simulate a nil generator
        VibrationManager.vibrate()

        XCTAssertNotNil(VibrationManager.generator, "generator should have been created")
        
        // Check is impactOccurred() and prepare() are called when generator is created
        let mockGenerator = MockGenerator(style: .medium)
        VibrationManager.generator = mockGenerator

        VibrationManager.isVibrating = true
        VibrationManager.vibrate()

        XCTAssertTrue(mockGenerator.impactOccurredCalled, "impactOccured() should have been called")
        XCTAssertTrue(mockGenerator.prepareCalled, "prepare() should have been called")
    }
}
