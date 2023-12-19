import Foundation
import XCTest
@testable import Voice_AI

class TimeLoggerTests: XCTestCase {
    var timeLogger: TimeLogger!

    override func setUp() {
        super.setUp()
        timeLogger = TimeLogger(vendor: "openai", endpoint: "completion")
    }

    override func tearDown() {
        timeLogger = nil
        super.tearDown()
    }
    func testSetModel() {
        timeLogger.setModel(model: "test")
        XCTAssertNotNil(timeLogger.getModel())
    }
    
    func testSetAppRec() {
        timeLogger.setAppRec()
        XCTAssertNotEqual(timeLogger.getAppRec(), 0)
        // check for case not nil
        timeLogger.setAppRec()
        XCTAssertNotEqual(timeLogger.getAppRec(), 0)
    }
    
    func testSetSttRec() {
        timeLogger.setSttRec()
        XCTAssertNotEqual(timeLogger.getSttRec(), 0)
        // check for case not nil
        timeLogger.setSttRec()
        XCTAssertNotEqual(timeLogger.getSttRec(), 0)
    }
    
    func testSetAppRecEnd() {
        timeLogger.setAppRecEnd()
        XCTAssertNotEqual(timeLogger.getAppRecEnd(), 0)
        // check for case not nil
        timeLogger.setAppRecEnd()
        XCTAssertNotEqual(timeLogger.getAppRecEnd(), 0)
    }
    
    func testSetSTTEnd() {
        timeLogger.setSTTEnd()
        XCTAssertNotEqual(timeLogger.getSTTEnd(), 0)
        // check for case not nil
        timeLogger.setSTTEnd()
        XCTAssertNotEqual(timeLogger.getSTTEnd(), 0)
    }
    
    func testSetAppSend() {
        timeLogger.setAppSend()
        XCTAssertNotEqual(timeLogger.getAppSend(), 0)
        // check for case not nil
        timeLogger.setAppSend()
        XCTAssertNotEqual(timeLogger.getAppSend(), 0)
    }
    
    func testSetTTSInit() {
        timeLogger.setTTSInit()
        XCTAssertNotEqual(timeLogger.getTTSInit(), 0)
        // check for case not nil
        timeLogger.setTTSInit()
        XCTAssertNotEqual(timeLogger.getTTSInit(), 0)
    }
    
    func testSetTTSFirst() {
        timeLogger.setTTSFirst()
        XCTAssertNotEqual(timeLogger.getTTSFirst(), 0)
        // check for case not nil
        timeLogger.setTTSFirst()
        XCTAssertNotEqual(timeLogger.getTTSFirst(), 0)
    }
    
    func testSetTTSEnd() {
        timeLogger.setTTSEnd()
        XCTAssertNotEqual(timeLogger.getTTSEnd(), 0)
    }
    
    func testSetAppResFirst() {
        timeLogger.setAppResFirst()
        XCTAssertNotEqual(timeLogger.getAppResFirst(), 0)
        // check for case not nil
        timeLogger.setAppResFirst()
        XCTAssertNotEqual(timeLogger.getAppResFirst(), 0)
    }
    
    func testSetAppResEnd() {
        timeLogger.setAppResEnd()
        XCTAssertNotEqual(timeLogger.getAppResEnd(), 0)
    }
    
    func testSetInferenceStats() {
        timeLogger.setInferenceStats()
        let values = timeLogger.getInferenceStats()
        XCTAssertTrue(timeLogger.getLogged())
        XCTAssertNotEqual(timeLogger.getAppResFirst(), 0)
        XCTAssertNotEqual(timeLogger.getAppResEnd(), 0)
        XCTAssertTrue(!values.contains(where: { $0.value == nil }))
    }
    
    func testSetInferenceStatsLoggedTrue() {
        //perhaps adding a "called variable" in the return statement would be better?
        XCTAssertFalse(timeLogger.getLogged())
        timeLogger.setInferenceStats(test: true)
        XCTAssertNotNil(timeLogger.getAppResFirst())
        XCTAssertTrue(timeLogger.getLogged())
        timeLogger.setInferenceStats()
    }
    
    func testSendLog() {
        XCTAssertFalse(timeLogger.getLogSend())
        timeLogger.sendLog()
        XCTAssertNotEqual(timeLogger.getTTSInit(), 0)
        XCTAssertNotEqual(timeLogger.getTTSFirst(), 0)
        XCTAssertNotEqual(timeLogger.getTTSEnd(), 0)
        timeLogger.sendLog()
        XCTAssertTrue(timeLogger.getLogSend())
    }
    
    func testSendLogPrintDebugTrue() {
        timeLogger.setPrintDebug(printBool: true)
        timeLogger.sendLog()
        XCTAssertNotEqual(timeLogger.getTTSInit(), 0)
        XCTAssertNotEqual(timeLogger.getTTSFirst(), 0)
        XCTAssertNotEqual(timeLogger.getTTSEnd(), 0)
        timeLogger.sendLog()
        XCTAssertTrue(timeLogger.getLogSend())
    }
}
