//
//  OpenAIService.swift
//  Voice AITests
//
//  Created by Francisco Egloff on 31/10/23.
//

import XCTest
@testable import Voice_AI

class OpenAIServiceTests: XCTestCase {

    var openAIService: OpenAIService!

    func testSendToOpenAI() {
        let testConversation: [Message] = []
        testConversation.append(contentsOf: openAIService.setConversationContext())
        
           let expectation = XCTestExpectation(description: "Send to OpenAI expectation")

           openAIService.sendToOpenAI(conversation: testConversation) { response, error in
               XCTAssertNotNil(response, "Response should not be nil")
               XCTAssertNil(error, "Error should be nil")
               expectation.fulfill()
           }

        wait(for: [expectation], timeout: 5) // Adjust the timeout as needed
    }
}
