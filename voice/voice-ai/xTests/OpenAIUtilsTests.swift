import XCTest
@testable import Voice_AI

final class OpenAIUtilsTests: XCTestCase {
    func testCalcConversationContext() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "assistant", content: "Welcome to the platform!"),
            Voice_AI.Message(role: "user", content: "Your order has been confirmed."),
            Voice_AI.Message(role: "assistant", content: "Please adhere to the community guidelines.")
        ]

        let count = Voice_AI.OpenAIUtils.calcConversationContext(conversation)

        XCTAssertEqual(count, 96, "conversation context is not equal")
    }

    func testShouldReturnAMessage() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "assistant", content: "Welcome to the platform!"),
            Voice_AI.Message(role: "user", content: "Your order has been confirmed."),
            Voice_AI.Message(role: "assistant", content: "Please adhere to the community guidelines.")
        ]

        let limitedConversation = Voice_AI.OpenAIUtils.limitConversationContext(conversation, charactersCount: 42)

        XCTAssertEqual(limitedConversation.count, 1, "contain is not equal to 1")
    }

    func testShouldAttachPartOfAMessage() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "assistant", content: "Welcome to the platform!"),
            Voice_AI.Message(role: "user", content: "Your order has been confirmed."),
            Voice_AI.Message(role: "assistant", content: "Please adhere to the community guidelines.")
        ]

        let limitedConversation = Voice_AI.OpenAIUtils.limitConversationContext(conversation, charactersCount: 52)

        XCTAssertEqual(limitedConversation.count, 2, "conversation should contain 2 messages")
        XCTAssertEqual(limitedConversation[0].content, "confirmed.")
        XCTAssertEqual(limitedConversation[1].content, "Please adhere to the community guidelines.")
    }

    func testShouldReturnAllMessages() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "assistant", content: "Welcome to the platform!"),
            Voice_AI.Message(role: "user", content: "Your order has been confirmed."),
            Voice_AI.Message(role: "assistant", content: "Please adhere to the community guidelines.")
        ]

        let limitedConversation = Voice_AI.OpenAIUtils.limitConversationContext(conversation, charactersCount: 100)

        XCTAssertEqual(limitedConversation.count, 3, "conversation should contain all messages")
        XCTAssertEqual(limitedConversation[0].content, "Welcome to the platform!")
        XCTAssertEqual(limitedConversation[1].content, "Your order has been confirmed.")
        XCTAssertEqual(limitedConversation[2].content, "Please adhere to the community guidelines.")
    }

    func testShouldFilterEmptyConversation() throws {
        let emptyConversation: [Voice_AI.Message] = []

        let limitedEmpty = Voice_AI.OpenAIUtils.limitConversationContext(emptyConversation, charactersCount: 100)

        XCTAssertEqual(limitedEmpty.count, 0, "conversation should contain all messages")
    }

    func testShouldFilterEmptyMessages() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "assistant", content: ""),
            Voice_AI.Message(role: "assistant", content: "Please adhere to the community guidelines."),
            Voice_AI.Message(role: "assistant", content: ""),
            Voice_AI.Message(role: "assistant", content: nil)
        ]

        let cleanConversation = Voice_AI.OpenAIUtils.limitConversationContext(conversation, charactersCount: 100)

        XCTAssertEqual(cleanConversation.count, 1)
        XCTAssertEqual(cleanConversation[0].content, "Please adhere to the community guidelines.")
    }

    func shouldPreserveOrderOfMessages() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "assistant", content: "one"),
            Voice_AI.Message(role: "assistant", content: "two"),
            Voice_AI.Message(role: "assistant", content: "three")
        ]

        let limitedc = Voice_AI.OpenAIUtils.limitConversationContext(conversation, charactersCount: 100)

        XCTAssertEqual(limitedc[0].content, "one")
        XCTAssertEqual(limitedc[1].content, "two")
        XCTAssertEqual(limitedc[3].content, "three")
    }

}
