
import Foundation

struct OpenAIUtils {
    static func limitConversationContext (_ conversaton: [Message], charactersCount: Int) -> [Message] {
        var filteredConversation: [Message] = []
        var totalContentLength = 0

        for message in conversaton.reversed() {
            if let content = message.content {
                if totalContentLength + content.count <= charactersCount {
                    filteredConversation.insert(message, at: 0)
                    totalContentLength += content.count
                } else if totalContentLength < charactersCount {
                    let diff = totalContentLength - charactersCount
                    let length = min(diff, content.count)
                    
                    let trimmedContent = String(content.suffix(length));
                    let newMessage = Message(role: message.role, content: trimmedContent);
                    
                    filteredConversation.insert(newMessage, at: 0)
                    
                    break
                }
            }
        }
        
        return filteredConversation
    }
    
    static func calcConversationContext(_ conversaton: [Message]) -> Int {
        var charsCount = 0

        for message in conversaton {
            if let content = message.content {
                charsCount += content.count
            }
        }
        
        return charsCount
    }
}
