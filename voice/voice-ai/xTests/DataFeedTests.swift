import Foundation
import XCTest
@testable import Voice_AI

class DataFeedTests: XCTestCase {
    
    // Fetch data from btc source and parse it successfully
    func test_fetch_btc_data_and_parse_successfully2() {
        let expectation = XCTestExpectation(description: "Fetch btc data and parse successfully")
        let dataFeed = DataFeed.shared
        dataFeed.getData(from: dataFeed.btcSource) { result in
            XCTAssertNotNil(result, "Data should not be nil")
            XCTAssertFalse(result?.isEmpty ?? true, "Data should not be empty")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    
    func test_fetch_invalid_url_and_fail_to_fetch_content() {
        let expectation = XCTestExpectation(description: "Fetch invalid url and fail to fetch content")
        
        DataFeed.shared.getData(from: "https://invalidurl.com") { result in
            XCTAssertNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
}
