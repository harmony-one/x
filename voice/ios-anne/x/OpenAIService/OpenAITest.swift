import Foundation
import OpenAI
import Combine

//public struct AiAudio {
//    let hash: String
//    let data: Data
//}

struct Sencence {
    let id: UUID
    let sentence: String
}

public class AiResponse: ObservableObject {
    let requestUuid: UUID
    @Published var response: [String]
    let request: String
    
    init(uuid: UUID, resuest: String) {
        self.requestUuid = uuid
        self.response = []
        self.request = resuest
    }
}

class OpenAITest: NSObject, ObservableObject {
    
    var openAI: OpenAI?
    static let shared = OpenAITest()
    @Published public var responseList: [AiResponse] = []
    
    func comlilation(text: String) {
        guard let openAI = openAI else {
            print("openAI cannot be nil")
            return;
        }
        
        let uuid = UUID()
        
        var aiResponse = AiResponse(uuid: uuid, resuest: text)
        self.responseList.append(aiResponse)
        
        var sentence: String = ""
        let punctuationMarks: [Character] = [".", "!", "?"]
        
        let query = ChatQuery(model: .gpt4_32k, messages: [.init(role: .user, content: text)])
        
        openAI.chatsStream(query: query) { partialResult in
            switch partialResult {
            case .success(let result):
                result.choices.forEach { choice in
                    guard let content = choice.delta.content else {
                        print(aiResponse.response)
                        return
                    }
                    
                    if (content.isEmpty) {
                        return
                    }
                    
                    sentence += content
                    
                    guard let lastChar = content.last else {
                        return
                    }
                    
                    if(punctuationMarks.contains(lastChar)) {
                        let trimmed =  sentence.trimmingCharacters(in: .whitespacesAndNewlines)
                        aiResponse.response.append(trimmed)
                        sentence = ""
                    }
                }
            case .failure(let error):
                print("chats \(error)")
            }
        } completion: { error in
            if (error != nil) {
                print("strem error \(error?.localizedDescription ?? "empty error")")
                return
            }
            
            print("completed")
            
        }
    }
    
    func setup() {
        let config = AppConfig()
        
        guard let token = config.getAPIKey() else {
            print("token cannot be empty")
            return;
        }
        self.openAI = OpenAI(apiToken: token)
        
        self.comlilation(text: "How are you?")
    }
}
