import XCTest
@testable import Voice_AI

class TextToSpeechConverterTests: XCTestCase {
    var textToSpeechConverter: TextToSpeechConverter!

    override func setUp() {
        super.setUp()
        textToSpeechConverter = TextToSpeechConverter()
    }

    override func tearDown() {
        textToSpeechConverter = nil
        super.tearDown()
    }

    func testIsSpeakingInitiallyFalse() {
        XCTAssertFalse(textToSpeechConverter.isSpeaking, "isSpeaking should initially be false")
    }
    
    func testConvertTextToSpeech() {
        let text = "Hello, world!"
        let pitch: Float = 0.8
        let volume: Float = 0.5

        let expectation = XCTestExpectation(description: "Speech synthesis")

        // Call the method you want to test
        textToSpeechConverter.convertTextToSpeech(text: text, pitch: pitch, volume: volume)

        // Set up a timer to periodically check the condition
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.textToSpeechConverter.synthesizer.isSpeaking {
                expectation.fulfill()
            }
        }

        // Wait for the expectation to be fulfilled with a timeout
        wait(for: [expectation], timeout: 10.0) // Adjust the timeout as needed

        // Invalidate the timer
        timer.invalidate()

        // Now, check if the synthesizer is speaking
        XCTAssertTrue(textToSpeechConverter.synthesizer.isSpeaking)
    }
    
    func testConvertTextToSpeechSupportedLanguage() {
        let mockSynthesizer = MockAVSpeechSynthesizer()
        textToSpeechConverter.synthesizer = mockSynthesizer
        
        let text = "Hello, world!"
        let supportedLanguage = "fr-FR"
        
        // Call the convertTextToSpeech method with the supported language
        textToSpeechConverter.convertTextToSpeech(text: text, language: supportedLanguage)
        
        // Check if the utterance's voice is set correctly to the supported language
        XCTAssertEqual(mockSynthesizer.selectedVoiceLanguage, supportedLanguage)
        
        // Verify that isDefaultVoiceUsed is false
        XCTAssertFalse(textToSpeechConverter.isDefaultVoiceUsed)
        }
    
    func testConvertTextToSpeechUnsupportedLanguage() {
        let textToSpeechConverter = TextToSpeechConverter()

        // Set a preferred language that you know does not have an available voice
        let unsupportedLanguage = "xx-XX"

        // Call the method to convert text to speech
        textToSpeechConverter.convertTextToSpeech(text: "Test speech", pitch: 1.0, volume: 1.0, language: unsupportedLanguage)

        let isDefaultVoiceUsed = textToSpeechConverter.isDefaultVoiceUsed
        XCTAssertTrue(isDefaultVoiceUsed)
    }

    func testStopSpeech() {
        let mockSynthesizer = MockAVSpeechSynthesizer()
        let textToSpeechConverter = TextToSpeechConverter()
        textToSpeechConverter.synthesizer = mockSynthesizer

        // Stub the isSpeaking property to return true
        mockSynthesizer.isSpeakingStub = true

        // Call the method to stop speech
        textToSpeechConverter.stopSpeech()

        // Now, check if the stopSpeaking operation was correctly called
        XCTAssertFalse(mockSynthesizer.isSpeaking)
    }


    func testPauseSpeech() {
        let mockSynthesizer = MockAVSpeechSynthesizer()
        let textToSpeechConverter = TextToSpeechConverter()
        textToSpeechConverter.synthesizer = mockSynthesizer

        // Stub the isSpeaking property to return true
        mockSynthesizer.isSpeakingStub = true

        // Call the method to pause speech
        textToSpeechConverter.pauseSpeech()

        // Now, check if the pause operation was correctly called
        XCTAssertTrue(mockSynthesizer.isPaused)
    }
    
    func testPauseSpeechNotSpeaking() {
        let mockSynthesizer = MockAVSpeechSynthesizer()
        let textToSpeechConverter = TextToSpeechConverter()
        textToSpeechConverter.synthesizer = mockSynthesizer

        // Stub the isSpeaking property to return false (speech is not speaking)
        mockSynthesizer.isSpeakingStub = false

        // Call the method to pause speech when speech is not speaking
        textToSpeechConverter.pauseSpeech()

        // Now, check that the synthesizer's state remains unchanged (isPaused is false)
        XCTAssertFalse(mockSynthesizer.isPaused)
    }

    
    func testContinueSpeech() {
        let mockSynthesizer = MockAVSpeechSynthesizer()
        let textToSpeechConverter = TextToSpeechConverter()
        textToSpeechConverter.synthesizer = mockSynthesizer

        // Stub the isSpeaking property to return true
        mockSynthesizer.isSpeakingStub = true

        // Stub the isPaused property to return true initially (speech is paused)
        mockSynthesizer.isPausedStub = true

        // Call the method to continue speech
        textToSpeechConverter.continueSpeech()

        // Now, check if the continueSpeaking operation was correctly called
        XCTAssertFalse(mockSynthesizer.isPaused)
    }
}
