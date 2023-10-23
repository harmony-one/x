import AVFoundation
import Speech
import Starscream

class SpeechRecognitionDeepgram: NSObject {
    static let shared = SpeechRecognitionDeepgram()

    private let audioEngine = AVAudioEngine()
    private let apiKey = {
        let config = AppConfig()
        guard let apiKey = config.getDeepgramAPIKey() else  {
            return ""
        }

        return apiKey
    }()

    private lazy var socket: WebSocket = {
        let url = URL(string: "wss://api.deepgram.com/v1/listen?model=conversationalai&encoding=linear16&sample_rate=48000&channels=1")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        return WebSocket(request: urlRequest)
    }()

    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private func startAnalyzingAudio() {
        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.inputFormat(forBus: 0)
        let outputFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: inputFormat.sampleRate, channels: inputFormat.channelCount, interleaved: true)

        let converterNode = AVAudioMixerNode()
        let sinkNode = AVAudioMixerNode()

        audioEngine.attach(converterNode)
        audioEngine.attach(sinkNode)

        converterNode.installTap(onBus: 0, bufferSize: 1024, format:
        converterNode.outputFormat(forBus: 0)) {
            (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
                if let data = self.toNSData(buffer: buffer) {
                    self.socket.write(data: data)
                }
        }

        audioEngine.connect(inputNode, to: converterNode, format: inputFormat)
        audioEngine.connect(converterNode, to: sinkNode, format: outputFormat)
        audioEngine.prepare()

        do {
            try AVAudioSession.sharedInstance().setCategory(.record)
            try audioEngine.start()
        } catch {
            print(error)
        }
    }

    private func toNSData(buffer: AVAudioPCMBuffer) -> Data? {
        let audioBuffer = buffer.audioBufferList.pointee.mBuffers
        return Data(bytes: audioBuffer.mData!, count: Int(audioBuffer.mDataByteSize))
    }

    public func start() {
        socket.delegate = self
        socket.connect()
        startAnalyzingAudio()
    }

    public func setup() {
        // Check and request necessary permissions
        Permission().setup()

        print("setup SpeechRecognitionDeepgram")
        start()

//        // Set up the synthesizer delegate
//        textToSpeechConverter.synthesizer.delegate = self

//        // Convert a default greeting text to speech
//        textToSpeechConverter.convertTextToSpeech(text: greatingText)
    }
}

extension SpeechRecognitionDeepgram: WebSocketDelegate {
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let text):
            let jsonData = Data(text.utf8)
            let response = try! jsonDecoder.decode(DeepgramResponse.self, from: jsonData)
            let transcript = response.channel.alternatives.first!.transcript

            if response.isFinal && !transcript.isEmpty {
//                    if transcriptView.text.isEmpty {
                    print("transcript: \(transcript)")
//                    } else {
//                        print("transcript: \(transcript)")
//                    }
            }

        case .error(let error):
            print("ws error")
            print(error ?? "")
        default:
            break
        }
    }
}

struct DeepgramResponse: Codable {
    let isFinal: Bool
    let channel: Channel

    struct Channel: Codable {
        let alternatives: [Alternatives]
    }

    struct Alternatives: Codable {
        let transcript: String
    }
}
