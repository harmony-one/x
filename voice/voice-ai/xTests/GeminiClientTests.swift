import XCTest

class GeminiClientTests: XCTestCase {
    
    let clientConfig: GeminiClientConfig = GeminiClientConfig(
        apiKey: AppConfig.shared.getGeminiApiKey() ?? "",
        customInstruction: ""
    )
    
    func testApiKey() {
        XCTAssertNotEqual(self.clientConfig.apiKey, "", "clientConfig should contain GEMINI_API_KEY")
    }
    
    func testCreateInstance() {
        let client = GeminiClient(config: self.clientConfig)
        
        XCTAssertNotNil(client, "should create an instance")
    }
    
    func testStartChat() {
        let client = GeminiClient(config: self.clientConfig)
        let chat = client.startChat()
        
        XCTAssertNotNil(chat, "should create a chat")
    }
    
    func testSendMessage() {
        let client = GeminiClient(config: self.clientConfig)
        
        let expectation = XCTestExpectation(description: "Completion handler should be called")
        
        do {
            try client.sendMessage(message: "Summarize the history of Bitcoin") { result in
                expectation.fulfill()
                switch(result) {
                case let .success(complition):
                    XCTAssertTrue(true, "should receive a response")
                case let .failure(error):
                    XCTAssertFalse(true, "should not throw an error")
                }
            }
        } catch {
            XCTAssertFalse(true, "should not throw an error")
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
}
