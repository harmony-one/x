import Foundation
import SwiftyJSON

protocol NetworkService {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

class OpenAIStreamService: NSObject, URLSessionDataDelegate {
    private var task: URLSessionDataTask?
    private var completion: (String?, Error?) -> Void
    private let apiKey = AppConfig.shared.getAPIKey()
    private var temperature: Double
    private let networkService: NetworkService?
    
    // URLSession should be lazy to ensure delegate can be set after super.init
        lazy private var session: URLSession = {
            let configuration = URLSessionConfiguration.default
            return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        }()
    
    init(completion: @escaping (String?, Error?) -> Void, temperature: Double = 0.7) {
        self.networkService = nil
        self.completion = completion
        self.temperature = (temperature >= 0 && temperature <= 1) ? temperature : 0.7
        super.init()
    }
    
    init(networkService: NetworkService?, completion: @escaping (String?, Error?) -> Void, temperature: Double = 0.7) {
        self.networkService = networkService
        self.completion = completion
        self.temperature = (temperature >= 0 && temperature <= 1) ? temperature : 0.7
        super.init()
    }
    
    // Function to send input text to OpenAI for processing
    func query(conversation: [Message]) {
        guard self.apiKey != nil else {
            self.completion(nil, NSError(domain: "No Key", code: -2))
            return
        }

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey!)"
        ]

        let body: [String: Any] = [
            //            "model": "gpt-4-32k",
            "model": "gpt-4",
            "messages": conversation.map { ["role": $0.role ?? "system", "content": $0.content ?? ""] },
            "temperature": self.temperature,
            "stream": true
        ]

       print("[OpenAI] sent \(body)")
        // Validate the URL
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            let error = NSError(domain: "Invalid API URL", code: -1, userInfo: nil)
            self.completion(nil, error)
            return
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        // Try to serialize the body as JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            self.completion(nil, error)
            return
        }

        // Initiate the data task for the request using networkService
        if let networkService = networkService {
            self.task = networkService.dataTask(with: request) { data, response, error in
                // Handle the data task completion
            }
            self.task!.resume()
        } else {
            // Handle the case where networkService is nil (no custom network service provided)
            // You can use URLSession.shared or other default behavior here.
            self.task = self.session.dataTask(with: request)
            self.task!.resume()
        }
        
        
//        // Initiate the data task for the request
//        self.task = self.session.dataTask(with: request)
//        self.task!.delegate = self
//        self.task!.resume()
    }

    // https://stackoverflow.com/questions/72630702/how-to-open-http-stream-on-ios-using-ndjson
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        print("Raw response from OpenAI: \(String(data: data, encoding: .utf8) ?? "Unable to decode response")")
        let str = String(data: data, encoding: .utf8)
        guard let str = str else {
            let error = NSError(domain: "Unable to decode string", code: -2, userInfo: ["body": str ?? ""])
            self.completion(nil, error)
            return
        }
       print("OpenAI: raw response: ", str)
        let chunks = str.components(separatedBy: "\n\n").filter { chunk in chunk.hasPrefix("data:") }
//        print("OpenAI: chunks", chunks)
        for chunk in chunks {
            let dataBody = chunk.suffix(chunk.count - 5).trimmingCharacters(in: .whitespacesAndNewlines)
            if dataBody == "[DONE]" {
                self.completion("[DONE]", nil)
                continue
            }
            let res = JSON(parseJSON: dataBody)

            let delta = res["choices"][0]["delta"]["content"].string

            self.completion(delta, nil)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let response = task.response as? HTTPURLResponse {
            let statusCode = response.statusCode
            NSLog("OpenAI: HTTP Status Code: \(statusCode)")
            if statusCode != 200 {
                NSLog("OpenAI: error")
            }
        }
        
        
        if let error = error as NSError? {
            self.completion(nil, error)
            NSLog("OpenAI: received error: %@ / %d", error.domain, error.code)
        } else {
            NSLog("OpenAI: task complete")
        }
    }

    func cancelOpenAICall() {
        self.task?.cancel()
    }
    
    static func setConversationContext() -> [Message] {
        let contextMessage: [Message] =
            [Message(role: "system", content: """
                     Your name is Voice AI, within the 'Voice AI' app that allows users to talk face-to-face with GPT-4. You are developed by the 'x dot country team'. NEVER apologize. NEVER end with questions. NEVER mention your model cutoff. NEVER mention that you are an AI. Be concise. Adhere to these guidelines strictly.

                     6 buttons:

                     New Session: User starts a fresh new session with you.

                     Tap To Speak: User taps to speak to the app and then taps again to send the audio to you.

                     Surprise Me: Provides a random fact.

                     Press & Hold: User press and hold while they are talking to send their input to you.

                     Repeat Last: Replays last message you sent.

                     Pause / Play: Pause and play app audio output.

                     Whether the user would like a tutor for high-school exams, a professor for any Wikipedia topic, or a language buddy, your goal is to satisfy the needs of the user as they engage with a super-intelligence, you.
                     """)]
        return contextMessage
    }
  
    func setTemperature(_ t: Double) {
        if t >= 0 && t <= 1 {
            self.temperature = t
        } else {
            print("Invalid temperature value. It should be between 0 and 1.")
        }
    }

//     static func setConversationContext() -> Message {
//         return Message(role: "system", content: "We are having a face-to-face voice conversation. NEVER apologize. NEVER say bye. NEVER end with questions. NEVER mention about your model cutoff. NEVER mention you are an AI. Adhere to these guidelines strictly. Keep responses 1 sentence unless the user wants to expand.")
//     }
}
