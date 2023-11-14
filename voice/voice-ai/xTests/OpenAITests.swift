@testable import Voice_AI
import XCTest

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
                message.role == "system"
            }
            XCTAssertTrue(hasContextMessages, "Context messages should be in the conversation")
        })

        openAIStreamService.query(conversation: testConversation)
    }
}

class OpenAIResponseTests: XCTestCase {

    func testInit() throws {
        // Given
        let json = """
        {
            "id": "123",
            "object": "response",
            "created": 1635790771,
            "model": "gpt-3.5-turbo",
            "choices": [
                {
                    "message": {
                        "role": "user",
                        "content": "Hi"
                    },
                    "finish_reason": "OK",
                    "index": 1

                },
            ],
            "usage": {
                "prompt_tokens": 10,
                "completion_tokens": 50,
                "total_tokens": 60
            }
        }
        """

        // When
        let jsonData = Data(json.utf8)
        let response = try JSONDecoder().decode(OpenAIResponse.self, from: jsonData)

        // Then
        XCTAssertEqual(response.id, "123")
        XCTAssertEqual(response.object, "response")
        XCTAssertEqual(response.created, 1635790771)
        XCTAssertEqual(response.model, "gpt-3.5-turbo")

        XCTAssertEqual(response.choices?.count, 1)
        XCTAssertEqual(response.choices?[0].message?.role, "user")
        XCTAssertEqual(response.choices?[0].message?.content, "Hi")

        XCTAssertNotNil(response.usage)
        XCTAssertEqual(response.usage?.prompt_tokens, 10)
        XCTAssertEqual(response.usage?.completion_tokens, 50)
        XCTAssertEqual(response.usage?.total_tokens, 60)
    }

    // Add more test cases as needed

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
