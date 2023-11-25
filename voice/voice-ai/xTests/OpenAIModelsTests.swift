import XCTest
@testable import Voice_AI

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


        XCTAssertEqual(response.usage?.promptTokens, 10)
        XCTAssertEqual(response.usage?.completionTokens, 50)
        XCTAssertEqual(response.usage?.totalTokens, 60)
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

class UsageTests: XCTestCase {

    func testDecodeUsageFromValidJSON() {
        let json = """
        {
            "prompt_tokens": 10,
            "completion_tokens": 20,
            "total_tokens": 30
        }
        """

        do {
            let data = json.data(using: .utf8)!
            let usage = try JSONDecoder().decode(Usage.self, from: data)

            XCTAssertEqual(usage.promptTokens, 10, "Prompt tokens should be 10")
            XCTAssertEqual(usage.completionTokens, 20, "Completion tokens should be 20")
            XCTAssertEqual(usage.totalTokens, 30, "Total tokens should be 30")
        } catch {
            XCTFail("Failed to decode Usage from valid JSON: \(error)")
        }
    }

    func testDecodeUsageFromInvalidJSON() {
        let json = """
        {
            "prompt_tokens": "invalid", // Invalid type for prompt_tokens
            "completion_tokens": 20,
            "total_tokens": 30
        }
        """

        do {
            let data = json.data(using: .utf8)!
            _ = try JSONDecoder().decode(Usage.self, from: data)
            XCTFail("Should have thrown an error for invalid JSON")
        } catch {
            // Expected error, test passed
        }
    }
}
class ChoicesTests: XCTestCase {
}


