import AppIntents
import SwiftUI

@available(iOS 16.0, *)
struct AppSettingsIntent: AppIntent {
  
    static let title: LocalizedStringResource = "intent.openSettings.title" // Open settings"

    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        IntentManager.shared.showSettings()
        return .result()
    }
}
