import XCTest
@testable import Voice_AI

class TimeLoggerTests: XCTestCase {
    var timeLogger: TimeLogger!
    let vendor = "TestVendor"
    let endpoint = "TestEndpoint"

    override func setUp() {
        super.setUp()
        timeLogger = TimeLogger(vendor: vendor, endpoint: endpoint)
    }

    override func tearDown() {
        timeLogger = nil
        super.tearDown()
    }

    func testTimeLoggerInitialization() {
        XCTAssertNotNil(timeLogger, "TimeLogger should be initialized")
    }

    func testReset() {
        timeLogger.reset()
        let expectedStartTime = Int64(Date().timeIntervalSince1970 * 1000000)
    }

    func testOnceFlag() {
        let onceTimeLogger = TimeLogger(vendor: vendor, endpoint: endpoint, once: true)
        onceTimeLogger.log()
        
        sleep(1)
        onceTimeLogger.log()
    }
    
    func testTryCheck() {
        timeLogger.tryCheck()

        sleep(1)
        
        timeLogger.tryCheck()
    }
}
