import Foundation

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




protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

class StubURLSession: NetworkService {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = StubURLSessionDataTask()
//        return MockURLSessionDataTask()
        return task
    }
}

class StubURLSessionDataTask: URLSessionDataTask {
//    private let data: Data?
//    private let response: URLResponse?
//    private let error: Error?
//    private let completionHandler: (Data?, URLResponse?, Error?) -> Void
    
//    init(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
//        self.data = data
//        self.response = response
//        self.error = error
//        self.completionHandler = completionHandler
//    }
    
    override func resume() {
//        completionHandler(nil, nil, nil)
    }
    
    override func cancel() {
        // Handle cancellation if needed
    }
}


