import XCTest
@testable import Voice_AI

class RandomFactTests: XCTestCase {
    func testGetTitle() {

        let title = getTitle()

        // Check if the title is not empty
        XCTAssertFalse(title.isEmpty, "The title should not be empty")

        // Check if the title is one of the top articles
        XCTAssertTrue(topArticles.contains(title),
                      "The title should be one of the top articles")
    }
}
