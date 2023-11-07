import AVFoundation
import Combine
import Speech

protocol SpeechRecognitionProtocol {
    func reset()
    func reset(feedback: Bool?)
    func randomFacts()
    func isPaused() -> Bool
    func continueSpeech()
    func pause(feedback: Bool?)
    func repeate()
    func speak()
    func stopSpeak()
    func sayMore()
}

extension SpeechRecognitionProtocol {
    func reset() {
        reset(feedback: true)
    }
    
    func pause() {
        pause(feedback: true)
    }
}

class SpeechRecognition: NSObject, ObservableObject, SpeechRecognitionProtocol {
    // MARK: - Properties
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    private var messageInRecongnition = ""
    private let recognitionLock = DispatchSemaphore(value: 1)
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var isAudioSessionSetup = false
    var audioSession: AVAudioSessionProtocol = AVAudioSessionWrapper()
    let textToSpeechConverter = TextToSpeechConverter()
    static let shared = SpeechRecognition()
    
    private var speechDelimitingPunctuations = [Character("."), Character("?"), Character("!"), Character(","), Character("-"), Character(";")]
   
    var pendingOpenAIStream: OpenAIStreamService?
    
    private var conversation: [Message] = []
    private let greetingText = "Hey!"
    private let sayMoreText = "Tell me more."

    // TODO: to be used later to distinguish didFinish event triggered by greeting v.s. others
    //    private var isGreatingFinished = false
    
    private let audioPlayer = AudioPlayer()
    
    private var isRequestingOpenAI = false
    private var requestInitiatedTimestamp: Int64 = 0
    
    private var resumeListeningTimer: Timer? = nil
//    private var silenceTimer: Timer?
    private var isCapturing = false
    
    // Upperbound for the number of words buffer can contain before triggering a flush
    private var bufferCapacity = 10

    
    @Published private var _isPaused = false
    var isPausedPublisher: Published<Bool>.Publisher {
        $_isPaused
    }
    
    @Published private var _isPlaying = false
    var isPlaingPublisher: Published<Bool>.Publisher {
        $_isPlaying
    }
    
    private var isPlayingWorkItem: DispatchWorkItem?
        
    // Current message being processed
        
    // MARK: - Initialization and Setup

    func setup() {
        checkPermissionsAndSetupAudio()
        textToSpeechConverter.convertTextToSpeech(text: greetingText)
        isCapturing = true
//        startSpeechRecognition()
    }
    
    private func checkPermissionsAndSetupAudio() {
        Permission().setup()
        registerTTS()
        setupAudioSession()
        setupAudioEngine()
    }
    
    // MARK: - Audio Session Management

     func setupAudioSession() {
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
    
    // Internal getter for audioEngine
    internal func getAudioEngine() -> AVAudioEngine {
        return audioEngine
    }
    
    internal func getISAudioSessionSetup() -> Bool {
        return isAudioSessionSetup
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
            
            if !message.isEmpty {
                self.recognitionLock.wait()
                self.messageInRecongnition = message
                self.recognitionLock.signal()
            }
            // isFinal does not work mid-speech. See https://stackoverflow.com/a/42925643/1179349
            // Note: not using this. Instead, use stopSpeak() to trigger finalization instead
//            if result.isFinal {
//                self.recognitionLock.wait()
//                let message = self.messageInRecongnition
//                self.messageInRecongnition = ""
//                self.recognitionLock.signal()
//                self.handleFinalRecognition(inputNode: inputNode, message: message)
//            }
            
//            self.silenceTimer?.invalidate()
//            self.silenceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
//                if !message.isEmpty {
//                    self.handleFinalRecognition(inputNode: inputNode, message: message)
//                }
//            }
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
                return
            }
            // General cleanup process
            let inputNode = audioEngine.inputNode
            inputNode.removeTap(onBus: 0)
            recognitionRequest = nil
            recognitionTask = nil
        }
    }
    
    // TODO: remove
//    private func handleFinalRecognition(inputNode: AVAudioNode, message: String) {
    ////        inputNode.removeTap(onBus: 0)
    ////        recognitionRequest = nil
    ////        recognitionTask = nil
//        if !message.isEmpty {
//            makeQuery(message)
//        }
//    }
    
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
    
    func getCurrentTimestamp() -> Int64 {
        return Int64(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func makeQuery(_ text: String, maxRetry: Int = 3) {
        if isRequestingOpenAI {
            return
        }
        
        var completeResponse = [String]()
        var buf = [String]()
        
        func flushBuf() {
            let response = buf.joined()
            guard !response.isEmpty else {
                return
            }
            
            registerTTS()
            textToSpeechConverter.convertTextToSpeech(text: response)
            
            completeResponse.append(response)
            print("[SpeechRecognition] flush response: \(response)")
            buf.removeAll()
        }
        
        if conversation.count == 0 {
            conversation.append(contentsOf: OpenAIStreamService.setConversationContext())
        }
        
       print("[SpeechRecognition] query: \(text)")
        
        conversation.append(Message(role: "user", content: text))
        requestInitiatedTimestamp = self.getCurrentTimestamp()
        
        audioPlayer.playSound()
        pauseCapturing()
        isRequestingOpenAI = true
        
        // Initial Flush to reduce perceived latency
//        var initialFlush = false
        var currWord = ""
        
        func handleQuery(retryCount: Int) {
            // Make sure to pass the retriesLeft parameter through to your OpenAIStreamService
            pendingOpenAIStream = OpenAIStreamService { res, err in
                guard err == nil else {
                    handleError(err!, retryCount: retryCount)
                    return
                }
                
                guard let res = res, !res.isEmpty else {
                    return
                }
                
                if res == "[DONE]" {
                    buf.append(currWord)
                    flushBuf()
                    self.isRequestingOpenAI = false
                    print("[SpeechRecognition] OpenAI Response Complete")
                    print("[SpeechRecognition] Complete Response text", completeResponse.joined())
                    if !completeResponse.isEmpty {
                        self.conversation.append(Message(role: "assistant", content: completeResponse.joined()))
                    }
                    return
                }
                
                print("[SpeechRecognition] OpenAI Response received: \(res)")
                
                // Append received streams to currWord instead of buf directly
                if res.first == " " {
                    buf.append(currWord)
                    
                    // buf should only contain complete words
                    // ensure streams that do not have a whitespace in front are appended to the previous one (part of the previous stream)
                    if self.speechDelimitingPunctuations.contains(currWord.last!) || buf.count == self.bufferCapacity {
                        flushBuf()
                    }
                    
                    currWord = res
                    guard res.last != nil else {
                        return
                    }
                    
                } else {
                    currWord.append(res)
                }
            }
            pendingOpenAIStream?.query(conversation: conversation)
        }
        
        func handleError(_ error: Error, retryCount: Int) {
            self.isRequestingOpenAI = false
            let nsError = error as NSError
            if nsError.code == -999 {
                print("[SpeechRecognition] OpenAI Cancelled")
            } else if retryCount > 0 {
                let attempt = maxRetry - retryCount
                let delay = pow(2.0, Double(attempt)) // exponential backoff (1s, 2s, 4s, ...)
                print("[SpeechRecognition] OpenAI error: \(error). Retrying attempt \(attempt + 1) in \(delay) seconds...")
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    buf.removeAll()
                    currWord = ""
                    handleQuery(retryCount: retryCount - 1)
                }
            } else {
                print("[SpeechRecognition] OpenAI error: \(nsError). No more retries.")
                buf.removeAll()
                self.registerTTS()
                self.textToSpeechConverter.convertTextToSpeech(text: "I'm sorry, there seems to be an issue. Please try again later.")
            }
        }
        
        handleQuery(retryCount: maxRetry)
    }
    
    func pauseCapturing() {
        guard isCapturing else {
            return
        }
        isCapturing = false
        print("[SpeechRecognition][pauseCapturing]")
        recognitionTask?.finish()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
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
    
    func reset(feedback: Bool? = true) {
        print("[SpeechRecognition][reset]")
        
        // Perform all UI updates on the main thread
        DispatchQueue.main.async {
            self.textToSpeechConverter.stopSpeech()
            self._isPaused = false
            self.conversation.removeAll()
        }
        
        // Perform all cleanup tasks in the background
        DispatchQueue.global(qos: .userInitiated).async {
            self.pauseCapturing()
            self.stopGPT()
            
            // No need to reset the audio session if you're going to set it up again immediately after
            // self.isAudioSessionSetup = false
            
            // Call these setup functions only if they are necessary. If they are not changing state, you don't need to call them.
            self.setupAudioSession()
            self.setupAudioEngineIfNeeded()
            
            // If TTS needs to be registered again, do it in the background
            self.registerTTS()
            
            DispatchQueue.main.async {
                if feedback == true{
                    // Play the greeting text
                    self.textToSpeechConverter.convertTextToSpeech(text: self.greetingText)
                }
            }
        }
    }

    func setupAudioEngineIfNeeded() {
        guard !audioEngine.isRunning else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            // Only start the audio engine if it's not already running
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Error setting up audio engine: \(error.localizedDescription)")
        }
    }


    private func stopGPT() {
        pendingOpenAIStream?.cancelOpenAICall()
        pendingOpenAIStream = nil
        audioPlayer.stopSound()
    }
    
    private func cleanupRecognition() {
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
    }
    
    func isPaused() -> Bool {
        return _isPaused
    }
    
    func isPlaying() -> Bool {
        return _isPlaying
    }
    
    func pause(feedback: Bool? = true) {
        print("[SpeechRecognition][pause]")
        
        if textToSpeechConverter.synthesizer.isSpeaking {
            _isPaused = true
            textToSpeechConverter.pauseSpeech()
        } else {
            if !isRequestingOpenAI && feedback! {
                audioPlayer.playSound(false)
            }
        }
    }
    
    func continueSpeech() {
        print("[SpeechRecognition][continueSpeech]")
        
        if textToSpeechConverter.synthesizer.isSpeaking {
            _isPaused = false
            textToSpeechConverter.continueSpeech()
        } else {
            if !isRequestingOpenAI {
                audioPlayer.playSound(false)
            }
        }
    }
    
    func randomFacts() {
        print("[SpeechRecognition][randomFacts]")
        stopGPT()
        textToSpeechConverter.stopSpeech()
        _isPaused = false
        let randomTitle = getTitle()
        let query = "Summarize \(randomTitle) from Wikipedia"
        makeQuery(query)
    }
    
    func sayMore() {
        print("[SpeechRecognition][sayMore]")
        stopGPT()
        textToSpeechConverter.stopSpeech()
        _isPaused = false
        if self.conversation.count == 0 {
            self.registerTTS()
            self.textToSpeechConverter.convertTextToSpeech(text: "Let me know what to say more about!")
            return
        }
        makeQuery(sayMoreText)
    }
    
    func speak() {
        print("[SpeechRecognition][speak]")
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
        
        if !messageInRecongnition.isEmpty {
            recognitionLock.wait()
            let message = messageInRecongnition
            messageInRecongnition = ""
            recognitionLock.signal()
            makeQuery(message)
        } else {
            audioPlayer.playSound(false)
        }
        
        pauseCapturing()
    }
    
    func cancelSpeak() {
        pauseCapturing()
    }
    
    func repeate() {
        textToSpeechConverter.stopSpeech()
        pauseCapturing()
        print("repeate", conversation)
        _isPaused = false
        if let m = conversation.last(where: { $0.role == "assistant" && $0.content != "" }) {
            print("repeate content", m.content ?? "")
            textToSpeechConverter.convertTextToSpeech(text: m.content ?? "")
        } else {
            textToSpeechConverter.convertTextToSpeech(text: greetingText)
        }
    }
}

// Extension for AVSpeechSynthesizerDelegate

extension SpeechRecognition: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        isPlayingWorkItem?.cancel()
        isPlayingWorkItem = DispatchWorkItem { [weak self] in
            if ((self?._isPlaying) != nil) {
                print("[SpeechRecognition][synthesizeFinish]")
                self?._isPlaying = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: isPlayingWorkItem!)
        
        
        // TODO: to be used later for automatically resuming capturing when agent is not speaking
        //        resumeListeningTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
        //            print("[SpeechRecognition][speechSynthesizer][didFinish] Starting capturing again")
        //            DispatchQueue.main.async {
        //                if self.isGreatingFinished {
        //                    self.resumeCapturing()
        //                }
        //                self.isGreatingFinished = true
        //            }
        //        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        
        isPlayingWorkItem?.cancel()
        isPlayingWorkItem = DispatchWorkItem { [weak self] in
            if self?._isPlaying == false {
                print("[SpeechRecognition][synthesizeStart]")
                self?._isPlaying = true
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: isPlayingWorkItem!)
        
        audioPlayer.stopSound()
        pauseCapturing()
        resumeListeningTimer?.invalidate()
    }
}
