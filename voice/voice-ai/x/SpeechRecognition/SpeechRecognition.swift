// swiftformat:disable redundantInternal

import AVFoundation
import Combine
import Foundation
import OSLog
import Sentry
import Speech

protocol SpeechRecognitionProtocol {
    func reset()
    func reset(feedback: Bool?)
    func surprise()
    func trivia()
    func isPaused() -> Bool
    func continueSpeech()
    func pause(feedback: Bool?)
    func repeate()
    func speak()
    func stopSpeak(cancel: Bool?)
    func sayMore()
    func cancelSpeak()
    func cancelRetry()
}

extension SpeechRecognitionProtocol {
    func reset() {
        reset(feedback: true)
    }
    
    func pause() {
        pause(feedback: true)
    }
    
    func stopSpeak() {
        stopSpeak(cancel: false)
    }
}

class SpeechRecognition: NSObject, ObservableObject, SpeechRecognitionProtocol {
    private var timeLogger: TimeLogger?
    var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: "SpeechRecognition")
    )
    private let audioEngine = AVAudioEngine()
    private let preferredLocale = Locale.preferredLanguages.first ?? "en-US"
    private let speechRecognizer: SFSpeechRecognizer? = {
        let preferredLocale = Locale.preferredLanguages.first ?? "en-US"
        let locale = Locale(identifier: preferredLocale)
        return SFSpeechRecognizer(locale: locale)
    }()

    private var messageInRecongnition = ""
    private let recognitionLock = DispatchSemaphore(value: 1)
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    internal var recognitionTaskCanceled: Bool?
    private var isAudioSessionSetup = false
    var audioSession: AVAudioSessionProtocol = AVAudioSessionWrapper()
    var textToSpeechConverter = TextToSpeechConverter()
    static let shared = SpeechRecognition()
    var pendingOpenAIStream: OpenAIStreamService?
    internal var conversation: [Message] = []
    private var completeResponse: [String] = []
    private var isRepeatingCurrentSession = false

    // TODO: to be used later to distinguish didFinish event triggered by greeting v.s. others
    //    private var isGreatingFinished = false
    
    private let audioPlayer = AudioPlayer()
    internal var isRequestingOpenAI = false
    private var requestInitiatedTimestamp: Int64 = 0
    private var resumeListeningTimer: Timer?
//    private var silenceTimer: Timer?
    private var isCapturing = false
    
    // Upperbound for the number of words buffer can contain before triggering a flush
    private var initialCapacity = 10
//    TODO: Adjust buffer capacity for each language (eg. Japanese takes too long before flush)
    private var bufferCapacity = 50
    private var retryWorkItem: DispatchWorkItem?
    private var contextLimit = 8192

    @Published private var _isPaused = false
    var isPausedPublisher: Published<Bool>.Publisher {
        $_isPaused
    }

    @Published private var _isPlaying = false
    var isPlayingPublisher: Published<Bool>.Publisher {
        $_isPlaying
    }
    
    private var isPlayingWorkItem: DispatchWorkItem?
    var isTimerDidFired = false
    let languageCode: String
    private let speechDelimitingPunctuations: [Character]
    private let greetingText: String
    private let sayMoreText: String
    private let letMeKnowText: String
    private let networkErrorText: String
    private let limitReachedText: String
    private let answerLimitText: String
    private let vibration = VibrationManager.shared
    @Published var isThinking: Bool = false

    // MARK: - Initialization and Setup
    
    override init() {
        self.languageCode = getLanguageCode()
        
        self.speechDelimitingPunctuations = getDelimitingPunctuations(for: languageCode) ?? []
        
        self.greetingText = String(localized: "speechRecognition.text.greeting")
        self.sayMoreText = String(localized: "speechRecognition.text.sayMore")
        self.letMeKnowText = String(localized: "speechRecognition.text.letMeKnow")
        self.networkErrorText = String(localized: "speechRecognition.text.networkError")
        self.limitReachedText = String(localized: "speechRecognition.text.limitReached")
        self.answerLimitText = String(localized: "speechRecognition.text.answerLimit")
    }

    func setup() {
        checkPermissionsAndSetupAudio()
        textToSpeechConverter.convertTextToSpeech(text: greetingText, timeLogger: nil)
        isCapturing = true
//        startSpeechRecognition()
        setupTimer()
        
        // TODO: Place this method at right place
        textToSpeechConverter.checkAndPromptForPremiumVoice()
    }
    
    private func setupTimer() {
        TimerManager.shared.startTimer()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTimerDidFire),
            name: .timerDidFireNotification,
            object: nil
        )
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
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothA2DP, .allowAirPlay])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.setMode(.spokenAudio)
              
            isAudioSessionSetup = true
        } catch {
            logger.log("Error setting up audio session: \(error.localizedDescription)")
            SentrySDK.capture(message: "Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
    // Function to setup the audio engine
    func setupAudioEngine() {
        if !audioEngine.isRunning {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: [.defaultToSpeaker, .allowBluetoothA2DP, .allowAirPlay])
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                try AVAudioSession.sharedInstance().setMode(.spokenAudio)
                try AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(true)
            } catch {
                logger.log("Error setting up audio engine: \(error.localizedDescription)")
                SentrySDK.capture(message: "Error setting up audio session: \(error.localizedDescription)")
            }
        }
    }
    
    // Internal getter for audioEngine
    func getAudioEngine() -> AVAudioEngine {
        return audioEngine
    }
    
    func getISAudioSessionSetup() -> Bool {
        return isAudioSessionSetup
    }
    
    // MARK: - Speech Recognition
    
    func startSpeechRecognition() {
        logger.log("[SpeechRecognition][startSpeechRecognition]")
        
        setupAudioSession()
        cleanupRecognition()
        
        let inputNode = audioEngine.inputNode
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        handleRecognition(inputNode: inputNode)
    }
    
    private func handleRecognition(inputNode: AVAudioNode) {
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            guard let result = result else {
                self.handleRecognitionError(error)
                return
            }
            let message = result.bestTranscription.formattedString
            self.logger.log("[handleRecognition] \(message)")
            self.logger.log("[handleRecognition] isFinal: \(result.isFinal)")
            
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
        timeLogger?.setSttRec()
    }
    
    private func handleRecognitionError(_ error: Error?) {
        if let error = error {
            logger.log("[handleRecognitionError][ERROR]: \(error)")
            let nsError = error as NSError
            
            if recognitionTaskCanceled != true && nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 1110 {
                print("No speech was detected. Please speak again.")
                logger.log("No speech was detected. Please speak again.")

                if !isThinking {
                    vibration.stopVibration()
                }

                return
            }
            
            SentrySDK.capture(message: "handleRecognitionError: \(error.localizedDescription)")
            
            recognitionTaskCanceled = nil
            // General cleanup process
            let inputNode = audioEngine.inputNode
            recognitionRequest?.endAudio()
            inputNode.removeTap(onBus: 0)
            recognitionRequest = nil
            recognitionTask = nil
        }
    }
    
    // TO-DO: remove
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
        if recordingFormat.sampleRate == 0.0 {
            return
        }
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        do {
            audioEngine.prepare()
            try audioEngine.start()
            logger.log("Audio engine started")
        } catch {
            logger.log("Error starting audio engine: \(error.localizedDescription)")
            SentrySDK.capture(message: "Error starting audio engine: \(error.localizedDescription)")
        }
    }
    
    func getCurrentTimestamp() -> Int64 {
        return Int64(NSDate().timeIntervalSince1970 * 1000)
    }
    
    // 14 retries with exponential back off from 2 (cap at 64) would give total of ~10 minute retries
    func makeQuery(_ text: String, maxRetry: Int = 14, rateLimit: Bool? = true) {
        if isRequestingOpenAI {
            logger.log("RequestingOpenAI: skip")
            return
        }
        DispatchQueue.main.async {
            self.isThinking = true
        }
        vibration.startVibration()
        // Ensure to cancel the previous retry before proceeding
        cancelRetry()
        
        let transaction = SentrySDK.startTransaction(
            name: "Request OpenAI", // give it a name
            operation: "openai.request" // and a name for the operation
        )
        
        completeResponse = [String]()
        var buf = [String]()
        
        func flushBuf() {
            let response = buf.joined()
            guard !response.isEmpty else {
                return
            }
            
            registerTTS()
            
            timeLogger?.setTTSInit()
            
            if !isRepeatingCurrentSession {
                textToSpeechConverter.convertTextToSpeech(text: response, timeLogger: timeLogger)
            }
            completeResponse.append(response)
            logger.log("[Flush Response] \(response, privacy: .public)")
            DispatchQueue.main.async {
                self.isThinking = false
            }
            vibration.stopVibration()
            buf.removeAll()
        }
        
        logger.log("[Query] \(text, privacy: .public)")
        conversation.append(Message(role: "user", content: text))
        requestInitiatedTimestamp = getCurrentTimestamp()
        
        pauseCapturing()
        isRequestingOpenAI = true
        
        // Initial Flush to reduce perceived latency
        var initialFlush = false
        var currWord = ""

        func handleError(_ error: Error, retryCount: Int) {
            DispatchQueue.main.async {
                self.isThinking = false
            }
            vibration.stopVibration()

            isRequestingOpenAI = false
            let nsError = error as NSError
            if nsError.code == -999 {
                logger.log("OpenAI Cancelled")
                timeLogger?.sendLog()
                VibrationManager.shared.stopVibration()
                // Commented for now since we were receiving arbitrary -999 that was causing beeping.
//                audioPlayer.playSound(false)
            } else if nsError.code == -3 {
                logger.log("OpenAI Rate Limited")
                audioPlayer.playSound(false)
                buf.removeAll()
                registerTTS()
                textToSpeechConverter.convertTextToSpeech(text: "I can only answer 100 questions per minute at this time.", timeLogger: nil)
                SentrySDK.capture(message: "[SpeechRecognition] OpenAI Rate Limited")
                timeLogger?.sendLog()
            } else if retryCount > 0 {
                audioPlayer.playSound(false)
                let attempt = maxRetry - retryCount + 1
                // cap the delay at 64 seconds
                let delay = min(pow(2.0, Double(attempt)), 64) // exponential backoff (2s, 4s, 8s, ...)
                logger.log("OpenAI error: \(error). Retrying attempt \(attempt) in \(delay) seconds...")
                retryWorkItem = DispatchWorkItem {
                    buf.removeAll()
                    currWord = ""
                    initialFlush = false
                    handleQuery(retryCount: retryCount - 1)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: retryWorkItem!)
            } else {
                SentrySDK.capture(message: "[SpeechRecognition] OpenAI error: \(nsError). No more retries.")
                logger.log("OpenAI error: \(nsError). No more retries.")
                buf.removeAll()
                registerTTS()
                textToSpeechConverter.convertTextToSpeech(text: networkErrorText, timeLogger: nil)
                timeLogger?.sendLog()
            }
        }
        
        func handleQuery(retryCount: Int) {
            let startDate = Date()
            var isResponseReceived = false

            // Make sure to pass the retriesLeft parameter through to your OpenAIStreamService
            pendingOpenAIStream = OpenAIStreamService { res, err in
                guard err == nil else {
                    handleError(err!, retryCount: retryCount)
                    transaction.finish()
                    return
                }
                
                if !isResponseReceived {
                    isResponseReceived = true
                    let executionTime = Date().timeIntervalSince(startDate)
                    self.logger.log("Request latency: \(executionTime)")
                }
                
                guard let res = res, !res.isEmpty else {
                    return
                }
                if res == "[DONE]" {
                    buf.append(currWord)
                    flushBuf()
                    self.isRequestingOpenAI = false
                    self.logger.log("OpenAI Response Complete")
                    self.logger.log("[Complete Response] \(self.completeResponse.joined(), privacy: .public)")
                    if !self.completeResponse.isEmpty {
                        self.conversation.append(Message(role: "assistant", content: self.completeResponse.joined()))
                    }
                    transaction.finish()
                    self.timeLogger?.setAppResEnd()
                    return
                }
//                self.logger.log("OpenAI Response received: \(res)")
                
                // Append received streams to currWord instead of buf directly
                if res.first == " " {
                    buf.append(currWord)
                    // buf should only contain complete words
                    // ensure streams that do not have a whitespace in front are appended to the previous one (part of the previous stream)
                    if !initialFlush {
                        if self.speechDelimitingPunctuations.contains(currWord.last!) || buf.count == self.initialCapacity {
                            if let lastChar = currWord.last {
                                self.logger.log("[Buffer] \(buf, privacy: .public), [currword] \(currWord), [currWordLast] \(lastChar, privacy: .public)")
                            } else {
                                self.logger.log("[Buffer] \(buf, privacy: .public), [currword] \(currWord, privacy: .public), [currWordLast] nil")
                            }
                            flushBuf()
                            initialFlush = true
                        }
                    } else {
                        if self.speechDelimitingPunctuations.contains(currWord.last!) || buf.count == self.bufferCapacity {
                            if let lastChar = currWord.last {
                                self.logger.log("[Buffer] \(buf, privacy: .public), [currword] \(currWord), [currWordLast] \(lastChar, privacy: .public)")
                            } else {
                                self.logger.log("[Buffer] \(buf, privacy: .public), [currword] \(currWord, privacy: .public), [currWordLast] nil")
                            }
                            flushBuf()
                        }
                    }
                    currWord = res
                    guard res.last != nil else {
                        transaction.finish()
                        return
                    }
                } else {
                    currWord.append(res)
                }
            }
            
            var limitedConversation = OpenAIUtils.limitConversationContext(conversation, charactersCount: contextLimit)
            // Important: Add an instruction at the beginning of the conversation
            limitedConversation.insert(contentsOf: OpenAIStreamService.setConversationContext(), at: 0)
            // for custom instruction changes
            conversation.insert(contentsOf: OpenAIStreamService.setConversationContext(), at: 0)
            
            pendingOpenAIStream?.query(conversation: limitedConversation, rateLimit: rateLimit, timeLogger: timeLogger)
        }
        
        handleQuery(retryCount: maxRetry)
    }
    
    func cancelRetry() {
        logger.log("[cancelRetry]")
        retryWorkItem?.cancel()
    }
    
    func pauseCapturing(cancel: Bool? = false) {
        guard isCapturing else {
            return
        }
        // Perform all UI updates on the main thread
        DispatchQueue.main.async {
            self.isCapturing = false
            self._isPaused = false
        }
        logger.log("[pauseCapturing]")
        
        if cancel == true {
            logger.log("[cancelCalled]")
            recognitionTaskCanceled = true
        }
        recognitionTask?.finish()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        logger.log("stop")
    }
    
    func resumeCapturing() {
        guard !isCapturing else {
            return
        }
        isCapturing = true
        logger.log("[resumeCapturing]")
        setupAudioSession()
        setupAudioEngine()
        startSpeechRecognition()
    }
    
    func registerTTS() {
        if self.textToSpeechConverter.synthesizer.delegate == nil {
            self.textToSpeechConverter.synthesizer.delegate = self
        }
    }
    
    func reset(feedback: Bool? = true) {
        logger.log("[reset]")
        DispatchQueue.main.async {
            self.isThinking = false
        }
        vibration.stopVibration()
        audioPlayer.playSound(false)
        // Perform all UI updates on the main thread
        DispatchQueue.main.async {
            self.textToSpeechConverter.stopSpeech()
            self._isPaused = false
            self.conversation.removeAll()
        }
        
        // Perform all cleanup tasks in the background
        DispatchQueue.global(qos: .userInitiated).async {
            AppConfig.shared.renewRelayAuth()
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
                if feedback == true {
                    // Play the greeting text
                    self.textToSpeechConverter.convertTextToSpeech(text: self.greetingText, timeLogger: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        ReviewRequester.shared.logSignificantEvent()
                    }
                }
            }
        }
    }

    func checkContextChange() -> Bool {
        if conversation.isEmpty {
            return false
        }
        if let contextMessage = conversation.first(where: { $0.role == "system" }) {
            let currentContext = contextMessage.content
            let newContext = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
            if currentContext == newContext {
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    func setupAudioEngineIfNeeded() {
        guard !audioEngine.isRunning else { return }
        audioEngine.mainMixerNode
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetoothA2DP, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            try AVAudioSession.sharedInstance().setMode(.spokenAudio)
            try AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(true)
            // Only start the audio engine if it's not already running
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            logger.log("Error setting up audio engine: \(error.localizedDescription)")
            
            SentrySDK.capture(message: "Error setting up audio engine: \(error.localizedDescription)")
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
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    func isPaused() -> Bool {
        return _isPaused
    }
    
    func isPlaying() -> Bool {
        return _isPlaying
    }
    
    func pause(feedback: Bool? = true) {
        logger.log("[pause]")
        if textToSpeechConverter.synthesizer.isSpeaking {
            textToSpeechConverter.pauseSpeech()
        } else {
            if !isRequestingOpenAI && feedback! {
//                audioPlayer.playSound(false)
            }
        }
        _isPaused = true
    }
    
    func continueSpeech() {
        logger.log("[continueSpeech]")
        
        if textToSpeechConverter.synthesizer.isSpeaking {
            textToSpeechConverter.continueSpeech()
        } else {
            if !isRequestingOpenAI {
//                audioPlayer.playSound(false)
            }
        }
        _isPaused = false
    }
        
    func surprise() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.timeLogger = TimeLogger(vendor: "openai", endpoint: "completion")
            self.timeLogger?.setAppRecEnd()
            
            self.logger.log("[surprise]")

            // Stop any ongoing interactions and speech.
            self.stopGPT()
            // hotfix: todo: Waiting for a gpt request cancellation
            // app tries to send a new request to OpenAI before the previous one is canceled
            self.isRequestingOpenAI = false
            // hotfix-end
            self.textToSpeechConverter.stopSpeech()

            // Since we are about to initiate a new fact retrieval, pause any capturing.
            self.pauseCapturing()

            // Fetch a random title for the fact. This function should be synchronous and return immediately.
            var query: String
            if let randomTitle = ArticleManager.getRandomArticleTitle() {
                query = "Summarize \(randomTitle) from Wikipedia in \(self.preferredLocale) language."
                // Failure to return a title will result in a summary of the Wikipedia page for cat.
            } else {
                query = "Sumamarize cat from Wikipedia"
            }

            // Now make the query to fetch the fact.
            self.timeLogger?.setSTTEnd()
            
            self.makeQuery(query, rateLimit: false)
        }

        // Any UI updates need to be performed on the main thread.
        DispatchQueue.main.async {
            // Reset the paused state to allow the new fact to be spoken out loud.
            self._isPaused = false
        }
    }
    
    func trivia() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.timeLogger = TimeLogger(vendor: "openai", endpoint: "completion")
            self.timeLogger?.setAppRecEnd()
            
            self.logger.log("[trivia]")

            // Stop any ongoing interactions and speech.
            self.stopGPT()
            // hotfix: todo: Waiting for a gpt request cancellation
            // app tries to send a new request to OpenAI before the previous one is canceled
            self.isRequestingOpenAI = false
            // hotfix-end
            self.textToSpeechConverter.stopSpeech()

            // Since we are about to initiate a new fact retrieval, pause any capturing.
            self.pauseCapturing()

            // Fetch a random trivia topic for the question. This function should be synchronous and return immediately.
            var query: String
            if let randomTrivia = TriviaManager.getRandomTriviaTopic() {
                query = String(localized: "customInstruction.trivia \(randomTrivia) \(self.preferredLocale)")
            } else {
                query = "Approximately how many average sized cats could you fit in the average American elevator?"
            }

            // Now make the query to fetch the fact.
            self.timeLogger?.setSTTEnd()
            
            self.makeQuery(query, rateLimit: false)
        }

        // Any UI updates need to be performed on the main thread.
        DispatchQueue.main.async {
            // Reset the paused state to allow the new fact to be spoken out loud.
            self._isPaused = false
        }
    }
    
    func sayMore() {
        logger.log("[sayMore]")
        timeLogger = TimeLogger(vendor: "openai", endpoint: "completion")
        timeLogger?.setAppRecEnd()
        
        // Stop any ongoing speech or OpenAI interactions
        DispatchQueue.global(qos: .userInitiated).async {
            self.stopGPT()
            // hotfix: todo: Waiting for a gpt request cancellation
            // app tries to send a new request to OpenAI before the previous one is canceled
            self.isRequestingOpenAI = false
            // hotfix-end
            self.textToSpeechConverter.stopSpeech()
            
            // Reset the paused state, ensuring UI updates are on the main thread
            DispatchQueue.main.async {
                self._isPaused = false
            }
            
            // Check if there is a previous conversation to refer to
            if self.conversation.isEmpty {
                // If there's no previous conversation, request the user to provide context
                DispatchQueue.main.async {
                    self.registerTTS()
                    self.textToSpeechConverter.convertTextToSpeech(text: self.letMeKnowText, timeLogger: nil)
                }
                return
            }
            
            self.timeLogger?.setSTTEnd()

            // Make the query for more information on a background thread
            self.makeQuery(self.sayMoreText)
        }
    }

    func speak() {
        timeLogger = TimeLogger(vendor: "openai", endpoint: "completion")
        timeLogger?.setAppRec()
        DispatchQueue.main.async {
            self.isThinking = false
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.logger.log("[speak]")

            // Stop any ongoing OpenAI requests and text-to-speech conversion
            self.stopGPT()
            self.textToSpeechConverter.stopSpeech()

            // Pause capturing to reset the recognition session
            self.pauseCapturing()

            // Reset the audio session setup state to ensure it's configured correctly when restarted
            self.isAudioSessionSetup = false

            // Resume capturing on the main thread to ensure proper setup of audio and recognition
            DispatchQueue.main.async {
                // Setup the audio session and engine again, ensuring it's ready for a new recognition session
                self.setupAudioSession()
                self.setupAudioEngineIfNeeded()

                self.resumeCapturing()
            }
        }
    }

    // Refactored 'stopSpeak' function to finalize speech recognition
    func stopSpeak(cancel: Bool? = false) {
        timeLogger?.setAppRecEnd()
        DispatchQueue.global(qos: .userInitiated).async {
            self.logger.log("[stopSpeak]")
            
            // Finalize the recognition task if the audio engine is running
            if self.audioEngine.isRunning {
                self.recognitionTask?.finish()
            }
            
            // If there's recognized text, handle it
            if !self.messageInRecongnition.isEmpty {
                self.recognitionLock.wait()
                let message = self.messageInRecongnition
                self.messageInRecongnition = ""
                self.recognitionLock.signal()
                
                // Make the query on the background thread
                self.timeLogger?.setSTTEnd()
                
                self.makeQuery(message)
            } else {
                // Handle the lack of recognized text
                DispatchQueue.main.async {
//                    self.audioPlayer.playSound(false)
                }
            }
            
            // Pause capturing after handling the recognized text
            DispatchQueue.main.async {
                self.pauseCapturing(cancel: cancel)
            }
        }
    }
    
    func cancelSpeak() {
        pauseCapturing(cancel: true)
    }
    
    func repeateActiveSession(startPoint: Int? = 0) {
        if isRepeatingCurrentSession {
            let text = completeResponse.joined()
            var activeTextToRepeat = ""
            
            if text.count >= (startPoint ?? 0) {
                let index = text.index(text.startIndex, offsetBy: startPoint ?? 0)
                activeTextToRepeat = String(text[index...])
                
                if !activeTextToRepeat.isEmpty {
                    textToSpeechConverter.convertTextToSpeech(text: activeTextToRepeat, timeLogger: nil)
                }
            }
            
            if isRequestingOpenAI && isRepeatingCurrentSession {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.repeateActiveSession(startPoint: (startPoint ?? 0) + activeTextToRepeat.count)
                }
            } else {
                isRepeatingCurrentSession = false
            }
        }
    }
    
    func repeate() {
        // Ensure all UI-related updates are done on the main thread.
        DispatchQueue.main.async {
            // If the synthesizer is already speaking, stop it to prevent overlapping speech.
            
            self.textToSpeechConverter.stopSpeech()
            self.isRepeatingCurrentSession = false

            // Set the isPaused flag to false as we're about to speak.
            self._isPaused = false

            // Find the last message from the assistant in the conversation history.
            let lastAssistantMessage = self.conversation.last { $0.role == "assistant" && $0.content != "" }

            // Determine the text to repeat. If no last message is found, use the greeting text.
            let textToRepeat = lastAssistantMessage?.content ?? ""
            
            if !textToRepeat.isEmpty {
                self.textToSpeechConverter.convertTextToSpeech(text: textToRepeat, timeLogger: nil)
            } else if self.isRequestingOpenAI && !self.completeResponse.isEmpty {
                // starting repeateActiveSession
                self.isRepeatingCurrentSession = true
                self.repeateActiveSession(startPoint: 0)
            } else {
                self.textToSpeechConverter.convertTextToSpeech(text: self.greetingText, timeLogger: nil)
            }
        }

        // Operations that can be performed in the background (not UI-related) should be offloaded.
        DispatchQueue.global(qos: .userInitiated).async {
            // Pause the capturing since we're about to replay the message.
            self.pauseCapturing()
        }
    }
    
    @objc func handleTimerDidFire() {
        // Handle the timer firing
        logger.log("The timer in TimerManager has fired.")
        
        reset(feedback: false)
        isTimerDidFired = true
        
        DispatchQueue.main.async {
            self.textToSpeechConverter.convertTextToSpeech(text: self.limitReachedText, timeLogger: nil)
        }
    }
}

// Extension for AVSpeechSynthesizerDelegate

extension SpeechRecognition: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isPlayingWorkItem?.cancel()
        isPlayingWorkItem = DispatchWorkItem { [weak self] in
            if (self?._isPlaying) != nil {
                self?.logger.log("[synthesizeFinish]")
                self?._isPlaying = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: isPlayingWorkItem!)
        
        // TODO: to be used later for automatically resuming capturing when agent is not speaking
        //        resumeListeningTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
        //            logger.log("[speechSynthesizer][didFinish] Starting capturing again")
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
                self?.logger.log("[synthesizeStart]")
                self?._isPlaying = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: isPlayingWorkItem!)
        
        audioPlayer.stopSound()
        pauseCapturing()
        resumeListeningTimer?.invalidate()
    }
}
