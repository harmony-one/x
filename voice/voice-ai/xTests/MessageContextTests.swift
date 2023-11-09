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

    func testQuery() {
        var testConversation: [Message] = []
        testConversation.append(contentsOf: OpenAIStreamService.setConversationContext())
        testConversation.append(Message(role: "user", content: "Hello"))
        // print(testConversation)
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


class MessageTests: XCTestCase {
    func testInitialization() {
        // Test initializing a Message instance
        let message = Message(role: "sender", content: "Hello, world")
        
        XCTAssertEqual(message.role, "sender")
        XCTAssertEqual(message.content, "Hello, world")
    }

    func testInitFromDecoder() {
        let jsonData = """
        {
            "role": "receiver",
            "content": "Hi there"
        }
        """.data(using: .utf8)

        if let jsonData = jsonData {
            do {
                let decoder = JSONDecoder()
                let message = try decoder.decode(Message.self, from: jsonData)

                XCTAssertEqual(message.role, "receiver")
                XCTAssertEqual(message.content, "Hi there")
            } catch {
                XCTFail("Failed to initialize Message from decoder: \(error)")
            }
        } else {
            XCTFail("Failed to create JSON data")
        }
    }
}
