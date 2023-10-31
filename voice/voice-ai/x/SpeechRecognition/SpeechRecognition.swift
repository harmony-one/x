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
    
    var pendingOpenAIStream: OpenAIStreamService?
    
    private var conversation: [Message] = []
    private let greatingText = "Hey!"
    
    private let audioPlayer = AudioPlayer()
    private var isRandomFacts = true
    
    private var isRequestingOpenAI = false
    private var _isPaused = false
    private var resumeListeningTimer: Timer? = nil
    private var silenceTimer: Timer?
    private var isCapturing = false
    
    // Current message being processed
    
    // MARK: - Initialization and Setup
    
    func setup() {
        checkPermissionsAndSetupAudio()
        textToSpeechConverter.convertTextToSpeech(text: greatingText)
        isCapturing = true
        startSpeechRecognition()
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
        print("[SpeechRecognition][startSpeechRecognition]")
        
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
            print("[SpeechRecognition][handleRecognition] \(message)")
            print("[SpeechRecognition][handleRecognition] isFinal: \(result.isFinal)")
            
            // isFinal does not work. See https://stackoverflow.com/a/42925643/1179349
            //            if result.isFinal {
            //                self.handleFinalRecognition(inputNode: inputNode, message: message)
            //            }
            
            self.silenceTimer?.invalidate()
            self.silenceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                if !message.isEmpty {
                    self.handleFinalRecognition(inputNode: inputNode, message: message)
                }
            }
        }
        
        installTapAndStartEngine(inputNode: inputNode)
    }
    
    private func handleRecognitionError(_ error: Error?) {
        if let error = error {
            print("[SpeechRecognition][handleRecognitionError][ERROR]: \(error)")
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
        }
    }
    
    private func handleFinalRecognition(inputNode: AVAudioNode, message: String) {
        //        inputNode.removeTap(onBus: 0)
        //        recognitionRequest = nil
        //        recognitionTask = nil
        if !message.isEmpty {
            print("Message:", message)
            makeQuery(message)
        }
    }
    
    private func installTapAndStartEngine(inputNode: AVAudioNode) {
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        do {
            audioEngine.prepare()
            try audioEngine.start()
            print("[SpeechRecognition] Audio engine started")
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }
    
    func makeQuery(_ text: String) {
        var buf = [String]()
        func flushBuf() {
            let response = buf.joined()
            guard !response.isEmpty else {
                return
            }
            registerTTS()
            textToSpeechConverter.convertTextToSpeech(text: response)
            conversation.append(Message(role: "assistant", content: response))
            print("[SpeechRecognition] flush response: \(response)")
            buf.removeAll()
        }
        
        if conversation.count == 0 {
            conversation.append(contentsOf: OpenAIStreamService.setConversationContext())
        }
        
        print("[SpeechRecognition] query: \(text)")
        
        VibrationManager.startVibration()
        conversation.append(Message(role: "user", content: text))
        
        audioPlayer.playSound()
        pauseCapturing()
        isRequestingOpenAI = true
        
        pendingOpenAIStream = OpenAIStreamService { res, err in
            guard err == nil else {
                print("[SpeechRecognition] OpenAI error: \(err!)")
                self.textToSpeechConverter.convertTextToSpeech(text: "Oh, my neuron network ran into an error. Can you try again?")
                return
            }
            guard let res = res else {
                return
            }
            if res == "[DONE]" {
                flushBuf()
                self.isRequestingOpenAI = false
                print("[SpeechRecognition] OpenAI Response Complete")
                return
            }
            print("[SpeechRecognition] OpenAI Response received: \(res)")
            buf.append(res)
            guard res.last != nil else {
                return
            }
            if self.speechDelimitingPunctuations.contains(res.last!) {
                flushBuf()
                return
            }
        }
        pendingOpenAIStream?.query(conversation: conversation)
    }
    
    func pauseCapturing() {
        guard isCapturing else {
            return
        }
        isCapturing = false
        print("[SpeechRecognition][pauseCapturing]")
        _isPaused = false
        recognitionTask?.finish()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        isRandomFacts = false
        self.audioPlayer.playSound()
        VibrationManager.startVibration()
        if (self.conversation.count == 0) {
            self.conversation.append(contentsOf: OpenAIStreamService.setConversationContext())
        }
    }
        
        func resumeCapturing() {
            guard !isCapturing else {
                return
            }
            isCapturing = true
            print("[SpeechRecognition][resumeCapturing]")
            setupAudioSession()
            setupAudioEngine()
            startSpeechRecognition()
        }
        
        func registerTTS() {
            if textToSpeechConverter.synthesizer.delegate == nil {
                textToSpeechConverter.synthesizer.delegate = self
            }
        }
        
        func reset() {
            print("[SpeechRecognition][reset]")
            stopGPT()
            textToSpeechConverter.stopSpeech()
            cleanupForNewSession()
        }
        
        private func stopGPT() {
            isRandomFacts = true
            pendingOpenAIStream?.cancelOpenAICall()
            audioPlayer.stopSound()
            VibrationManager.stopVibration()
        }
        
        private func cleanupForNewSession() {
            conversation.removeAll()
            pauseCapturing()
            stopGPT()
            textToSpeechConverter.stopSpeech()
            cleanupRecognition()
            isAudioSessionSetup = false
            resumeCapturing()
            textToSpeechConverter.synthesizer.delegate = nil
        }
        
        private func cleanupRecognition() {
            recognitionTask?.cancel()
            recognitionTask = nil
            recognitionRequest?.endAudio()
        }
        
        func isPaused() -> Bool {
            return _isPaused
        }
        
        func pause() {
            print("pause -- method called")
            _isPaused = true
            
            if isRequestingOpenAI {
                audioPlayer.stopSound()
                VibrationManager.stopVibration()
            } else {
                textToSpeechConverter.pauseSpeech()
            }
        }
        
        func continueSpeech() {
            print("continueSpeech -- method called")
            _isPaused = false
            
            if isRequestingOpenAI {
                audioPlayer.playSound()
                VibrationManager.startVibration()
            } else if textToSpeechConverter.synthesizer.isSpeaking {
                textToSpeechConverter.continueSpeech()
            } else {
                repeate()
            }
        }
        
        func randomFacts() {
            print("randomFacts -- method called")
            stopGPT()
            textToSpeechConverter.stopSpeech()
            makeQuery("Give me one random fact")
        }
        
        func speak() {
            pauseCapturing()
            stopGPT()
            textToSpeechConverter.stopSpeech()
            cleanupRecognition()
            isAudioSessionSetup = false
            resumeCapturing()
        }
        
        func stopSpeak() {
            if audioEngine.isRunning {
                recognitionTask?.finish()
            }
        }
        
        func cancelSpeak() {
            pauseCapturing()
        }
        
        func repeate() {
            pauseCapturing()
            print("repeate", conversation)
            if let m = conversation.last(where: { $0.role == "assistant" && $0.content != "" }) {
                print("repeate content", m.content ?? "")
                textToSpeechConverter.convertTextToSpeech(text: m.content ?? "")
            } else {
                textToSpeechConverter.convertTextToSpeech(text: "There are no prior conversations to repeat.")
            }
        }
    }
    
    // Extension for AVSpeechSynthesizerDelegate
    
    extension SpeechRecognition: AVSpeechSynthesizerDelegate {
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
            resumeListeningTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                print("Starting capturing again")
                DispatchQueue.main.async {
                    self.resumeCapturing()
                }
            }
        }
        
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
            audioPlayer.stopSound()
            pauseCapturing()
            resumeListeningTimer?.invalidate()
        }
    }

