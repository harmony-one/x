
import XCTest
@testable import Voice_AI

class ShareLinkTests: XCTestCase {
    
    func testShareLinkInitialization() {
        let title = "Check out Voice AI: Super-Intelligence app!"
        let urlString = "https://apps.apple.com/ca/app/voice-ai-super-intelligence/id6470936896"
        guard let url = URL(string: urlString) else {
            XCTFail("URL initialization failed.")
            return
        }

        let shareLink = ShareLink(title: title, url: url)

        XCTAssertEqual(shareLink.title, title, "ShareLink title did not match")
        XCTAssertEqual(shareLink.url, url, "ShareLink URL did not match")
    }

}
