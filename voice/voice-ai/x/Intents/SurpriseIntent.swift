import AppIntents
import SwiftUI

@available(iOS 16.0, *)
struct SurpriseIntent: AppIntent {
  
    static let title: LocalizedStringResource = "Surprise ME!"

    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        SpeechRecognition.shared.surprise()
        return .result(dialog: "Surpise ME!")
    }
}
