import CoreHaptics
import UIKit

class MockGenerator: UIImpactFeedbackGenerator {
    var impactOccurredCalled = false
    var prepareCalled = false

    override func impactOccurred() {
        impactOccurredCalled = true
    }

    override func prepare() {
        prepareCalled = true
    }
}
