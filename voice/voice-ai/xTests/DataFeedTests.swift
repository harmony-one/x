import Foundation
import XCTest
@testable import Voice_AI

class DataFeedTests: XCTestCase {
    
    func testFetchDataSourcesAndParseSuccessfully() {
        let expectation = XCTestExpectation(description: "Fetch one data sources and parse successfully")
        let dataFeed = DataFeed.shared
        let followNews = "APPL"
        dataFeed.getData(followNews: followNews) { result in
            XCTAssertNotNil(result, "Data should not be nil")
            XCTAssertFalse(result?.isEmpty ?? true, "Data should not be empty")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testFetchEmptySource() {
        let expectation = XCTestExpectation(description: "Fetch empty source with nil result")
        let dataFeed = DataFeed.shared
        let followNews = "APPL"
        dataFeed.newsMap = [:]
        dataFeed.getData(followNews: followNews) { result in
            XCTAssertNil(result, "Result should be nil")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testFetchInvalidUrlAndFailToFetchContent() {
        let expectation = XCTestExpectation(description: "Fetch invalid url and fail to fetch content")
        let dataFeed = DataFeed.shared
        let followNews = "APPL"
        dataFeed.newsMap = [
            "APPL": "https://invalidurl.com"
        ]
        dataFeed.getData(followNews: followNews) { result in
            XCTAssertNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }

    func testFetchNonUtf8Content() {
        let expectation = XCTestExpectation(description: "Fetch invalid url and fail to fetch content")
        let dataFeed = DataFeed.shared
        let followNews = "APPL"
        dataFeed.newsMap = [
            "APPL": "https://github.com/harmony-one/x/blob/main/data/unit-tests-non-utf8.txt"
        ]
        DataFeed.shared.getData(followNews: followNews) { result in
            XCTAssertNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testParseJasonContentEmptyString33() {
        // Given
        let content = "{\"payload\": {\"blob\": {}}"
        
        // When
        let result = DataFeed.shared.publicFuncToTestParseJsonContent(content)
        
        // Then
        XCTAssertNil(result, "Result should be nil")
    }
    
    
    func testParseJasonContentEmptyString() {
        // Given
        let content: String? = ""
        
        // When
        let result = DataFeed.shared.publicFuncToTestParseJsonContent(content!)
        
        // Then
        XCTAssertNil(result, "Result should be nil")
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
        
        let url = URL(string: DataFeed.shared.newsMap["APPL"] ?? "")!
        DataFeed.shared.publicFuncToTestFetchContent(from: url) { content in
            XCTAssertNotNil(content)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 15.0)
    }
    
    
}
