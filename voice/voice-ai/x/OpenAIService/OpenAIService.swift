//
//  OpenAIService.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 18/10/23.
//

import Foundation

struct OpenAIServiceDeprecated {
    private var task: URLSessionDataTask?
//    private var conversation: [Message]
    // Function to send input text to OpenAI for processing
    mutating func sendToOpenAI(conversation: [Message], completion: @escaping (String?, Error?) -> Void) {
        
        let config = AppConfig()
        guard let openAI_APIKey = config.getAPIKey() else  {
            completion(nil, nil)
            return
        }
        
        // Define headers for the HTTP request
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(openAI_APIKey)" // Replace openAI_APIKey with your actual API key
        ]

        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": conversation.map { ["role": $0.role, "content": $0.content] },
            "temperature": 0.5
        ]

        // Validate the URL
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            let error = NSError(domain: "Invalid URL", code: -1, userInfo: nil)
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

        // Print the input text being sent to OpenAI
        print("Sending to OpenAI: \(conversation.count)")

        // Initiate the data task for the request
        let session = URLSession.shared
        self.task = session.dataTask(with: request) { data, response, error in
            // Check for networking errors
            if let error = error {
                completion(nil, error)
                return
            }

            // Ensure data is not nil
            guard let data = data else {
                let dataNilError = NSError(domain: "Data is nil", code: -1, userInfo: nil)
                completion(nil, dataNilError)
                return
            }

            // Print the raw response from OpenAI
            print("Raw response from OpenAI: \(String(data: data, encoding: .utf8) ?? "Unable to decode response")")

            // Decode the JSON response
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(OpenAIResponse.self, from: data)
                if let aitext = result.choices?.first?.message?.content?.trimmingCharacters(in: .whitespacesAndNewlines) {
//                    conversation.append(Message(role:"system", content: aitext))
                    completion(aitext, nil)
                } else {
                    let invalidResponseError = NSError(domain: "Invalid response", code: -1, userInfo: nil)
                    completion(nil, invalidResponseError)
                }
            } catch {
                completion(nil, error)
            }
        }
        task?.resume()
    }
    
    // Method to cancel the ongoing API call
    func cancelOpenAICall() {
        task?.cancel()
    }
    
    func setConversationContext() -> Message {
        return Message(role: "system", content:"We are having a face-to-face voice conversation. NEVER apologize. NEVER say bye. NEVER end with questions. NEVER mention about your model cutoff. NEVER mention you are an AI. Adhere to these guidelines strictly. Keep responses 1 sentence unless the user wants to expand.")
    }
}
