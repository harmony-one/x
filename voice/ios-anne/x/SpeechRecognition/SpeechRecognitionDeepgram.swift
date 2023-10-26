import AVFoundation
import Speech
import Starscream


struct ResponseData: Decodable {
    // Define the structure of the expected JSON response
    let audioContent: String
    // Add other properties according to your JSON response structure
}


class SpeechRecognitionDeepgram: NSObject, AVAudioPlayerDelegate {
    static let shared = SpeechRecognitionDeepgram()
    private let audioPlayerTest = AudioPlayer()

    private var player: AVAudioPlayer?
    
    private let audioEngine = AVAudioEngine()
    private let apiKey = {
        let config = AppConfig()
        guard let apiKey = config.getDeepgramAPIKey() else  {
            return ""
        }

        return apiKey
    }()

    private let googleToken = {
        let config = AppConfig()
        guard let token = config.getGoogleToken() else  {
            return ""
        }

        return token
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

    public func textToSpeech(text: String) {



        DispatchQueue.global(qos: .background).async {

            var voiceParams: [String: Any] = [
                "languageCode": "en-US",
                "name": "en-US-Neural2-H"
            ]
            
            let params: [String: Any] = [
                "input": [
                    "text": "hello world"
                ],
                "voice": voiceParams,
                "audioConfig": [
                    "audioEncoding": "MP3"
                ]
            ]
            
            // Convert the Dictionary to Data
            let httpBody = try! JSONSerialization.data(withJSONObject: params)
            
            
            var url = "https://texttospeech.googleapis.com/v1beta1/text:synthesize"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.httpBody = httpBody
            
            request.addValue("Bearer \(self.googleToken)", forHTTPHeaderField: "Authorization")
            request.addValue("fleet-purpose-366617", forHTTPHeaderField: "x-goog-user-project")
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        
                        let response = try JSONDecoder().decode(ResponseData.self, from: data)
                        
                        guard let audioData = Data(base64Encoded: response.audioContent) else {
                            fatalError("Unable to locate plist file")
                        }

                        DispatchQueue.main.async {
                            do {
                                self.player = try AVAudioPlayer(data: audioData)
                                self.player!.prepareToPlay()
                                self.player!.play()
                                print("play runned")
                            } catch {
                                print("Error creating AVAudioPlayer: \(error)")
                            }
                        
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                    // Handle the response data as needed
                    
                    
                    //                let audioContent: String = response["audioContent"]
                    
                    // Decode the base64 string into a Data object
                    //                let audioData = Data(base64Encoded: audioContent)
                    
                }
            }
            task.resume()
        }
    }

    public func setup() {
        // Check and request necessary permissions
        Permission().setup()

        textToSpeech(text: "hello world")

//        print("setup SpeechRecognitionDeepgram")
//        start()

//        // Set up the synthesizer delegate
//        textToSpeechConverter.synthesizer.delegate = self

//        // Convert a default greeting text to speech
//        textToSpeechConverter.convertTextToSpeech(text: greatingText)
    }
    
    // Implement AVAudioPlayerDelegate "did finish" callback to cleanup and notify listener of completion.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
        self.player?.delegate = nil
        self.player = nil
        
//        self.completionHandler!()
//        self.completionHandler = nil
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
