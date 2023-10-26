import AVFoundation
import Collections
import Speech
import SwiftyJSON

struct DeepgramControlMessage: Codable {
    var type: String
}

struct ASRResult: Codable {
    var isFinal: Bool
    var text: String
    var start: Double
    var duration: Double
    var confidence: Double
}

enum ASRError: Error {
    case ConnectionNotActive
    case CannotKeepAlive
}

class DeepgramASR: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate, URLSessionWebSocketDelegate {
    // MARK: - Properties

    private var wsTask: URLSessionWebSocketTask?
    private var wsConnected = false
    private var urlSession: URLSession?
    private var keepAliveTimer: Timer?
    
    var captureSession = AVCaptureSession()
    var capturing = false
    private var audioDataOutput = AVCaptureAudioDataOutput()
    
    private var isAudioSessionSetup = false
    static let shared = DeepgramASR()
    
    private var results = Deque<ASRResult>()
    private let resultsLock = DispatchSemaphore(value: 1)
    
    // TODO: use more structured class, one that describes token compositions and confidence
    private var responses = Deque<String>()
    
    let apiKey = AppConfig().getDeepgramKey()!
    
    let tts = AppleTTS()
    private let greating = "Hello!"
    var resumeListeningTimer: Timer? = nil
    
    // IMPORTANT: must use valid query parameters and values, otherwise socket send / receive would fail, and no reason would be given for debugging
    func buildWsUrl() -> String {
        let queryItems = [
            URLQueryItem(name: "model", value: "general"),
            URLQueryItem(name: "tier", value: "enhanced"),
//            URLQueryItem(name: "model", value: "conversationalai"), // accuracy seems to be much lower. Not recommended
            URLQueryItem(name: "version", value: "latest"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "punctuate", value: "true"),
            URLQueryItem(name: "profanity_filter", value: "false"),
            URLQueryItem(name: "diarize", value: "false"),
            URLQueryItem(name: "smart_format", value: "true"),
            URLQueryItem(name: "filler_words", value: "false"),
            URLQueryItem(name: "multichannel", value: "false"),
            URLQueryItem(name: "alternatives", value: "1"), // increase to 5-10 later when we implement something at client-side to evaluate quality of transcript
            URLQueryItem(name: "interim_results", value: "false"), // change to true later when we implement something to let agent correct or enhance earlier response
            URLQueryItem(name: "endpointing", value: "250"), // deepgram default is 10ms, might be too short
            URLQueryItem(name: "channels", value: "1"),
//            URLQueryItem(name: "tag", value: "sam"), // not needed until we have multiple apps and need to audit api call logs
            URLQueryItem(name: "encoding", value: "linear16"), // to use later, see comments in setupAudio
            URLQueryItem(name: "sample_rate", value: "44100"), // to use later, see comments in setupAudio
        ]
        var urlComps = URLComponents(string: "wss://api.deepgram.com/v1/listen")!
        urlComps.queryItems = queryItems
        return urlComps.string!
//        return "wss://api.deepgram.com/v1/listen?model=conversationalai&encoding=linear16&sample_rate=44100&channels=1"
    }

    func disconnect() {
        self.wsConnected = false
        wsTask?.cancel()
    }

    func sendKeepAlive() async throws {
        guard wsTask !== nil else {
            throw ASRError.ConnectionNotActive
        }
        let keepAliveMessage = "{\"type\":\"KeepAlive\"}"
        print("Sending \(keepAliveMessage)")
        try await wsTask!.send(.string(keepAliveMessage))
    }
    
    func startKeepAliveTimer() {
        keepAliveTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            Task {
                do {
                    try await self.sendKeepAlive()
                } catch {
                    print("WSError: on sending keep alive: ", error)
                }
            }
        }
    }
    
    func stopKeepAliveTimer() {
        keepAliveTimer?.invalidate()
    }
    
    func setup() {
        Permission().setup()
        self.tts.synthesizer.delegate = self
        start()
        tts.convertTextToSpeech(text: greating)
    }
    
    func setupWs() {
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let urlString = buildWsUrl()
        print("urlString=\(urlString)")
//        let url = URL(string: "wss://api.deepgram.com/v1/listen?model=conversationalai&encoding=linear16&sample_rate=44100&channels=1")!
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        wsTask = urlSession?.webSocketTask(with: request)
        wsTask?.resume()
        receiveMessage()
        startKeepAliveTimer()
    }
    
    // MARK: - Audio Session Management
    
    func setupAudio() {
        if !isAudioSessionSetup {
            do {
                captureSession = AVCaptureSession()
                guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
//                print("AV: audioDevice=\(audioDevice)")
                let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
                audioDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInitiated))
                // API only available on macOS, so custom encoder might be needed. See also https://stackoverflow.com/questions/41152448/is-audiosettings-property-missing-in-avcaptureaudiodataoutput-in-the-swift-heade
                // audioDataOutput.audioSettings = []
                
                // example audio settings https://stackoverflow.com/questions/37287481/avcapturedevice-capture-wav-audio-with-specific-sampling-frequency (use https://okaxaki.github.io/objc2swift/online.html to convert to Swift)
                // Also consult source code in AVFAudio framework (AVAudioSettings.h) and CoreAudioTypes framework for how to write the settings
                // We should be fine - deepgram API seems to be capable of auto-detecting encoding, since encoding and sample_rate parameters in ws connection string is optional. See https://developers.deepgram.com/reference/streaming
                // I believe default encoding on iOS should be lpcm (LinearPCM), a.k.a linear16. See also https://developers.deepgram.com/docs/encoding for supported audio encoding
                // See Google's ASR documentation for some explanations of what the encodings are https://cloud.google.com/speech-to-text/docs/encoding
                
                if captureSession.canAddOutput(audioDataOutput) {
                    captureSession.addOutput(audioDataOutput)
                }
                
                isAudioSessionSetup = true
                print("AV: Setup complete")
            } catch {
                print("AVError: cannot set up audio session: \(error.localizedDescription)")
            }
        }
    }
    
    func bufferToData(buf: CMSampleBuffer) -> Data? {
        let blockBuf = CMSampleBufferGetDataBuffer(buf)
        guard blockBuf != nil else {
            return nil
        }
        let blockLen = CMBlockBufferGetDataLength(blockBuf!)
        var blockData = [UInt8](repeating: 0, count: blockLen)
        let status = CMBlockBufferCopyDataBytes(blockBuf!, atOffset: 0, dataLength: blockLen, destination: &blockData)
        guard status == noErr else {
            return nil
        }
        let data = Data(bytes: blockData, count: blockLen)
        return data
    }

    // MARK: - Speech Recognition

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard self.capturing else {
//            print("ignoring captured data because self.capturing=\(self.capturing)")
            return
        }
        // Note: need to chop buffer to make sure it is between 20ms to 250ms of audio, per https://developers.deepgram.com/reference/streaming
        let duration = CMSampleBufferGetDuration(sampleBuffer).seconds
        if duration < 0.02 || duration > 0.25 {
            print("Warning: sample buffer size out of bound (got \(duration) seconds)")
        }
//        let format = CMSampleBufferGetFormatDescription(sampleBuffer)
//        print("Received audio buffer duration(seconds)=\(duration); sampleRate=\(format?.audioStreamBasicDescription?.mSampleRate); format=\(format?.audioStreamBasicDescription?.mFormatID)")
        let data = bufferToData(buf: sampleBuffer)
        guard data != nil else {
            print("Error: unable to build data from buffer")
            return
        }
        let message = URLSessionWebSocketTask.Message.data(data!)
        wsTask?.send(message) { error in
            if let error = error {
                print("WSError: on sending data to Deepgram", error)
            }
        }
        // Note: get metadata of the audio data this way: https://stackoverflow.com/questions/8049999/audio-cmsamplebuffer-format?rq=4
    }
    
    func receiveMessage() {
        wsTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                // TODO: see also error handling https://developers.deepgram.com/reference/streaming
                print("WSError: on receiving message: \(error)")
                self?.disconnect()
                return
            case .success(let message):
                switch message {
                case .string(let text):
                    let res = JSON(parseJSON: text)
                    let transcript = res["channel"]["alternatives"][0]["transcript"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
                    let confidence = res["channel"]["alternatives"][0]["confidence"].doubleValue
                    let isFinal = res["is_final"].boolValue
                    let start = res["start"].doubleValue
                    let duration = res["start"].doubleValue
                    let result = ASRResult(isFinal: isFinal, text: transcript, start: start, duration: duration, confidence: confidence)
                    if transcript.count > 0 {
                        self?.resultsLock.wait()
                        self?.results.append(result)
                        self?.resultsLock.signal()
                        print("Received parsed transcript: \(transcript) ; isFinal=\(isFinal)")
                        if isFinal {
                            self?.tryConsumeAllResultsAndMakeQuery()
                        }
                    }
                case .data(let data):
                    print("Received unexpected binary message: \(data)")
                @unknown default:
                    break
                }
            }
            self?.receiveMessage()
        }
    }

    func start() {
        print("ASR: start")
        setupWs()
        setupAudio()
        captureSession.startRunning()
    }
    
    // MARK: - Sentence Handling
    
    private var endOfSentencePunctuations = [Character("."), Character("?"), Character("!")]
    private var speechDelimitingPunctuations = [Character("."), Character("?"), Character("!"), Character(","), Character("-")]
    
    func tryConsumeSingleSentenceAndMakeQuery() {
        resultsLock.wait()
        
        let text = unsafeConsumeResultsToBuildSingleSentence()
        resultsLock.signal()
        makeQuery(text)
    }
    
    func unsafeConsumeResultsToBuildSingleSentence() -> String {
        var text = ""
        while text.last == nil || !endOfSentencePunctuations.contains(text.last!) {
            let h = results.popFirst()
            if h == nil {
                break
            }
            text += h!.text
        }
        return text
    }
    
    func tryConsumeAllResultsAndMakeQuery() {
        resultsLock.wait()
        let text = unsafeConsumeAllResults()
        resultsLock.signal()
        makeQuery(text)
    }
    
    func unsafeConsumeAllResults() -> String {
        var text = ""
        while results.count > 0 {
            text += results.popFirst()!.text + " "
        }
        return text
    }

    func makeQuery(_ text: String) {
        var buf = [String]()
        func flushBuf() {
            let response = buf.joined()
            self.tts.convertTextToSpeech(text: response)
            self.capturing = false
            print("Stopped capturing")
            if self.tts.synthesizer.delegate == nil {
                self.tts.synthesizer.delegate = self
            }
            self.responses.append(response)
            buf.removeAll()
        }
        let service = OpenAIService { res, err in
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
    
    func pause() {
        self.capturing = false
//        self.tts.pauseSpeech()
    }
    
    func continueSpeech() {
        self.capturing = true
//        self.tts.continueSpeech()
    }
    
    func cut() {
        self.tts.stopSpeech()
    }
    
    func reset() {
        // “Reset” means the user abandons the current conversation for a new chat session with Sam.
        self.tts.stopSpeech()
        self.capturing = false
        self.disconnect()
        self.resultsLock.wait()
        self.results.removeAll()
        self.resultsLock.signal()
        self.tts.synthesizer.delegate = nil
        self.start()
        self.capturing = true
    }
    
    func speak() {
        // ”Speak” allows the user to force Sam keep listening while holding down the button.
        // no action needed
    }
    
    func repeate() {
        self.capturing = false
        if let lastResponse = responses.last {
            self.tts.convertTextToSpeech(text: lastResponse)
        } else {
            self.tts.convertTextToSpeech(text: "Nothing to repeat")
        }
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        let p = `protocol` ?? ""
        print("WS: connected, protocol=\(p)")
        wsConnected = true
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        var r = ""
        if let d = reason {
            r = String(data: d, encoding: .utf8) ?? ""
        }
        wsConnected = false
        print("WS: Disconnected. Code: \(closeCode) Reason \(r)")
    }
}

extension DeepgramASR: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        resumeListeningTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            print("Starting capturing again")
            self.capturing = true
        }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.capturing = false
        resumeListeningTimer?.invalidate()
    }
}
