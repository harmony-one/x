import AppIntents
import SwiftUI

@available(iOS 16.0, *)
struct SurpriseIntent: AppIntent {
  
    static let title: LocalizedStringResource = "intent.surprise.title"

    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        IntentManager.shared.handleAction(action: .surprise)
        return .result(dialog: "intent.surprise.title")
    }
}
