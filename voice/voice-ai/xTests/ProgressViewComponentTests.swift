import SnapshotTesting
import XCTest
import SwiftUI
@testable import Voice_AI

class ProgressViewComponentTests: XCTestCase {
    var progressView: ProgressViewComponent!
    var isShowingDefault = false
    
    override func setUp() {
        super.setUp()
        progressView = ProgressViewComponent(isShowing: .constant(self.isShowingDefault))
    }
    
    func testIsShowingDefault() throws {
        XCTAssertTrue(progressView.isShowing)
    }
}
