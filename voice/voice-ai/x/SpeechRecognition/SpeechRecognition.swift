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
    
    private var speechDelimitingPunctuations = [Character("."), Character("?"), Character("!"), Character(","), Character("-")]
   
    var pendingOpenAIStream: OpenAIStreamService?
    
    private var conversation: [Message] = []
    private let greetingText = "Hey!"

    // TODO: to be used later to distinguish didFinish event triggered by greeting v.s. others
    //    private var isGreatingFinished = false
    
    private let audioPlayer = AudioPlayer()
    
    private var isRequestingOpenAI = false
    private var requestInitiatedTimestamp: Int64 = 0
    
    private var resumeListeningTimer: Timer? = nil
//    private var silenceTimer: Timer?
    private var isCapturing = false
    
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
    
    func makeQuery(_ text: String) {
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
        var initialFlush = false
        let initialLength = 4
        
        pendingOpenAIStream = OpenAIStreamService { res, err in
            guard err == nil else {
                let nsError = err! as NSError
                self.isRequestingOpenAI = false
                if nsError.code == -999 {
                    print("[SpeechRecognition] OpenAI Cancelled")
                    return
                }
                print("[SpeechRecognition] OpenAI error: \(nsError)")
                buf.removeAll()
                self.registerTTS()
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
                print("[SpeechRecognition] Complete Response text", completeResponse.joined())
                if !completeResponse.isEmpty {
                    self.conversation.append(Message(role: "assistant", content: completeResponse.joined()))
                }
                return
            }
            
            print("[SpeechRecognition] OpenAI Response received: \(res)")
            buf.append(res)
            guard res.last != nil else {
                return
            }
            
            if !initialFlush && (buf.count == initialLength || self.speechDelimitingPunctuations.contains(res.last!)) {
                let timestampDelta = self.getCurrentTimestamp() - self.requestInitiatedTimestamp
                print("[SpeechRecognition] OpenAI first response latency: \(timestampDelta) ms")
                print("###### INITIAL FLUSH", buf)
                flushBuf()
                initialFlush = true
                return
            } else {
                // Two Cases:
                // 1. Initial flush by delimiter: Continue the process.
                // 2. By word count: First element may be a punctuation.
                //    Get rid of the punctuation so that the synthesizer does not read out the it.
                // TODO: " ." will not be removed!
                if (buf.count != 1 && self.speechDelimitingPunctuations.contains(res.last!)) {
                    if self.speechDelimitingPunctuations.contains(buf[0]) {
                        print("###### FIRST ONE PUNCTUATION", buf)
                        buf.remove(at: 0)
                    }
                    print("###### FLUSH", buf)
                    flushBuf()
                }
                return
            }
//            if buf.count == 5 || (buf.count != 1 && self.speechDelimitingPunctuations.contains(res.last!)) {
//                print("###### BUFFER", buf)
//                flushBuf()
//                return
//            }
            
        }
        pendingOpenAIStream?.query(conversation: conversation)
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
        
        let hadConversaion = conversation.count > 0;
        
        textToSpeechConverter.stopSpeech()
        stopGPT()
        _isPaused = false
        conversation.removeAll()
        pauseCapturing()
        stopGPT()
        isAudioSessionSetup = false
        setupAudioSession()
        setupAudioEngine()
        registerTTS()
        
        print("con \(conversation.count)")
        
        if feedback! && hadConversaion {
            print("[SpeechRecognition][reset] greeting")
            textToSpeechConverter.convertTextToSpeech(text: greetingText)
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
        let randomRank = Int.random(in: 800..<1500)
        let query = "Give me a summary of a random wikipedia topic from the top \(randomRank) most popular wikipedia pages. Please respond with two sentences or less. Please respond with only the summary and no other text."
        makeQuery(query)
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
