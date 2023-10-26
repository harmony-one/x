//
//  OpenAITest.swift
//  Hey Sergei
//
//  Created by Сергей Карасев on 26.10.2023.
//

import Foundation
import OpenAI

class OpenAITest {
    
    let openAI: OpenAI
    let shared = OpenAITest()
    
    init() {
        let token = ""
        self.openAI = OpenAI(apiToken: token)
    }
    
    func comlilation() {
        let query = ChatQuery(model: .gpt4_32k, messages: [.init(role: .user, content: "How are you?")])
        
        openAI.chatsStream(query: query) { partialResult in
            switch partialResult {
            case .success(let result):
                print(result.choices)
            case .failure(let error):
                print("chats \(error)")
            }
        } completion: { error in
            print("strem error \(error)")
        }
        
    }
    
    func setup() {
        self.comlilation()
    }
}
