import Foundation
import XCTest
@testable import Voice_AI

class TriviaManagerTests: XCTestCase {
    
    func testShouldReturnRandomTriviaTopic() {
        let topic = TriviaManager.getRandomTriviaTopic()
        XCTAssertNotNil(topic)
        XCTAssertTrue(TriviaManager.triviaTopics.contains(topic!))
    }
}
