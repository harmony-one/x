import XCTest
@testable import Voice_AI

class VibrationManagerTests: XCTestCase {

    func testStartVibration() {
        VibrationManager.startVibration()
        XCTAssertTrue(VibrationManager.isVibrating, "VibrationManager should be in a vibrating state")
        XCTAssertNotNil(VibrationManager.timer, "Timer should be initialized when starting vibration")
    }

//    func testStopVibration() {
//        VibrationManager.stopVibration()
//        XCTAssertFalse(VibrationManager.isVibrating, "VibrationManager should not be in a vibrating state after stopping")
//        XCTAssertNil(VibrationManager.timer, "Timer should be nil after stopping vibration")
//    }
}
