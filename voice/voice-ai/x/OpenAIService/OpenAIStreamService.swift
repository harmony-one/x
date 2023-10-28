//
//  OpenAIExService.swift
//  Voice AI
//
//  Created by Yuriy Menkov on 27.10.2023.
//

import Foundation
import SwiftyJSON

let config = AppConfig()

class OpenAIStreamService: NSObject, URLSessionDataDelegate {
    private var session: URLSession
    private var completion: (String?, Error?) -> Void
    private let apiKey = config.getAPIKey()

    init(completion: @escaping (String?, Error?) -> Void) {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
        self.completion = completion
        super.init()
    }

    // Function to send input text to OpenAI for processing
    func query(prompt: String) {
        guard self.apiKey != nil else {
            self.completion(nil, NSError(domain: "No Key", code: -2))
            return
        }

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey!)"
        ]

        let body: [String: Any] = [
            "model": "gpt-4-32k",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "temperature": 0.5, // TODO: make temperature adjustable by init
            "stream": true
        ]

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

        // Print the input text being sent to OpenAI
        print("Sending to OpenAI: \(prompt)")

        // Initiate the data task for the request
        let task = self.session.dataTask(with: request)
        task.delegate = self
        task.resume()
    }

    // https://stackoverflow.com/questions/72630702/how-to-open-http-stream-on-ios-using-ndjson
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        print("Raw response from OpenAI: \(String(data: data, encoding: .utf8) ?? "Unable to decode response")")
        let str = String(data: data, encoding: .utf8)
        guard let str=str else {
            let error = NSError(domain: "Unable to decode string", code: -2, userInfo: ["body": str ?? ""])
            self.completion(nil, error)
            return
        }
//        print("OpenAI: raw response: ", str)
        let chunks = str.components(separatedBy: "\n\n").filter{chunk in chunk.hasPrefix("data:")}
//        print("OpenAI: chunks", chunks)
        for chunk in chunks {
            let dataBody = chunk.suffix(chunk.count - 5).trimmingCharacters(in: .whitespacesAndNewlines)
            if dataBody == "[DONE]" {
                continue
            }
            let res = JSON(parseJSON: dataBody)

            let delta = res["choices"][0]["delta"]["content"].string
            self.completion(delta, nil)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error as NSError? {
            self.completion(nil, error)
            NSLog("OpenAI: received error: %@ / %d", error.domain, error.code)
        } else {
            NSLog("OpenAI: task complete")
        }
    }
}

