//
//  SpeechRecognition.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 17/10/23.
//

import AVFoundation
import Speech

class SpeechRecognition: NSObject {
    
    // MARK: - Properties
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var isAudioSessionSetup = false
    private var silenceTimer: Timer?
    let audioSession = AVAudioSession.sharedInstance()
    let textToSpeechConverter = TextToSpeechConverter()
    

    // MARK: - Initialization and Setup
    
    func setup() {
        // Check and request necessary permissions
        Permission().setup()
        
        // Set up the synthesizer delegate
        textToSpeechConverter.synthesizer.delegate = self
          
        // Convert a default greeting text to speech
        textToSpeechConverter.convertTextToSpeech(text: "Hey!!")
    }
    
    // MARK: - Audio Session Management
    
    func setupAudioSession() {
        if !isAudioSessionSetup {
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                isAudioSessionSetup = true
            } catch {
                print("Error setting up audio session: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Speech Recognition
    
    func startSpeechRecognition() {
        setupAudioSession()

        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
         let inputNode = audioEngine.inputNode 
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!) { result, error in
            var isFinal = false
            var message = ""
            
            if let result = result {
                message = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
            
            self.silenceTimer?.invalidate()
            self.silenceTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
                if !message.isEmpty {
                    self.handleEndOfSentence(message)
                }
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Sentence Handling
    
    func handleEndOfSentence(_ recognizedText: String) {
        // Add your logic here for actions to be performed at the end of the user's sentence.
        // For example, you can handle UI updates or other necessary tasks.
        // ...
        
        recognitionTask?.finish()
        recognitionTask?.cancel()
        recognitionTask = nil
        
        recognitionRequest?.endAudio()
        audioEngine.stop()
        
        OpenAIService().sendToOpenAI(inputText: recognizedText) { aiResponse, error in
            guard let aiResponse = aiResponse else {
                self.textToSpeechConverter.convertTextToSpeech(text: "An issue is currently preventing the action. Please try again after some time.")
                return
            }
            self.setupAudioSession()
            self.textToSpeechConverter.convertTextToSpeech(text: aiResponse)
        }
    }
}

extension SpeechRecognition: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        startSpeechRecognition()
    }
}
 
