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
