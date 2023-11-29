import XCTest
@testable import Voice_AI

class QueryBenchmarkTests: XCTestCase {
    
    var openAIStreamService: OpenAIStreamService!
    var urlSession: URLSession!

    override func setUp() {
        super.setUp()
        openAIStreamService = OpenAIStreamService(completion: { _, _ in })
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession.init(configuration: configuration, delegate: openAIStreamService, delegateQueue: nil)
        openAIStreamService.setNetworkService(urlSession: urlSession)
    }

    func testQueryPerformance() {
        let testConversation: [Message] = createTestConversation()

        measure {
            let expectation = XCTestExpectation(description: "Completion handler should be called")

            MockURLProtocol.requestHandler = { request in
                return self.mockResponseFor(request: request)
            }

            openAIStreamService.query(conversation: testConversation)
            wait(for: [expectation], timeout: 5)
        }
    }

    func testQueryWithDifferentPayloads() {
        let testConversations = [createTestConversation(), createAnotherTestConversation()]

        for testConversation in testConversations {
            let expectation = XCTestExpectation(description: "Completion handler should be called for different payloads")

            MockURLProtocol.requestHandler = { request in
                return self.mockResponseFor(request: request)
            }

            openAIStreamService.query(conversation: testConversation)
            wait(for: [expectation], timeout: 5)
        }
    }

    private func createTestConversation() -> [Message] {
        var testConversation: [Message] = []
        testConversation.append(contentsOf: OpenAIStreamService.setConversationContext())
        testConversation.append(Message(role: "user", content: "Hello"))
        return testConversation
    }

    private func createAnotherTestConversation() -> [Message] {
        // Create a different conversation setup
    }

    private func mockResponseFor(request: URLRequest) -> (HTTPURLResponse, Data?) {
        guard let url = request.url else {
            throw NSError(domain: "error", code: -1)
        }

        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let responseString = """
        data:
        [DONE]
        """
        let data = responseString.data(using: .utf8)
        return (response, data)
    }
}
