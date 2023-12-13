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
    
    func testFetchNonUtf8Content() {
        let expectation = XCTestExpectation(description: "Fetch invalid url and fail to fetch content")
        var nonUtf8 = "https://github.com/harmony-one/x/blob/main/data/unitTests_nonUtf8conent.json"
        
        DataFeed.shared.getData(from: nonUtf8) { result in
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
        
        let url = URL(string: DataFeed.shared.btcSource)!
        DataFeed.shared.publicFuncToTestFetchContent(from: url) { content in
            XCTAssertNotNil(content)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
 

    func testGetData_EmptyResponse() {
        // Test that getData returns nil when the response is empty
        let expectation = XCTestExpectation(description: "completion called with nil")
        DataFeed.shared.getData(from: "https://example.com/empty", completion: { (data) in
            XCTAssertNil(data)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }

    func testGetData_ErrorResponse() {
        // Test that getData returns nil when the response is an error
        let expectation = XCTestExpectation(description: "completion called with error")
        DataFeed.shared.getData(from: "https://example.com/error", completion: { (data) in
            XCTAssertNil(data)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }
    
    func testParseJsonContent_ValidJson_ReturnsDictionary() {
         let content = "{\"key\": \"value\"}"
         guard let jsonData = content.data(using: .utf8) else {
             XCTFail("Failed to convert content to data")
             return
         }
         let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String]
         XCTAssertNotNil(dictionary)
         XCTAssertEqual(dictionary?["key"], "value")
     }

     func testParseJsonContent_InvalidJson_ReturnsNil() {
         let content = "Invalid JSON"
         guard let jsonData = content.data(using: .utf8) else {
             XCTFail("Failed to convert content to data")
             return
         }
         XCTAssertThrowsError(try JSONSerialization.jsonObject(with: jsonData, options: []))
     }

}
