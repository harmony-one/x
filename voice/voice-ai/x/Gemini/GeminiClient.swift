import GoogleGenerativeAI

enum GeminiClientError: Error {
    case chatNotInitialized
}

struct GeminiClientConfig {
    let apiKey: String
    let customInstruction: String
}

class GeminiClient {

    private var clientConfig: GeminiClientConfig
    private var config: GenerationConfig
    private var model: GenerativeModel
    private var chat: Chat?
    
    init(config: GeminiClientConfig) {
        self.clientConfig = config;
        
        self.config = GenerationConfig(
          temperature: 0.9,
          topP: 1,
          topK: 1,
          maxOutputTokens: 2048
        )
        
        self.model = GenerativeModel(
            name: "gemini-pro",
            apiKey: self.clientConfig.apiKey,
            generationConfig: self.config,
            safetySettings: [
              SafetySetting(harmCategory: .harassment, threshold: .blockMediumAndAbove),
              SafetySetting(harmCategory: .hateSpeech, threshold: .blockMediumAndAbove),
              SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockMediumAndAbove),
              SafetySetting(harmCategory: .dangerousContent, threshold: .blockMediumAndAbove)
            ]
          )
    }
    
    func startChat() -> Chat {
        self.chat = self.model.startChat(history: [
            ModelContent(role: "user", parts: self.clientConfig.customInstruction),
        ])
        
        return self.chat!
    }
    
    func sendMessage(message: String, completion: @escaping ((Result<String, Error>) -> Void)) throws {
        guard let chat = self.chat else {
            throw GeminiClientError.chatNotInitialized
        }
        
        Task {
            do {
                let message = message
                let response = try await chat.sendMessage(message)
                
                completion(.success(response.text ?? ""))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func sendMessageStream(message: String) throws {
        guard let chat = self.chat else {
            throw GeminiClientError.chatNotInitialized
        }
        
        Task {
            do {
                let message = message
                let response = try await chat.sendMessageStream(message)
            } catch {
                print(error)
            }
        }
    }
}
