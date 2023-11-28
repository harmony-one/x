import SnapshotTesting
import XCTest
import SwiftUI



final class ProgressViewComponentTests: XCTestCase {
    @State var isShowing = true;
    
    func testIsShowing() throws {
        let sut0 = ProgressViewComponent(isShowing: $isShowing).frame(width: 600, height: 1200)
        assertSnapshot(matching: sut0, as: .image)
        
        isShowing = true;
        
        let sut1 = ProgressViewComponent(isShowing: $isShowing).frame(width: 600, height: 1200)
        assertSnapshot(matching: sut1, as: .image)
    }
}

