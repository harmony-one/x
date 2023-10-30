//
//  SpeechRecognition.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 17/10/23.
//

import AVFoundation
import Speech

protocol SpeechRecognitionProtocol {
    func reset()
    func randomFacts()
    func isPaused() -> Bool
    func continueSpeech()
    func pause()
    func repeate()
    func speak()
    func stopSpeak()
}

class SpeechRecognition: NSObject, SpeechRecognitionProtocol {

    // MARK: - Properties
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var isAudioSessionSetup = false
    var audioSession: AVAudioSessionProtocol = AVAudioSessionWrapper()
    let textToSpeechConverter = TextToSpeechConverter()
    static let shared = SpeechRecognition()
    let vibrationManager = VibrationManager()
    
    private var speechDelimitingPunctuations = [Character("."), Character("?"), Character("!"), Character(","), Character("-")]
    
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
        checkPermissionsAndSetupAudio()
        self.textToSpeechConverter.convertTextToSpeech(text: greatingText)
        
    }
    
    private func checkPermissionsAndSetupAudio() {
        Permission().setup()
        textToSpeechConverter.synthesizer.delegate = self
        setupAudioSession()
        setupAudioEngine()
    }
    
    // MARK: - Audio Session Management
    private func setupAudioSession() {
        guard !isAudioSessionSetup else { return }
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            isAudioSessionSetup = true
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
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
        cleanupRecognition()
        
        let inputNode = audioEngine.inputNode
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        handleRecognition(inputNode: inputNode)
    }
    
    private func handleRecognition(inputNode: AVAudioNode) {
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            guard let result = result else {
                self.handleRecognitionError(error)
                return
            }
            
            let message = result.bestTranscription.formattedString
            self.currentRecognitionMessage = message
            
            if result.isFinal {
                self.handleFinalRecognition(inputNode: inputNode, message: message)
            }
        }
        
        installTapAndStartEngine(inputNode: inputNode)
    }
    
    private func handleRecognitionError(_ error: Error?) {
        if let error = error {
            print("Speech recognition error: \(error)")

            let nsError = error as NSError
            if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 1110 {
                print("No speech was detected. Please speak again.")
                // Notify the user in a suitable manner, possibly with UI updates or a popup.
            }
            
            // General cleanup process
            let inputNode = audioEngine.inputNode
            inputNode.removeTap(onBus: 0)
            recognitionRequest = nil
            recognitionTask = nil
            currentRecognitionMessage = nil
            stopListening()
        }
    }
    
    private func handleFinalRecognition(inputNode: AVAudioNode, message: String) {
        inputNode.removeTap(onBus: 0)
        recognitionRequest = nil
        recognitionTask = nil
        if !message.isEmpty {
            print("Message:", message)
            handleEndOfSentence(message)
        }
        currentRecognitionMessage = nil
    }
    
    private func installTapAndStartEngine(inputNode: AVAudioNode) {
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        do {
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }
    
    func makeQuery(_ text: String) {
        var buf = [String]()
        func flushBuf() {
            let response = buf.joined()
            self.textToSpeechConverter.convertTextToSpeech(text: response)
            print("Stopped capturing")
            if self.textToSpeechConverter.synthesizer.delegate == nil {
                self.textToSpeechConverter.synthesizer.delegate = self
            }
            self.addObject(response)
            buf.removeAll()
        }
        let service = OpenAIStreamService { res, err in
            guard err == nil else {
                print("ASR: OpenAI error: \(err!)")
                //                self.textToSpeechConverter.convertTextToSpeech(text: "An issue is currently preventing the action. Please try again after some time.")
                return
            }
            guard let res = res else {
    //                print("ASR: OpenAI Response completed. Flushing buffer")
    //                flushBuf()
                return
            }
            print("ASR: OpenAI Response received: \(res)")
            
            buf.append(res)
            guard res.last != nil else {
                return
            }
            
            if self.speechDelimitingPunctuations.contains(res.last!) {
                flushBuf()
                return
            }
        }
        service.query(prompt: text)
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
        if (self.conversation.count == 0) {
            self.conversation.append(openAI.setConversationContext())
        }
        self.conversation.append(Message(role: "user", content: recognizedText))
        print(self.conversation)
        openAI.sendToOpenAI(conversation: conversation) { [self] aiResponse, error in
            self.audioPlayer.stopSound()
            VibrationManager.stopVibration()
            guard let aiResponse = aiResponse else {
                print("An issue is currently preventing the action. Please try again after some time.")
                self.isRequestingOpenAI = false;
                isRandomFacts = true
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
    
    func reset() {
        print("reset -- method called")
        stopGPT()
        textToSpeechConverter.stopSpeech()
        cleanupForNewSession()
    }
    
    private func stopGPT() {
        isRandomFacts = true
        // openAI.cancelOpenAICall()
        audioPlayer.stopSound()
        VibrationManager.stopVibration()
    }
    
    private func cleanupForNewSession() {
        aiResponseArray.removeAll()
        conversation.removeAll()
        stopListening()
        cleanupRecognition()
        isAudioSessionSetup = false
        textToSpeechConverter.synthesizer.delegate = nil
    }
    
    private func cleanupRecognition() {
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
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
            stopGPT()
            textToSpeechConverter.stopSpeech()
            handleEndOfSentence("Give me one random fact")
        }
    }
    
    func speak() {
        stopGPT()
        textToSpeechConverter.stopSpeech()
        // Check if recognition is in progress
        guard !audioEngine.isRunning && recognitionTask?.state != .running else {
            print("Recognition is already in progress.")
            return
        }
        cleanupRecognition()
        audioEngine.inputNode.removeTap(onBus: 0)
        isAudioSessionSetup = false
        self.startSpeechRecognition()
    }
    
    func stopSpeak() {
        if audioEngine.isRunning {
            recognitionTask?.finish()
        }
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
    
    private func stopListening() {
        cleanupRecognition()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        textToSpeechConverter.stopSpeech()
        isAudioSessionSetup = false
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
