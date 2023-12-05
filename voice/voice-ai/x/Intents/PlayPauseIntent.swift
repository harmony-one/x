import AppIntents
import SwiftUI

@available(iOS 16.0, *)
struct PlayPauseIntent: AppIntent {
  
    static let title: LocalizedStringResource = "Play / Pause"

    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult {
        IntentManager.shared.handleAction(action: .play)
        return .result()
    }
}
