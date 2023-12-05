import AppIntents
import SwiftUI

@available(iOS 16.0, *)
struct AppSettingsIntent: AppIntent {
  
    static let title: LocalizedStringResource = "Open settings"

    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
//        IntentManager.shared.handleAction(action: .openSettings)
        AppSettings.shared.showActionSheet(type: .settings)
        return .result(dialog: "Open settings")
    }
}
