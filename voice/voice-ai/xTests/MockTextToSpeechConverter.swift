//
//  MockTextToSpeechConverter.swift
//  Voice AITests
//
//  Created by Nagesh Kumar Mishra on 29/10/23.
//

import Foundation

protocol TextToSpeechConverterProtocol {
    func convertTextToSpeech(text: String)
    func stopSpeech()
    func pauseSpeech()
    func continueSpeech()
}

class MockTextToSpeechConverter: TextToSpeechConverterProtocol {
        var isConvertTextToSpeechCalled = false
        var isPauseSpeechCalled = false
        var isContinueSpeechCalled = false
        var isStopSpeechCalled = false
        
        func convertTextToSpeech(text: String) {
            isConvertTextToSpeechCalled = true
        }
        
        func pauseSpeech() {
            isPauseSpeechCalled = true
        }
        
        func continueSpeech() {
            isContinueSpeechCalled = true
        }
        
        func stopSpeech() {
            isStopSpeechCalled = true
        }
    }
