import Foundation
import XCTest
@testable import Voice_AI

class DataFeedTests: XCTestCase {
        
    func testFetchOneDataAndParseSuccessfully() {
        let expectation = XCTestExpectation(description: "Fetch one data and parse successfully")
        let dataFeed = DataFeed.shared
        dataFeed.getData(from: dataFeed.oneSource) { result in
            XCTAssertNotNil(result, "Data should not be nil")
            XCTAssertFalse(result?.isEmpty ?? true, "Data should not be empty")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testFetchEmptySource() {
        let expectation = XCTestExpectation(description: "Fetch one data and parse successfully")
        let dataFeed = DataFeed.shared
        dataFeed.getData(from: "") { result in
            XCTAssertNil(result, "Result should be nil")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchInvalidUrlAndFailToFetchContent() {
        let expectation = XCTestExpectation(description: "Fetch invalid url and fail to fetch content")
        
        DataFeed.shared.getData(from: "https://invalidurl.com") { result in
            XCTAssertNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    
    func testParseJasonContentEmptyString() {
        // Given
        let content: String? = ""
        
        // When
        let result = DataFeed.shared.publicFuncToTestParseJsonContent(content!)
        
        // Then
        XCTAssertNil(result, "Result should be nil")
    }
    
    func testParseJasonContentNonUTF8String() {
        // Arrange
        let dataFeed = DataFeed.shared
        let content = "invalid json with non utf8 string óñ"
        
        // Act
        let result = dataFeed.publicFuncToTestParseJsonContent(content)
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testParseJasonContentNil() {
        // Arrange
        let dataFeed = DataFeed.shared
        let content: String? = nil
        
        // Act
        let result = dataFeed.publicFuncToTestParseJsonContent(content)
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testFetchDataAndCallCompletionHandler() {
        let expectation = XCTestExpectation(description: "Fetch data and call completion handler")
        
        let url = URL(string: "https://github.com/harmony-one/x/blob/main/data/btc.json")!
        DataFeed.shared.publicFuncToTestFetchContent(from: url) { content in
            XCTAssertNotNil(content)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
}
