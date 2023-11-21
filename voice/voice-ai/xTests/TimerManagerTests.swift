import XCTest
import Combine
@testable import Voice_AI

class TimerManagerTests: XCTestCase {
    func testStartTimer() {
        let timerManager = TimerManager()
        XCTAssertNil(timerManager.timerCancellable)
        timerManager.startTimer()
        sleep(2)
        XCTAssertNotNil(timerManager.timerCancellable)
    }

    func testResetTimer() {
        let timerManager = TimerManager()
        XCTAssertNil(timerManager.timerCancellable)
        timerManager.resetTimer()
        sleep(2)
        XCTAssertNotNil(timerManager.timerCancellable)
    }

    func testStopTimer() {
        let timerManager = TimerManager()
        XCTAssertNil(timerManager.timerCancellable)
        
        timerManager.startTimer()
        sleep(2)
        XCTAssertNotNil(timerManager.timerCancellable)
        
        timerManager.stopTimer()
        sleep(2)
        XCTAssertNil(timerManager.timerCancellable)
    }
}
