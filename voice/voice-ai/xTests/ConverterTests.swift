import XCTest
@testable import Voice_AI
import AVFoundation

class TextToSpeechConverterTests: XCTestCase {
    var textToSpeechConverter: TextToSpeechConverter!
    private var timeLogger: TimeLogger?
    
    override func setUp() {
        super.setUp()
        textToSpeechConverter = TextToSpeechConverter()
        
    }
    
    override func tearDown() {
        textToSpeechConverter = nil
        super.tearDown()
    }
    
    func testSpeechSynthesizerDidStart() {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance()
        textToSpeechConverter.speechSynthesizer(synthesizer, didStart: utterance)
        XCTAssertNotEqual(textToSpeechConverter.timeLogger?.getTTSFirst(), 0)
    }
    
    func testSpeechSynthesizerDidFinish() {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance()
        textToSpeechConverter.speechSynthesizer(synthesizer, didFinish: utterance)
        XCTAssertNotEqual(textToSpeechConverter.timeLogger?.getTTSFirst(), 0)
        XCTAssertNotEqual(textToSpeechConverter.timeLogger?.getTTSEnd(), 0)
    }
    
    func testSpeechSynthesizerDidCancel() {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance()
        textToSpeechConverter.speechSynthesizer(synthesizer, didCancel: utterance)
        XCTAssertNotEqual(textToSpeechConverter.timeLogger?.getTTSFirst(), 0)
        XCTAssertNotEqual(textToSpeechConverter.timeLogger?.getTTSEnd(), 0)
    }
    
    func testIsSpeakingInitiallyFalse() {
        XCTAssertFalse(textToSpeechConverter.isSpeaking, "isSpeaking should initially be false")
    }
    
    func testConvertTextToSpeech() {
        let text = "Hello, world!"
        let pitch: Float = 0.8
        let volume: Float = 0.5
        
        let expectation = XCTestExpectation(description: "Speech synthesis")
        
        textToSpeechConverter.convertTextToSpeech(text: text, pitch: pitch, volume: volume, timeLogger: timeLogger)
        
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
        
        textToSpeechConverter.convertTextToSpeech(text: text, language: supportedLanguage, timeLogger: timeLogger)
        
        XCTAssertEqual(mockSynthesizer.selectedVoiceLanguage, supportedLanguage)
        XCTAssertFalse(textToSpeechConverter.isDefaultVoiceUsed)
    }
    
    func testConvertTextToSpeechUnsupportedLanguage() {
        let textToSpeechConverter = TextToSpeechConverter()
        let unsupportedLanguage = "xx-XX"
        
        textToSpeechConverter.convertTextToSpeech(text: "Test speech", pitch: 1.0, volume: 1.0, language: unsupportedLanguage, timeLogger: timeLogger)
        
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
    
    func testisPremiumOrEnhancedVoice() {
        XCTAssertTrue(textToSpeechConverter.isPremiumOrEnhancedVoice(voiceIdentifier: "premiumString"))
    }
    
    func testCheckAndPromptForPremiumVoice() {
        let expectation = XCTestExpectation(description: "showDownloadVoicePromptCalled should be set to true")
        XCTAssertFalse(textToSpeechConverter.showDownloadVoicePromptCalled)
        textToSpeechConverter.checkAndPromptForPremiumVoice(voiceIdentifier: "com.apple.ttsbundle.Samantha-compact")
        DispatchQueue.global().asyncAfter(deadline: .now() + 11.0) {
            XCTAssertTrue(self.textToSpeechConverter.showDownloadVoicePromptCalled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 12.0)
    }
    
    func testShowDownloadVoicePrompt() {
       let expectation = XCTestExpectation(description: "showDownloadVoicePromptCalled should be set to true")
       XCTAssertFalse(textToSpeechConverter.showDownloadVoicePromptCalled)
       textToSpeechConverter.showDownloadVoicePrompt()
       DispatchQueue.global().asyncAfter(deadline: .now() + 11.0) {
           XCTAssertTrue(self.textToSpeechConverter.showDownloadVoicePromptCalled)
           expectation.fulfill()
       }
       wait(for: [expectation], timeout: 12.0)
   }
}
