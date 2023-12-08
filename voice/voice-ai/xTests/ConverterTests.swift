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

        textToSpeechConverter.convertTextToSpeech(text: text, pitch: pitch, volume: volume)

        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.textToSpeechConverter.synthesizer.isSpeaking {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
        timer.invalidate()

        XCTAssertTrue(textToSpeechConverter.synthesizer.isSpeaking)
    }
    
    func testConvertTextToSpeechSupportedLanguage() {
        let mockSynthesizer = MockAVSpeechSynthesizer()
        textToSpeechConverter.synthesizer = mockSynthesizer
        
        let text = "Hello, world!"
        let supportedLanguage = "fr-FR"

        textToSpeechConverter.convertTextToSpeech(text: text, language: supportedLanguage)
        
        XCTAssertEqual(mockSynthesizer.selectedVoiceLanguage, supportedLanguage)
        XCTAssertFalse(textToSpeechConverter.isDefaultVoiceUsed)
        }
    
    func testConvertTextToSpeechUnsupportedLanguage() {
        let textToSpeechConverter = TextToSpeechConverter()
        let unsupportedLanguage = "xx-XX"

        textToSpeechConverter.convertTextToSpeech(text: "Test speech", pitch: 1.0, volume: 1.0, language: unsupportedLanguage)

        XCTAssertTrue(textToSpeechConverter.isDefaultVoiceUsed)
    }

    func testStopSpeech() {
        let mockSynthesizer = MockAVSpeechSynthesizer()
        let textToSpeechConverter = TextToSpeechConverter()
        
        textToSpeechConverter.synthesizer = mockSynthesizer
        mockSynthesizer.isSpeakingStub = true
        textToSpeechConverter.stopSpeech()

        XCTAssertFalse(mockSynthesizer.isSpeaking)
    }


    func testPauseSpeech() {
        let mockSynthesizer = MockAVSpeechSynthesizer()
        let textToSpeechConverter = TextToSpeechConverter()
        
        textToSpeechConverter.synthesizer = mockSynthesizer
        mockSynthesizer.isSpeakingStub = true
        textToSpeechConverter.pauseSpeech()

        XCTAssertTrue(mockSynthesizer.isPaused)
    }
    
    func testPauseSpeechNotSpeaking() {
        let mockSynthesizer = MockAVSpeechSynthesizer()
        let textToSpeechConverter = TextToSpeechConverter()
        
        textToSpeechConverter.synthesizer = mockSynthesizer
        mockSynthesizer.isSpeakingStub = false
        textToSpeechConverter.pauseSpeech()

        XCTAssertFalse(mockSynthesizer.isPaused)
    }

    
    func testContinueSpeech() {
        let mockSynthesizer = MockAVSpeechSynthesizer()
        let textToSpeechConverter = TextToSpeechConverter()
        
        textToSpeechConverter.synthesizer = mockSynthesizer
        mockSynthesizer.isSpeakingStub = true
        mockSynthesizer.isPausedStub = true
        textToSpeechConverter.continueSpeech()

        XCTAssertFalse(mockSynthesizer.isPaused)
    }
}
