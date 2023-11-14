import XCTest
@testable import Voice_AI

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
    
    func testShouldNotDeleteSystemMessages() throws {
        let conversation: [Voice_AI.Message] = [
            Voice_AI.Message(role: "system", content: "__instruction__"),
            Voice_AI.Message(role: "assistant", content: "There are 365 days in a standard calendar year."),
        ];
        
        let cleanConversation = Voice_AI.OpenAIUtils.limitConversationContext(conversation, charactersCount: 5)
        
        XCTAssertEqual(cleanConversation[0].role, "system")
        XCTAssertEqual(cleanConversation[0].content, "__instruction__")
    }
    
}
