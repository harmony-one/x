import XCTest

class RandomFactTests: XCTestCase {
    func testGetTitle() {

        let title = getTitle()

        // Check if the title is not empty
        XCTAssertFalse(title.isEmpty, "The title should not be empty")

        let topArticles = [
            "123Movies",
            "1917 (2019 film)",
            "Amazon (company)","Amazon River"
        ]

        // Check if the title is one of the top articles
        XCTAssertTrue(topArticles.contains(title),
                      "The title should be one of the top articles")
    }
}
