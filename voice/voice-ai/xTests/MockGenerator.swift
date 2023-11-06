//
//  MockGenerator.swift
//  Voice AI
//
//  Created by Rikako Hatoya on 11/5/23.
//

import UIKit
import CoreHaptics

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
