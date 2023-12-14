import Foundation
import XCTest
@testable import Voice_AI

class DataFeedTests: XCTestCase {

    var urlSession: URLSession!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession.init(configuration: configuration)
    }

    func testFetchDataSourcesAndParseSuccessfully() {
        let expectation = XCTestExpectation(description: "Fetch one data sources and parse successfully")
        let dataFeed = DataFeed()
        dataFeed.getData() { result in
            XCTAssertNotNil(result, "Data should not be nil")
            XCTAssertFalse(result?.isEmpty ?? true, "Data should not be empty")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testFetchEmptySource() {
        let expectation = XCTestExpectation(description: "Fetch empty source with nil result")
        let dataFeed = DataFeed()
        dataFeed.sources = [""]
        dataFeed.getData() { result in
            XCTAssertNil(result, "Result should be nil")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchInvalidUrlAndFailToFetchContent() {
        let expectation = XCTestExpectation(description: "Fetch invalid url and fail to fetch content")
        let dataFeed = DataFeed()
        dataFeed.sources = ["https://invalidurl.com"]
        dataFeed.getData() { result in
            XCTAssertNil(result)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchNonUtf8Content() {
        let expectation = XCTestExpectation(description: "Fetch invalid url and fail to fetch content")
        let dataFeed = DataFeed()
        dataFeed.sources = ["https://github.com/harmony-one/x/blob/main/data/unitTests_nonUtf8conent.json"]
        DataFeed().getData() { result in
            XCTAssertNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    
    func testParseJasonContentEmptyString() {
        // Given
        let content: String? = ""
        
        // When
        let result = DataFeed().publicFuncToTestParseJsonContent(content!)
        
        // Then
        XCTAssertNil(result, "Result should be nil")
    }

    func testParseJasonContentNil() {
        // Arrange
        let dataFeed = DataFeed()
        let content: String? = nil
        
        // Act
        let result = dataFeed.publicFuncToTestParseJsonContent(content)
        
        // Assert
        XCTAssertNil(result)
    }

    func testFetchDataAndCallCompletionHandler() {
        let expectation = XCTestExpectation(description: "Fetch data and call completion handler")

        let url = URL(string: DataFeed().sources[0])!
        DataFeed().publicFuncToTestFetchContent(from: url) { content in
            XCTAssertNotNil(content)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }


    func testGetData_EmptyResponse() {
        // Test that getData returns nil when the response is empty
        let expectation = XCTestExpectation(description: "completion called with nil")
        let dataFeed = DataFeed()
        dataFeed.sources = ["https://example.com/empty"]
        dataFeed.getData(completion: { (data) in
            XCTAssertNil(data)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }

    func testGetData_ErrorResponse() {
        // Test that getData returns nil when the response is an error
        let expectation = XCTestExpectation(description: "completion called with error")
        let dataFeed = DataFeed()
        dataFeed.sources = ["https://example.com/empty"]
        dataFeed.getData(completion: { (data) in
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
    
    func testFetchBtcDataAndParseSuccessfullyByMock() {
        let expectation = XCTestExpectation(description: "Fetch btc data and parse successfully")
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
              throw NSError(domain: "error", code: -1)
            }
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            let responseString = #"""
{
  "payload": {
    "blob": {
      "rawLines": [
        "{\r",
        "    \"content\": [\r",
        "        \"some string 01\",\r",
        "        \"some string 02\"\r",
        "    ]\r",
        "}\r"
      ]
    }
  }
}
"""#
            let data = responseString.data(using: .utf8)
            return (response, data)
        }
        DataFeed().getData() { result in
            XCTAssertNotNil(result, "Data should not be nil")
            XCTAssertFalse(result?.isEmpty ?? true, "Data should not be empty")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchBtcDataAndEmptyContentByMock() {
        let expectation = XCTestExpectation(description: "Fetch btc data and parse successfully")
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
              throw NSError(domain: "error", code: -1)
            }
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            let responseString = ""
            let data = responseString.data(using: .utf8)
            return (response, data)
        }
        DataFeed(urlSession: urlSession).getData() { result in
            XCTAssertNil(result, "Data should be nil")
            XCTAssertTrue(result?.isEmpty ?? true, "Data should be empty")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

}
