import XCTest

class SpeechSynthesisTests: XCTestCase {
    
    var speechSynthesisService: SpeechSynthesisService!

    override func setUp() {
        super.setUp()
        // Initialize your speech synthesis service here
        speechSynthesisService = SpeechSynthesisService()
    }

    func testResponseContainsSam() {
        let inputString = "What is your name?"
        let expectation = XCTestExpectation(description: "Synthesis completion")

        // Assume the service has a method `synthesizeResponse` which takes the input string and a completion handler
        speechSynthesisService.synthesizeResponse(from: inputString) { response in
            // Assert that the response contains the word "Sam"
            XCTAssertTrue(response.contains("Sam"), "The response does not contain the word 'Sam'")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    // Add other necessary tests and tear down methods if required
}
