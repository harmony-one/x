import Foundation
import XCTest
@testable import Voice_AI

class LogStoreTests: XCTestCase {
    var logStore: LogStore!

    @MainActor override func setUp() {
        super.setUp()
        logStore = LogStore()
    }

    override func tearDown() {
        logStore = nil
        super.tearDown()
    }
    
    func testPerformExport() async {
        do {
            let entries = try await logStore.performExport()
            XCTAssertNotNil(entries)
        } catch {
            XCTFail("Error: \(error)")
        }
    }
    
    func testExportInBackground() {
        let expectation = XCTestExpectation(description: "Background export completed")
        logStore.exportInBackground {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(logStore.entries)
    }
}
