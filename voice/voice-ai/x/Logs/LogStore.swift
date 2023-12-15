import Foundation
import OSLog
import SwiftUI

@MainActor
final class LogStore: ObservableObject {
    @Published private(set) var entries: [String] = []
    
    public let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LogStore.self)
    )
    
    func export() {
        print("[LogStore][export] Exporting Logs")
        let dateFormatStyle = Date.FormatStyle()
            .year(.defaultDigits)
            .month(.twoDigits)
            .day(.twoDigits)
            .hour(.twoDigits(amPM: .abbreviated))
            .minute(.twoDigits)
            .second(.twoDigits)
            .secondFraction(.fractional(3))
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let store = try OSLogStore(scope: .currentProcessIdentifier)
                let position = store.position(timeIntervalSinceLatestBoot: 1)
                let fetchedEntries = try store
                    .getEntries(at: position)
                    .compactMap { $0 as? OSLogEntryLog }
                    .filter { $0.subsystem == Bundle.main.bundleIdentifier! }
                    .map { "[\($0.date.formatted(dateFormatStyle))] \($0.composedMessage)" }
                
                // Convert the ReversedCollection back to an Array
                let reversedEntries = Array(fetchedEntries.reversed())
                DispatchQueue.main.async {
                    self.entries = reversedEntries
                }
            } catch {
                DispatchQueue.main.async {
                    self.logger.warning("\(error.localizedDescription, privacy: .public)")
                }
            }
        }
    }
    
    // Method to be called from the background
    func exportInBackground(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Perform heavy operation in the background
            Task {
                await self.export()
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
