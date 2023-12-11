@testable import Voice_AI
import XCTest


/*

 data:
 {"choices": [{"delta": {"content": "some complition"}}]}

 */
class OpenAIServiceTests: XCTestCase {
    var openAIStreamService: OpenAIStreamService!
    private var timeLogger: TimeLogger?
    
    func testQuery() {
        var testConversation: [Message] = []
        testConversation.append(contentsOf: OpenAIStreamService.setConversationContext())
        testConversation.append(Message(role: "user", content: "Hello"))
        // print(testConversation)

        let expectation = XCTestExpectation(description: "Completion handler should be called")

        let responseString = """
data:
[DONE]
"""
        let data = responseString.data(using: .utf8)


        MockURLProtocol.requestHandler = { request in
              guard let url = request.url else {
                  throw NSError(domain: "error", code: -1)
              }

              let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
              return (response, data)
        }

        AppConfig.shared.setOpenAIKey(key: "testkey")
        AppConfig.shared.setOpenaiBaseUrl(url: "testurl")
        let openAIStreamService = OpenAIStreamService(completion: { response, error in
            expectation.fulfill()
            XCTAssertNotNil(response, "Response should not be nil")
            XCTAssertNil(error, "Error should be nil")
            // Check if both context messages exist in the conversation
            let hasContextMessages = testConversation.contains { message in
                message.role == "system"
            }
            XCTAssertTrue(hasContextMessages, "Context messages should be in the conversation")
        })

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration, delegate: openAIStreamService, delegateQueue: nil)
        openAIStreamService.setNetworkService(urlSession: urlSession)

        openAIStreamService.query(conversation: testConversation, timeLogger: timeLogger)
        wait(for: [expectation], timeout: 5)
    }
    
    func testCancelQuery() {
        var testConversation: [Message] = []
        testConversation.append(contentsOf: OpenAIStreamService.setConversationContext())
        testConversation.append(Message(role: "user", content: "Hello"))
        // print(testConversation)

        let expectation = XCTestExpectation(description: "Completion handler should be called")

        let responseString = """
data:
[DONE]
"""
        let data = responseString.data(using: .utf8)


        
        MockURLProtocol.requestHandler = { request in
              guard let url = request.url else {
                  throw NSError(domain: "error", code: -1)
              }

              let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
              return (response, data)
        }

        // put API_KEY=somestring for test
        AppConfig.shared.setOpenAIKey(key: "testkey")
        AppConfig.shared.setOpenaiBaseUrl(url: "testurl")
        let openAIStreamService = OpenAIStreamService(completion: { response, error in
            expectation.fulfill()
            if let err = error as? NSError {
                XCTAssertEqual(err.code, -999)
                XCTAssertEqual(err.domain, "NSURLErrorDomain")
            } else {
                XCTFail("should be NSError type")
            }
        })

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration, delegate: openAIStreamService, delegateQueue: nil)
        openAIStreamService.setNetworkService(urlSession: urlSession)

        openAIStreamService.query(conversation: testConversation, timeLogger: timeLogger)
        openAIStreamService.cancelOpenAICall()
        wait(for: [expectation], timeout: 5)
    }
    
    func testChunks() {
        var testConversation: [Message] = []
        testConversation.append(contentsOf: OpenAIStreamService.setConversationContext())
        testConversation.append(Message(role: "user", content: "Hello"))

        let responseString = """
data:
{"choices": [{"delta": {"content": "some complition"}}]}

data:
[DONE]
"""
        let data = responseString.data(using: .utf8)


        MockURLProtocol.requestHandler = { request in
              guard let url = request.url else {
                  throw NSError(domain: "error", code: -1)
              }

              let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
              return (response, data)
        }

        // put API_KEY=somestring for test
        AppConfig.shared.setOpenAIKey(key: "testkey")
        AppConfig.shared.setOpenaiBaseUrl(url: "testurl")
        let expectation = XCTestExpectation(description: "Completion handler should be called")
        let doneExpectection = XCTestExpectation(description: "DONE handler should be called")
        let openAIStreamService = OpenAIStreamService(completion: { response, error in
            
            if(response == "some complition") {
                expectation.fulfill()
            }
            
            if(response == "[DONE]") {
                doneExpectection.fulfill()
            }
            
        })

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration, delegate: openAIStreamService, delegateQueue: nil)
        openAIStreamService.setNetworkService(urlSession: urlSession)

        openAIStreamService.query(conversation: testConversation, timeLogger: timeLogger)
        wait(for: [expectation, doneExpectection], timeout: 5)
    }


    func testRateLimit() {
        var testConversation: [Message] = []
        testConversation.append(Message(role: "user", content: "Hello"))

        let responseString = "data:\n[DONE]"
        let data = responseString.data(using: .utf8)


        MockURLProtocol.requestHandler = { request in
              guard let url = request.url else {
                  throw NSError(domain: "error", code: -1)
              }

              let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
              return (response, data)
        }


        // put API_KEY=somestring for test
        AppConfig.shared.setOpenAIKey(key: "testkey")
        AppConfig.shared.setOpenaiBaseUrl(url: "testurl")
        let expectation = XCTestExpectation(description: "Completion handler should be called")
        let service = OpenAIStreamService(completion: { response, error in
            expectation.fulfill()
            XCTAssertNil(response, "Response should not be nil")
            XCTAssertNotNil(error, "Error should be nil")

            if let err = error as? NSError {
                XCTAssertEqual(err.code, -3)
                XCTAssertEqual(err.domain, "Rate limited")
            } else {
                XCTFail("should be NSError type")
            }

            XCTAssertTrue(true)
        })


        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration, delegate: openAIStreamService, delegateQueue: nil)
        service.setNetworkService(urlSession: urlSession)

        OpenAIStreamService.QueryLimitPerMinute = 0;
        OpenAIStreamService.queryTimes.append(Int64(NSDate().timeIntervalSince1970 * 1000))

        service.query(conversation: testConversation, timeLogger: timeLogger)
        wait(for: [expectation], timeout: 5)
    }
    
    func testRateLimitFlag() {
        var testConversation: [Message] = []
        testConversation.append(contentsOf: OpenAIStreamService.setConversationContext())
        testConversation.append(Message(role: "user", content: "Hello"))
        // print(testConversation)

        let expectation = XCTestExpectation(description: "Completion handler should be called")

        let responseString = """
data:
[DONE]
"""
        let data = responseString.data(using: .utf8)


        MockURLProtocol.requestHandler = { request in
              guard let url = request.url else {
                  throw NSError(domain: "error", code: -1)
              }

              let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
              return (response, data)
        }

        // put API_KEY=somestring for test
        AppConfig.shared.setOpenAIKey(key: "testkey")
        AppConfig.shared.setOpenaiBaseUrl(url: "testurl")
        let openAIStreamService = OpenAIStreamService(completion: { response, error in
            expectation.fulfill()
            XCTAssertNotNil(response, "Response should not be nil")
            XCTAssertNil(error, "Error should be nil")
            // Check if both context messages exist in the conversation
            let hasContextMessages = testConversation.contains { message in
                message.role == "system"
            }
            XCTAssertTrue(hasContextMessages, "Context messages should be in the conversation")
        })

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration, delegate: openAIStreamService, delegateQueue: nil)
        openAIStreamService.setNetworkService(urlSession: urlSession)

        openAIStreamService.query(conversation: testConversation, rateLimit: false, timeLogger: timeLogger)
        wait(for: [expectation], timeout: 5)
    }


    func testConstructor() {
        let openAIStreamService = OpenAIStreamService { response, error in }

        XCTAssertNotNil(openAIStreamService, "service should not be nil")
        XCTAssertTrue(openAIStreamService.getTemperature() == 0.7, "should have default value")
    }

    func testSetTemperature() {
        let openAIStreamService = OpenAIStreamService(completion: { response, error in

        })
//
        openAIStreamService.setTemperature(0.1)
        XCTAssertTrue(openAIStreamService.getTemperature() == 0.1)
        openAIStreamService.setTemperature(0.9)
        XCTAssertTrue(openAIStreamService.getTemperature() == 0.9)
        openAIStreamService.setTemperature(1.0)
        XCTAssertTrue(openAIStreamService.getTemperature() == 1.0)
        openAIStreamService.setTemperature(0.0)
        XCTAssertTrue(openAIStreamService.getTemperature() == 0.0)
        openAIStreamService.setTemperature(-0.1)
        XCTAssertTrue(openAIStreamService.getTemperature() == 0.0)
        openAIStreamService.setTemperature(1.1)
        XCTAssertTrue(openAIStreamService.getTemperature() == 0.0)
    }
}

final class OpenAIUtilsTests: XCTestCase {
    func testCalcConversationContext() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "assistant", content: "Welcome to the platform!"),
            Voice_AI.Message(role: "user", content: "Your order has been confirmed."),
            Voice_AI.Message(role: "assistant", content: "Please adhere to the community guidelines."),
        ];
        
        let count = Voice_AI.OpenAIUtils.calcConversationContext(conversation)
        
        XCTAssertEqual(count, 96, "conversation context is not equal")
    }
    
    func testShouldSaveLastUserMessage() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "assistant", content: "Welcome to the platform!"),
            Voice_AI.Message(role: "user", content: "Your order has been confirmed."),
            Voice_AI.Message(role: "assistant", content: "Please adhere to the community guidelines."),
        ];
        
        let limitedConversation = Voice_AI.OpenAIUtils.limitConversationContext(conversation, charactersCount: 42)
        
        XCTAssertEqual(limitedConversation.count, 2, "contain is not equal to 2")
    }
    
    func testShouldAttachPartOfAMessage() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "user", content: "How many days are there in a year?"),
            Voice_AI.Message(role: "assistant", content: "A standard calendar year has 365 days. However, every four years, a leap year occurs, adding an extra day, making it 366 days in that particular year. "),
            Voice_AI.Message(role: "user", content: "How many weeks are there in a year?"),
        ];
        
        let limitedConversation = Voice_AI.OpenAIUtils.limitConversationContext(conversation, charactersCount: 52)
        
        XCTAssertEqual(limitedConversation.count, 3, "conversation should contain 3 messages")
        XCTAssertEqual(limitedConversation[0].content, "How many days are there in a year?")
        XCTAssertEqual(limitedConversation[1].content, "A standard calendar year has 365 days", "should get the first sentence")
        XCTAssertEqual(limitedConversation[2].content, "How many weeks are there in a year?")
    }
    
    func testShouldReturnAllMessages() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "assistant", content: "Welcome to the platform!"),
            Voice_AI.Message(role: "user", content: "Your order has been confirmed."),
            Voice_AI.Message(role: "assistant", content: "Please adhere to the community guidelines."),
        ];
        
        let limitedConversation = Voice_AI.OpenAIUtils.limitConversationContext(conversation, charactersCount: 100)
        
        XCTAssertEqual(limitedConversation.count, 3, "conversation should contain all messages")
        XCTAssertEqual(limitedConversation[0].content, "Welcome to the platform!")
        XCTAssertEqual(limitedConversation[1].content, "Your order has been confirmed.")
        XCTAssertEqual(limitedConversation[2].content, "Please adhere to the community guidelines.")
    }
    
    func testShouldFilterEmptyConversation() throws {
        let emptyConversation: [Voice_AI.Message] = [];
        
        let limitedEmpty = Voice_AI.OpenAIUtils.limitConversationContext(emptyConversation, charactersCount: 100)
        
        XCTAssertEqual(limitedEmpty.count, 0, "conversation should contain all messages")
    }
    
    func testShouldFilterEmptyMessages() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "assistant", content: ""),
            Voice_AI.Message(role: "assistant", content: "Please adhere to the community guidelines."),
            Voice_AI.Message(role: "assistant", content: ""),
            Voice_AI.Message(role: "assistant", content: nil),
        ];
        
        let cleanConversation = Voice_AI.OpenAIUtils.limitConversationContext(conversation, charactersCount: 100)
        
        XCTAssertEqual(cleanConversation.count, 1)
        XCTAssertEqual(cleanConversation[0].content, "Please adhere to the community guidelines.")
    }
    
    func shouldPreserveOrderOfMessages() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "assistant", content: "one"),
            Voice_AI.Message(role: "assistant", content: "two"),
            Voice_AI.Message(role: "assistant", content: "three"),
        ];
        
        let limitedc = Voice_AI.OpenAIUtils.limitConversationContext(conversation, charactersCount: 100)
        
        XCTAssertEqual(limitedc[0].content, "one")
        XCTAssertEqual(limitedc[1].content, "two")
        XCTAssertEqual(limitedc[3].content, "three")
    }
    
    func testShouldDeleteSystemMessages() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "system", content: "__instruction__"),
            Voice_AI.Message(role: "assistant", content: "There are 365 days in a standard calendar year."),
        ];
        
        let cleanConversation = Voice_AI.OpenAIUtils.limitConversationContext(conversation, charactersCount: 5)
        
        XCTAssertEqual(cleanConversation[0].role, "assistant")
        XCTAssertEqual(cleanConversation[0].content, "There are 365 days in a standard calendar year")
    }
    
}
class OpenAIStreamServiceTests: XCTestCase {
}

