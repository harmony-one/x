//
//  VoiceService.swift
//  Hey Sergei
//
//  Created by Сергей Карасев on 27.10.2023.
//

import Foundation
import Combine

class VoiceService: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []

    init() {
        OpenAITest.shared.$responseList
            .sink(receiveValue: { requestList in
                
                print("update \(requestList)")
                // Handle changes in OpenAITest.shared.requestList
            })
            .store(in: &cancellables)
    }
}
