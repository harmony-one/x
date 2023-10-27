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
    let audioSession = AVAudioSession.sharedInstance()
    let textToSpeechConverter = TextToSpeechConverter()
    static let shared = SpeechRecognition()
    let vibrationManager = VibrationManager()
    // Create an instance of OpenAIService
    var openAI = OpenAIService()
    
    // Maximum size of the array
    let maxArraySize = 5
    
    // Array to store AI responses

    private var aiResponseArray: [String] = []
    private var conversation: [Message] = []
    private let greatingText = "Hey!"
    
    private let audioPlayer = AudioPlayer()
    private var isRandomFacts = true
    
    private var isRequestingOpenAI = false;
    private var _isPaused = false;
    
    // Current message being processed
    var currentRecognitionMessage: String?
        
    // MARK: - Initialization and Setup
    
    func setup() {
        // Check and request necessary permissions
        Permission().setup()
        
        // Set up the synthesizer delegate
        textToSpeechConverter.synthesizer.delegate = self
        
        // Convert a default greeting text to speech
        setupAudioEngine()
        textToSpeechConverter.convertTextToSpeech(text: greatingText)
    }
    
    // MARK: - Audio Session Management
    
    func setupAudioSession() {
        if !isAudioSessionSetup {
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                // try audioSession.setCategory(.playback)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                isAudioSessionSetup = true
            } catch {
                print("Error setting up audio session: \(error.localizedDescription)")
            }
        }
    }
    
    // Function to setup the audio engine
    func setupAudioEngine() {
        if !audioEngine.isRunning {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("Error setting up audio engine: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Speech Recognition
    
    func startSpeechRecognition() {
        print("startSpeechRecognition -- method called")
        
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
                        
            if  isFinal {
                print( "Speech recognition isFinal ")
                print( "Speech recognition \(message) ")
                
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                if !message.isEmpty {
                    self.handleEndOfSentence(message)
                }
            }
            
            if let error = error {
                print( "Speech recognition error: \(error)")
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
    
    // Call when user releases "Press to Speak" button
    func endSpeechRecognition() {
        if let message = self.currentRecognitionMessage, !message.isEmpty {
            self.handleEndOfSentence(message)
        }
        self.currentRecognitionMessage = nil
    }
    
    // MARK: - Sentence Handling
    
    func handleEndOfSentence(_ recognizedText: String) {
        // Add your logic here for actions to be performed at the end of the user's sentence.
        // For example, you can handle UI updates or other necessary tasks.
        // ...
        print("handleEndOfSentence -- method called")
        
        self.isRequestingOpenAI = true;
        self._isPaused = false;
        
        recognitionTask?.finish()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        audioEngine.stop()
        isRandomFacts = false
        self.audioPlayer.playSound()
        VibrationManager.startVibration()
        self.conversation.append(Message(role: "user", content: recognizedText))
        openAI.sendToOpenAI(conversation: conversation) { [self] aiResponse, error in
            self.audioPlayer.stopSound()
            VibrationManager.stopVibration()
            guard let aiResponse = aiResponse else {
                print("An issue is currently preventing the action. Please try again after some time.")
                self.isRequestingOpenAI = false;
                return
            }
            
            isRandomFacts = true
            self.setupAudioSession()
            self.stopListening()
            self.setupAudioEngine()
            if self.textToSpeechConverter.synthesizer.delegate == nil {
                self.textToSpeechConverter.synthesizer.delegate = self
            }
            
            self.isRequestingOpenAI = false;
        
            if(!self.isPaused()) {
                self.textToSpeechConverter.convertTextToSpeech(text: aiResponse)
            }
            self.conversation.append(Message(role: "assistant", content: aiResponse))
            self.addObject(aiResponse)
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
    
    func isPaused() -> Bool {
        return self._isPaused;
    }
    
    func pause() {
        print("pause -- method called")
        self._isPaused = true;
        
        if(self.isRequestingOpenAI) {
            self.audioPlayer.stopSound()
            VibrationManager.stopVibration()
        } else {
            self.textToSpeechConverter.pauseSpeech()
        }
    }
    
    func continueSpeech() {
        print("continueSpeech -- method called")
        self._isPaused = false;
        
        if(self.isRequestingOpenAI) {
            self.audioPlayer.playSound()
            VibrationManager.startVibration()
        } else if self.textToSpeechConverter.synthesizer.isSpeaking {
            self.textToSpeechConverter.continueSpeech()
        } else {
            self.repeate();
        }
    }
    
    func randomFacts() {
        print("randomFacts -- method called")
        if isRandomFacts {
            handleEndOfSentence("Give me one random fact")
        }
    }
    
    func reset() {
        // “Reset” means Theo abandons the current conversation for a new chat session with Sam.
        print("reset -- method called")
        isRandomFacts = true
        openAI.cancelOpenAICall()
        self.audioPlayer.stopSound()
        VibrationManager.stopVibration()
        textToSpeechConverter.stopSpeech()
        self.aiResponseArray.removeAll()
        self.conversation.removeAll()
        stopListening()
        recognitionTask?.finish()
        recognitionTask = nil
        recognitionRequest = nil
        isAudioSessionSetup = false
        textToSpeechConverter.synthesizer.delegate = nil // Remove the delegate to prevent any callback from the previous conversation
    }
    
    func speak() {
        stopListening()
        self.textToSpeechConverter.pauseSpeech()
        // self.reset() commented to allow conversation history
        self.startSpeechRecognition()
    }
    
    func stopSpeak() {
        recognitionTask?.finish()
    }
    
    func cancelSpeak() {
        stopListening()
    }
    
    func repeate() {
        
        // "Repeat" allows the user to hear the app saying from 10 seconds ago.
        print("repeat -- method called")
        if let lastResponse = aiResponseArray.last {
            stopListening()
            self.textToSpeechConverter.convertTextToSpeech(text: lastResponse)
        } else {
            stopListening()
            let noPriorResponse = "There are no prior conversations to repeat."
            self.textToSpeechConverter.convertTextToSpeech(text: noPriorResponse)
        }
    }
    
    // Helper method to stop ongoing listening
    private func stopListening() {
        recognitionTask?.cancel()
        recognitionTask = nil
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        textToSpeechConverter.stopSpeech()
        isAudioSessionSetup = false // Reset to false when the audio session is stopped
    }
}

// Extension for AVSpeechSynthesizerDelegate

extension SpeechRecognition: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("speechSynthesizer -didFinish - method called")
        
        DispatchQueue.main.async {
            self.setupAudioSession()
        }
    }
}
