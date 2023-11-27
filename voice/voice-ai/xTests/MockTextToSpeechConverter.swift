class MockTextToSpeechConverter: TextToSpeechConverter {
    var pauseSpeechCalled = false

    override func pauseSpeech() {
        pauseSpeechCalled = true
    }

    func reset() {
        pauseSpeechCalled = false
    }
}
