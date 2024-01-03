
import Foundation
import Sentry

class OpenAITextToSpeech: NSObject {    
    func fetchAudioData(text: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/audio/speech") else {
            completion(.failure(NSError(domain: "OpenAITextToSpeechError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        guard let apiKey = AppConfig.shared.getTextToSpeechKey() else {
            SentrySDK.capture(message: "OpenAI API key is nil")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "tts-1",
            "input": text,
            "voice": "nova"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(error ?? NSError(domain: "OpenAITextToSpeechError", code: 0, userInfo: nil)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200,
               httpResponse.mimeType == "audio/mpeg" {
                completion(.success(data))
            } else {
                self.handleError(nil, message: "Received non-audio response or error from API")
            }
        }.resume()
    }
    
    private func handleError(_ error: Error?, message: String) {
        // Implement user-friendly error handling
        print(message, error as Any)
        // Additional error handling logic can be added here
    }
}
