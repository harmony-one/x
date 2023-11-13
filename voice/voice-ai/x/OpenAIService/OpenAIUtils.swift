import Foundation

struct OpenAIUtils {
    static func limitConversationContext (_ conversaton: [Message], charactersCount: Int) -> [Message] {
        var filteredConversation: [Message] = []
        var totalContentLength = 0
        
        filteredConversation.append(contentsOf: OpenAIStreamService.setConversationContext())
        totalContentLength += filteredConversation.count
        
        for message in conversaton.reversed() {
            guard let content = message.content else {
                continue
            }
            
            if content.count == 0 {
                continue
            }
            
            if totalContentLength + content.count <= charactersCount {
                filteredConversation.insert(message, at: 0)
                totalContentLength += content.count
                continue
            }
            
            let charsLeft = charactersCount - totalContentLength;
            if charsLeft > 0 {
                let length = min(charsLeft, content.count)
                let trimmedContent = String(content.suffix(length));
                let newMessage = Message(role: message.role, content: trimmedContent);
                
                filteredConversation.insert(newMessage, at: 0)
                totalContentLength += trimmedContent.count;
                break
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
