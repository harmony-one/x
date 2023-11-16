class MockPermission: Permission {
        override func requestMicrophoneAccess(
            forceOldVersionForTesting: Bool = false,
            completion: @escaping (Bool) -> Void) {
            // Simulate microphone access being denied
            completion(false)
        }
    }
