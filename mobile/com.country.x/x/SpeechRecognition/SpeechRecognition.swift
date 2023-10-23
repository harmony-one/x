//
//  SpeechRecognition.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 17/10/23.
//

import AVFoundation
import Speech
import Collections

struct DeepgramControlMessage: Codable {
    var type: String
}

enum ASRError: Error {
    case ConnectionNotActive
    case CannotKeepAlive
}

class SpeechRecognition: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate {
    // MARK: - Properties

    var wsTask: URLSessionWebSocketTask?
    let urlSession = URLSession(configuration: .default)
    private var keepAliveTimer: Timer?
    
    var captureSession = AVCaptureSession()
    private var audioDataOutput = AVCaptureAudioDataOutput()
    
    private var isAudioSessionSetup = false
    static let shared = SpeechRecognition()
    
    private var texts = Deque<String>()

    func buildWsUrl() -> String {
        let queryItems = [
//            URLQueryItem(name: "model", value: "general"),
//            URLQueryItem(name: "tier", value: "enhanced"),
            URLQueryItem(name: "model", value: "conversationalai"),
            
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
            URLQueryItem(name: "endpointing", value: "100"), // deepgram default is 10ms, might be too short
            URLQueryItem(name: "channels", value: "1"),
//            URLQueryItem(name: "tag", value: "sam"), // not needed until we have multiple apps and need to audit api call logs
//            URLQueryItem(name: "encoding", value: "lpcm"), // to use later, see comments in setupAudio
//            URLQueryItem(name: "sample_rate", value: "16000"), // to use later, see comments in setupAudio
        ]
        var urlComps = URLComponents(string: "wss://api.deepgram.com/v1/listen")!
        urlComps.queryItems = queryItems
        return urlComps.string!
    }
    func sendKeepAlive() async throws {
        guard wsTask !== nil else {
            throw ASRError.ConnectionNotActive
        }
        let keepAliveMessage = String(data: try! JSONEncoder().encode(DeepgramControlMessage(type: "KeepAlive")), encoding: .utf8)!
        let message = URLSessionWebSocketTask.Message.string(keepAliveMessage)
        try await wsTask!.send(message)
    }
    
    func setup() {
        Permission().setup()
        self.setupWs()
    }
    
    func setupWs() {
        let url = URL(string: self.buildWsUrl())!
        wsTask = urlSession.webSocketTask(with: url)
        wsTask?.resume()
        Task {
            do {
                try await sendKeepAlive()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Audio Session Management
    
    func setupAudio() {
        if !isAudioSessionSetup {
            do {
                captureSession = AVCaptureSession()
                guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
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
            } catch {
                print("Error setting up audio session: \(error.localizedDescription)")
            }
        }
    }
    
    func bufferToData(buf: CMSampleBuffer) -> Data? {
        let blockBuf = CMSampleBufferGetDataBuffer(buf)
        let blockLen = CMBlockBufferGetDataLength(blockBuf!)
        var blockData  = [UInt8](repeating: 0, count: blockLen)
        let status = CMBlockBufferCopyDataBytes(blockBuf!, atOffset: 0, dataLength: blockLen, destination: &blockData)
        guard status == noErr else {
            return nil
        }
        let data = Data(bytes: blockData, count: blockLen)
        return data
    }
    // MARK: - Speech Recognition
    func captureOutput(
        _ output: AVCaptureOutput,
        sampleBuffer: CMSampleBuffer,
        connection: AVCaptureConnection
    ){
        // TODO: send data to deepgram, need to chop buffer to make sure it is between 20ms to 250ms of audio, per https://developers.deepgram.com/reference/streaming
        let duration = CMSampleBufferGetDuration(sampleBuffer).seconds
        if duration < 0.02 || duration > 0.25 {
            print("Warning: sample buffer size out of bound (got \(duration) seconds)")
        }
        let singleBuf = sampleBuffer.singleSampleBuffers()
        singleBuf.split(separator: <#T##CMSampleBuffer#>)
        let data = self.bufferToData(buf: sampleBuffer)
        guard data != nil else {
            print("Error: unable to build data from buffer")
            return
        }
        let message = URLSessionWebSocketTask.Message.data(data!)
        wsTask?.send(message){error in
            if let error = error{
                print("Error sending data to Deepgram", error)
            }
        }
        // Note: get metadata of the audio data this way: https://stackoverflow.com/questions/8049999/audio-cmsamplebuffer-format?rq=4
        
    }
    
    func receiveMessage(){
        wsTask?.receive{result in
            switch result {
            case .failure(let error):
                // TODO: see also error handling https://developers.deepgram.com/reference/streaming
                print("Error receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    // TODO: parse response, per https://developers.deepgram.com/reference/streaming
                    print("Received text message: \(text)")
                    
                case .data(let data):
                    // Should not happen
                    print("Received unexpected binary message: \(data)")
                    
                 @unknown default:
                     fatalError()
                 }
             }
            self.receiveMessage()
        }
    }
    func start() {
        print("ASR: start")
        setupAudio()
        
        captureSession.startRunning()
        keepAliveTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            Task {
                do {
                    try await self.sendKeepAlive()
                } catch {
                    print("Error sending keep alive: ", error)
                }
            }
        }
        Task{
            self.receiveMessage()
        }

    }
    
    // MARK: - Sentence Handling
    
    func handleEndOfSentence(_ recognizedText: String) {
        // Add your logic here for actions to be performed at the end of the user's sentence.
        // For example, you can handle UI updates or other necessary tasks.
        // ...
//        print("handleEndOfSentence -- method called")
//        recognitionTask?.finish()
//        recognitionTask?.cancel()
//        recognitionTask = nil
//        recognitionRequest?.endAudio()
//        audioEngine.stop()
        
        OpenAIService().sendToOpenAI(inputText: recognizedText) { aiResponse, _ in
//            guard let aiResponse = aiResponse else {
//                self.textToSpeechConverter.convertTextToSpeech(text: "An issue is currently preventing the action. Please try again after some time.")
//                return
//            }
//            self.setupAudioSession()
//            self.textToSpeechConverter.convertTextToSpeech(text: aiResponse)
//            self.addObject(aiResponse)
        }
    }
    
    // Method to add a new response to the array, managing the size
    func addObject(_ newObject: String) {
//        if aiResponseArray.count < maxArraySize {
//            aiResponseArray.append(newObject)
//        } else {
//            aiResponseArray.removeFirst()
//            aiResponseArray.append(newObject)
//        }
    }
    
    func pause() {
        // “Pause” means holding off Sam’s speaking or listening until Theo presses the button again.
//        print("pause -- method called")
//        self.textToSpeechConverter.pauseSpeech()
    }
    
    func continueSpeech() {
//        print("continueSpeech -- method called")
//        self.textToSpeechConverter.continueSpeech()
    }
    
    func cut() {
        //  ”Cut” means to interrupt stop play audio rambling and stop any further response
//        print("cut -- method called")
//        self.textToSpeechConverter.stopSpeech()
    }
    
    func reset() {
        // “Reset” means Theo abandons the current conversation for a new chat session with Sam.
//        print("reset -- method called")
//        self.aiResponseArray.removeAll()
//        self.textToSpeechConverter.stopSpeech()
//        self.recognitionTask?.finish()
//        self.recognitionTask?.cancel()
//        self.recognitionTask = nil
//        self.isAudioSessionSetup = false
//        
//        if audioEngine.inputNode.numberOfInputs > 0 {
//            audioEngine.inputNode.removeTap(onBus: 0)
//        }
    }
    
    func speak() {
        // ”Speak” allows Theo to force Sam keep listening while holding down the button.
//        self.aiResponseArray.removeAll()
//        self.textToSpeechConverter.stopSpeech()
    }
    
    func repeate() {
//        self.setupAudioSession()
        // “Repeat” allows Theo to hear Sam’s saying from 10 seconds ago.
//        audioEngine.inputNode.removeTap(onBus: 0)
//        self.textToSpeechConverter.convertTextToSpeech(text: aiResponseArray.last ?? "There are no prior conversions to repeat.")
    }
}

extension SpeechRecognition: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        print("speechSynthesizer -didFinish - method called")
//        self.setupAudioSession()
//        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        self.startSpeechRecognition()
    }
}
