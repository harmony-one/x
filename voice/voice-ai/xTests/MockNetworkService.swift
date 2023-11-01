//
//  MockNetworkService.swift
//  Voice AITests
//
//  Created by Francisco Egloff on 1/11/23.
//

import Foundation

//protocol NetworkService {
//    func dataTask(
//        with request: URLRequest,
//        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
//    ) -> URLSessionDataTask
//}

//class MockNetworkService: NetworkService {
//    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//        // Create a mock URLSessionDataTask or use other methods for testing
//        return MockURLSessionDataTask(completionHandler: completionHandler)
//    }
//}

class MockNetworkService: NetworkService {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        // Create a mock URLSessionDataTask or use other methods for testing
        return MockURLSessionDataTask()
    }
}


class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {
        // Do nothing for testing
    }
}

//class URLSessionDataTaskMock: URLSessionDataTask {
//    override func resume() {
////        closure()
//    }
//}

//class MockNetworkService: NetworkService {
//    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
//    // data and error can be set to provide data or an error
//    var data: Data?
//    var error: Error?
//    func dataTask(
//        with url: URL,
//        completionHandler: @escaping CompletionHandler
//        ) -> URLSessionDataTaskMock {
//        let data = self.data
//        let error = self.error
//        return URLSessionDataTaskMock{
//            completionHandler(data, nil, error)
//        }
//    }
//}

//class MockURLSessionDataTask: URLSessionDataTask {
//    private let completionHandler: (Data?, URLResponse?, Error?) -> Void
//
//    init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
//        self.completionHandler = completionHandler
//    }
//    
//    override func resume() {
//        // Simulate network request and provide mock data, response, and error
//        let mockData = "Mock response data".data(using: .utf8)
//        let mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
//        completionHandler(mockData, mockResponse, nil)
//    }
//}


