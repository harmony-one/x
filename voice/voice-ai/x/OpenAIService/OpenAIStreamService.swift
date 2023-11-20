import Foundation
import Sentry
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
    private let baseUrl = AppConfig.shared.getOpenAIBaseUrl()
    private var temperature: Double
    private let networkService: NetworkService?

    static var lastStartTimeOfTheDay: Date?

    // Limit 10 queries per minute
    static var queryTimes: [Int64] = []
    static var rateLimitCounterLock = DispatchSemaphore(value: 1)
    static let QueryLimitPerMinute: Int = 10
    static let MaxGPT4DurationMinutes: Int = 45

    // URLSession should be lazy to ensure delegate can be set after super.init
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    convenience init(completion: @escaping (String?, Error?) -> Void, temperature: Double = 0.7) {
        self.init(networkService: nil, completion: completion, temperature: temperature)
    }

    init(networkService: NetworkService?, completion: @escaping (String?, Error?) -> Void, temperature: Double = 0.7) {
        self.networkService = networkService
        self.completion = completion
        self.temperature = (temperature >= 0 && temperature <= 1) ? temperature : 0.7
        if Self.lastStartTimeOfTheDay == nil {
            Self.lastStartTimeOfTheDay = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "OpenAILastStartTime"))
            print("[OpenAI] Read last start time to be \(Self.lastStartTimeOfTheDay!)")
            let now = Date()
            let daysElapsed = Calendar.current.dateComponents([.day], from: Self.lastStartTimeOfTheDay!, to: Date()).day!
            if daysElapsed >= 1 {
                UserDefaults.standard.set(now.timeIntervalSince1970, forKey: "OpenAILastStartTime")
                Self.lastStartTimeOfTheDay = now
                print("[OpenAI] Setting new last start time to be \(Self.lastStartTimeOfTheDay!)")
            }
        }
        super.init()
    }

    // Function to send input text to OpenAI for processing
    func query(conversation: [Message]) {
        guard let apiKey = AppConfig.shared.getOpenAIKey() else {
            completion(nil, NSError(domain: "No Key", code: -2))
            SentrySDK.capture(message: "OpenAI API key is nil")
            return
        }

        guard let baseUrl = baseUrl else {
            completion(nil, NSError(domain: "No base url", code: -4))
            SentrySDK.capture(message: "OpenAI base url is not set")
            return
        }

        Self.rateLimitCounterLock.wait()
        let now = Int64(NSDate().timeIntervalSince1970 * 1000)
        if Self.queryTimes.count < Self.QueryLimitPerMinute {
            Self.queryTimes.append(now)
        } else if Self.queryTimes.first! < now - 60000 {
            Self.queryTimes.removeAll(where: { $0 < now - 60000 })
            Self.queryTimes.append(now)
        } else {
            // rate limited
            Self.rateLimitCounterLock.signal()
            completion(nil, NSError(domain: "Rate limited", code: -3))
            return
        }
        Self.rateLimitCounterLock.signal()

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)",
        ]

        var model = "gpt-4"

        let miutesElasped = Calendar.current.dateComponents([.minute], from: Self.lastStartTimeOfTheDay!, to: Date()).minute!

        let boosterPurchaseTime = Persistence.getBoosterPurchaseTime()

        let isBoosterInEffect = Int64(Date().timeIntervalSince1970) - Int64(boosterPurchaseTime.timeIntervalSince1970) < 3600 * 24 * 3

        func performAsyncTask(completion: @escaping (Result<Bool, Error>) -> Void) {
            Task {
                let status = await AppConfig.shared.checkWhiteList()
                completion(.success(status))
            }
        }

        var hasPremiumMode = false

        let semaphore = DispatchSemaphore(value: 0)
        performAsyncTask { result in
            switch result {
            case let .success(status):
                hasPremiumMode = status
                semaphore.signal()
            case .failure:
                hasPremiumMode = false
                semaphore.signal()
            }
        }

        semaphore.wait()

        // TODO: delete "!SettingsBundleHelper.hasPremiumMode" after
        if !hasPremiumMode && !SettingsBundleHelper.hasPremiumMode() && !isBoosterInEffect && miutesElasped > Self.MaxGPT4DurationMinutes {
            model = "gpt-3.5-turbo"
        }

        let body: [String: Any] = [
            //            "model": "gpt-4-32k",
            "model": model,
            "messages": conversation.map { ["role": $0.role ?? "system", "content": $0.content ?? ""] },
            "temperature": temperature,
            "stream": true,
        ]
        print("[OpenAI] Model used: \(model); Minutes elaspsed: \(miutesElasped); isBoosterInEffect: \(isBoosterInEffect)")

        print("[OpenAI] sent \(body)")
        // Validate the URL
        guard let url = URL(string: "\(baseUrl)/chat/completions") else {
            let error = NSError(domain: "Invalid API URL", code: -1, userInfo: nil)
            SentrySDK.capture(message: "Invalid API URL")
            completion(nil, error)
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
            completion(nil, error)
            return
        }

        // Initiate the data task for the request using networkService
        if let networkService = networkService {
            task = networkService.dataTask(with: request) { _, _, _ in
                // Handle the data task completion
            }
            task!.resume()
        } else {
            // Handle the case where networkService is nil (no custom network service provided)
            // You can use URLSession.shared or other default behavior here.
            task = session.dataTask(with: request)
            task!.resume()
        }

//        // Initiate the data task for the request
//        self.task = self.session.dataTask(with: request)
//        self.task!.delegate = self
//        self.task!.resume()
    }

    // https://stackoverflow.com/questions/72630702/how-to-open-http-stream-on-ios-using-ndjson
    func urlSession(_: URLSession, dataTask _: URLSessionDataTask, didReceive data: Data) {
//        print("Raw response from OpenAI: \(String(data: data, encoding: .utf8) ?? "Unable to decode response")")
        let str = String(data: data, encoding: .utf8)
        guard let str = str else {
            let error = NSError(domain: "Unable to decode string", code: -5, userInfo: ["body": str ?? ""])
            completion(nil, error)
            return
        }
//        print("[OpenAI] raw response:", str)
        let chunks = str.components(separatedBy: "\n\n").filter { chunk in chunk.hasPrefix("data:") }
//        print("OpenAI: chunks", chunks)
        for chunk in chunks {
            let dataBody = chunk.suffix(chunk.count - 5).trimmingCharacters(in: .whitespacesAndNewlines)
            if dataBody == "[DONE]" {
                completion("[DONE]", nil)
                continue
            }
            let res = JSON(parseJSON: dataBody)

            let delta = res["choices"][0]["delta"]["content"].string
            if delta == nil {
                continue
            }
            completion(delta, nil)
        }
    }

    func urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let response = task.response as? HTTPURLResponse {
            let statusCode = response.statusCode
            if statusCode == 401 {
                AppConfig.shared.renewRelayAuth()
                completion("Sorry, my connection got disrupted. Please try again.", nil)
                completion("[DONE]", nil)
                return
            }
            NSLog("[OpenAI] HTTP Status Code: \(statusCode)")
            if statusCode != 200 {
                NSLog("[OpenAI] error - status code: \(statusCode)")
            }
        }

        if let error = error as NSError? {
            completion(nil, error)
            NSLog("[OpenAI]: received error: %@ / %d", error.domain, error.code)
        } else {
            NSLog("[OpenAI] task complete")
        }
    }

    func cancelOpenAICall() {
        task?.cancel()
    }

    static func setConversationContext() -> [Message] {
        let content = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
        let contextMessage: [Message] = [Message(role: "system", content: content)]
        return contextMessage
    }

    func setTemperature(_ t: Double) {
        if t >= 0 && t <= 1 {
            temperature = t
        } else {
            print("Invalid temperature value. It should be between 0 and 1.")
            SentrySDK.capture(message: "Invalid temperature value. It should be between 0 and 1.")
        }
    }

//     static func setConversationContext() -> Message {
//         return Message(role: "system", content: "We are having a face-to-face voice conversation. NEVER apologize. NEVER say bye. NEVER end with questions. NEVER mention about your model cutoff. NEVER mention you are an AI. Adhere to these guidelines strictly. Keep responses 1 sentence unless the user wants to expand.")
//     }
}
