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
    static let shared = SpeechRecognition()
    
    // Maximum size of the array
    let maxArraySize = 5
    
    // Array to store AI responses
    private var aiResponseArray: [String] = []
    
    private var isResetCalled = false
        
    // MARK: - Initialization and Setup
    
    func setup() {
        // Check and request necessary permissions
        Permission().setup()
        
        // Set up the synthesizer delegate
        textToSpeechConverter.synthesizer.delegate = self
          
        // Convert a default greeting text to speech
        textToSpeechConverter.convertTextToSpeech(text: "Hey!! With its virtual research platform")
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
    
    // Method to add a new response to the array, managing the size
    func addObject(_ newObject: String) {
        if aiResponseArray.count < maxArraySize {
            aiResponseArray.append(newObject)
        } else {
            aiResponseArray.removeFirst()
            aiResponseArray.append(newObject)
        }
    }
    
    func pause() {
        // “Pause” means holding off Sam’s speaking or listening until Theo presses the button again.
        self.textToSpeechConverter.pauseSpeech()
    }
    
    func continueSpeech() {
        self.textToSpeechConverter.continueSpeech()
    }
    
    func cut() {
        //  ”Cut” means to interrupt stop play audio rambling and stop any further response
        self.textToSpeechConverter.stopSpeech()
    }
    
    func reset() {
        // “Reset” means Theo abandons the current conversation for a new chat session with Sam.
        
        self.aiResponseArray.removeAll()
        self.textToSpeechConverter.stopSpeech()
        self.recognitionTask?.finish()
        self.recognitionTask?.cancel()
        self.recognitionTask = nil
        
        self.recognitionRequest?.endAudio()
        self.audioEngine.stop()
        //audioEngine.inputNode.removeTap(onBus: 0)
        
        self.isResetCalled = true
        
        if audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
        self.textToSpeechConverter.convertTextToSpeech(text: "Hey!!")
        
    }
    
    func speak() {
        // ”Speak” allows Theo to force Sam keep listening while holding down the button.
        
        self.textToSpeechConverter.stopSpeech()
        self.recognitionTask?.finish()
        self.recognitionTask?.cancel()
        self.recognitionTask = nil
        
        self.recognitionRequest?.endAudio()
        self.audioEngine.stop()
    
        self.setupAudioSession()
        self.startSpeechRecognition()
    }
    
    func repeate() {
        self.setupAudioSession()
        // “Repeat” allows Theo to hear Sam’s saying from 10 seconds ago.
        self.textToSpeechConverter.convertTextToSpeech(text: aiResponseArray.last ?? "There are no prior conversions to repeat.")
    }
}

extension SpeechRecognition: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.startSpeechRecognition()
    }
}
 
