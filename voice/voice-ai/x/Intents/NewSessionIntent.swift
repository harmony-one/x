import AppIntents
import SwiftUI

@available(iOS 16.0, *)
struct NewSessionIntent: AppIntent {
  
    static let title: LocalizedStringResource = "intent.newSession.title"

    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult {
        IntentManager.shared.handleAction(action: .reset)
        return .result()
    }
}
