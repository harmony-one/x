import XCTest
@testable import Voice_AI

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

            XCTAssertEqual(usage.prompt_tokens, 10, "Prompt tokens should be 10")
            XCTAssertEqual(usage.completion_tokens, 20, "Completion tokens should be 20")
            XCTAssertEqual(usage.total_tokens, 30, "Total tokens should be 30")
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
