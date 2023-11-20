import XCTest
@testable import Voice_AI

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
    }
}

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var urlSession: URLSession!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        networkManager = NetworkManager(session: urlSession)
    }

    override func tearDown() {
        networkManager = nil
        urlSession = nil
        super.tearDown()
    }

    func testURLCreation() {
        let url = networkManager.createURL(endpoint: "/test", parameters: ["key": "value"])
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://api.yourdomain.com/test?key=value")
    }

    func testRequestDataSuccess() {
        let expectedData = "{\"key\":\"value\"}".data(using: .utf8)
        let expectedResponse = HTTPURLResponse(url: URL(string: "https://api.yourdomain.com/test")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.requestHandler = { request in
            return (expectedResponse, expectedData)
        }
        
        let expectation = self.expectation(description: "response")
        networkManager.requestData(from: "/test", method: .get) { (result: Result<NetworkResponse<[String: String]>, NetworkError>) in
            switch result {
            case .success(let networkResponse):
                XCTAssertEqual(networkResponse.data, ["key": "value"])
            case .failure:
                XCTFail("Expected successful response")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
