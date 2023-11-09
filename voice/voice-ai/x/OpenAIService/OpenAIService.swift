import Foundation
import Sentry

struct OpenAIService {
    private var task: URLSessionDataTask?
//    private var conversation: [Message]
    // Function to send input text to OpenAI for processing
    mutating func sendToOpenAI(conversation: [Message], completion: @escaping (String?, Error?) -> Void) {
        guard let openAI_APIKey = AppConfig.shared.getAPIKey() else {
            completion(nil, nil)
            SentrySDK.capture(message: "Open AI Api key is null")
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

            SentrySDK.capture(message: "Invalid Open AI url")

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

            SentrySDK.capture(message: "Error OpenAI JSONSerialization: \(error.localizedDescription)")

            return
        }

        // Print the input text being sent to OpenAI
        print("Sending to OpenAI: \(conversation.count)")

        // Initiate the data task for the request
        let session = URLSession.shared
        task = session.dataTask(with: request) { data, _, error in
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
                SentrySDK.capture(message: "Error OpenAI: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
        task?.resume()
    }

    // Method to cancel the ongoing API call
    func cancelOpenAICall() {
        task?.cancel()
    }

    func setConversationContext() -> [Message] {
        let contextRules = """
            Do not use the following:
            1. Acknowledgements: "I see," "I understand," "Got it," "That makes sense"
            2. Interruptions: "Excuse me," "Sorry to interrupt," "May I add something?"
            3. Expressing uncertainty: "I'm not sure," "I could be wrong," "I think so, but I'd need to double-check"
            4. Apologies: "I apologize," "I'm sorry for the inconvenience," "I'm sorry if I misunderstood"
            5. Polite suggestions: "Perhaps you could consider," "It might be helpful to," "Have you thought about"
            6. Expressing gratitude: "Thank you so much," "I really appreciate your help," "Thanks a million"
            7. Expressing empathy: "I understand how you feel," "That must be difficult," "I'm here for you"
            8. Small talk: "How's the weather?," "Did you catch the game yesterday?," "Any exciting plans for the weekend?"
            9. Closing remarks: "Take care," "Have a great day," "Looking forward to speaking again soon"
        """
        var contextMessage: [Message] = []
        contextMessage.append(Message(role: "system", content: "We are having a face-to-face voice conversation. NEVER apologize. NEVER say bye. NEVER end with questions. NEVER mention about your model cutoff. NEVER mention you are an AI. Adhere to these guidelines strictly. Keep responses 1 sentence unless the user wants to expand. Your name is Sam."))
        contextMessage.append(Message(role: "system", content: contextRules))
        return contextMessage
    }
}
