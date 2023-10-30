//
//  SpeechRecognition.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 17/10/23.
//

import AVFoundation
import Speech
import ChatGPTSwift

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

let conversationContext = ChatGPTSwift.Message(role: "system", content:"We are having a face-to-face voice conversation. NEVER apologize. NEVER say bye. NEVER end with questions. NEVER mention about your model cutoff. NEVER mention you are an AI. Adhere to these guidelines strictly. Keep responses 1 sentence unless the user wants to expand.")

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
    var openAIApi: ChatGPTAPI?
    var openAITask: SpeechRecognition?
    
    // Maximum size of the array
    let maxArraySize = 5
    
    // Array to store AI responses
    private var aiResponseArray: [String] = []
    private var conversation: [ChatGPTSwift.Message] = []
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
        
        let config = AppConfig()
        
        guard let openAI_APIKey = config.getAPIKey() else  {
            print("Not found openAI key")
            return
        }
        
        self.openAIApi = ChatGPTAPI(apiKey: openAI_APIKey)
        
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
            makeAIQuery(message)
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
    
    func makeAIQuery(_ text: String) {
        if (self.conversation.count == 0) {
            self.conversation.append(conversationContext)
        }
        
        self.openAIApi?.replaceHistoryList(with: self.conversation)
        
        self.conversation.append(ChatGPTSwift.Message(role: "user", content: text))
        
        Task {
            do {
                let stream = try await self.openAIApi?.sendMessageStream(
                    text: text,
                    model: "gpt-4",
                    temperature: 0.5
                )
                
                var fullResponse = [String]()
                var buf = [String]()
                
                for try await line in stream {
                    buf.append(line)
                    fullResponse.append(line)
                    
                    if self.speechDelimitingPunctuations.contains(line) {
                        let response = buf.joined()
                        
                        self.textToSpeechConverter.convertTextToSpeech(text: response)
                        buf.removeAll()
                    }
                }
                
                let response = buf.joined()
                self.textToSpeechConverter.convertTextToSpeech(text: response)
                
                self.conversation.append(Message(role: "assistant", content: fullResponse))
                self.addObject(response)
            } catch {
                print(error.localizedDescription)
            }
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
            makeAIQuery("Give me one random fact")
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
