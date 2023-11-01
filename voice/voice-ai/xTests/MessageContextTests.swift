//
//  OpenAIService.swift
//  Voice AITests
//
//  Created by Francisco Egloff on 31/10/23.
//

import XCTest
@testable import Voice_AI

class OpenAIServiceTests: XCTestCase {

    var openAIStreamService: OpenAIStreamService!

//    override func setUp() {
//        super.setUp()
//        openAIService = OpenAIService()
//    }
//
//    override func tearDown() {
//        openAIService = nil
//        super.tearDown()
//    }
    
    func testQuery() {
        var testConversation: [Message] = []
        testConversation.append(OpenAIStreamService.setConversationContext())
        testConversation.append(Message(role: "user", content: "Hello"))

        let mockNetworkService = MockNetworkService()
        let openAIStreamService = OpenAIStreamService(networkService: mockNetworkService, completion: { response, error in
            XCTAssertNotNil(response, "Response should not be nil")
            XCTAssertNil(error, "Error should be nil")
            // Check if both context messages exist in the conversation
            let hasContextMessages = testConversation.contains { message in
                return message.role == "system"
            }
            XCTAssertTrue(hasContextMessages, "Context messages should be in the conversation")
        })

        openAIStreamService.query(conversation: testConversation)
        
    }

    
}


//    func testSendToOpenAI() {
//        var testConversation: [Message] = []
//        testConversation.append(openAIService.setConversationContext())
//        testConversation.append(Message(role: "user", content: "Hello"))
//
//       let expectation = XCTestExpectation(description: "Send to OpenAI expectation")
//
//        openAIService.sendToOpenAI(conversation: testConversation) { response, error in
//            XCTAssertNotNil(response, "Response should not be nil")
//            XCTAssertNil(error, "Error should be nil")
//
//            // Check if both context messages exist in the conversation
//            let hasContextMessages = testConversation.contains { message in
//                return message.role == "system"
//            }
//            XCTAssertTrue(hasContextMessages, "Context messages should be in the conversation")
//
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 15) // Adjust the timeout as needed
//    }
