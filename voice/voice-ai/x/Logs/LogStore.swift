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

    // Mark this function as asynchronous
    func performExport() async throws -> [String] {
        let dateFormatStyle = Date.FormatStyle()
            .year(.defaultDigits)
            .month(.twoDigits)
            .day(.twoDigits)
            .hour(.twoDigits(amPM: .abbreviated))
            .minute(.twoDigits)
            .second(.twoDigits)
            .secondFraction(.fractional(3))

        let store = try OSLogStore(scope: .currentProcessIdentifier)
        let position = store.position(timeIntervalSinceLatestBoot: 1)

        // Assuming fetching entries might involve asynchronous operations
        let entries = try await fetchLogEntries(store: store, position: position, dateFormatStyle: dateFormatStyle)
        return entries
    }

    private func fetchLogEntries(store: OSLogStore, position: OSLogPosition, dateFormatStyle: Date.FormatStyle) async throws -> [String] {
        // Perform the actual log entries fetching asynchronously
        // For now, we just use a synchronous method for illustration
        return try store
            .getEntries(at: position)
            .compactMap { $0 as? OSLogEntryLog }
            .filter { $0.subsystem == Bundle.main.bundleIdentifier! }
            .map { "[\($0.date.formatted(dateFormatStyle))] \($0.composedMessage)" }
            .reversed()
    }

    func exportInBackground(completion: @escaping () -> Void) {
        Task {
            do {
                let fetchedEntries = try await performExport()
                DispatchQueue.main.async {
                    self.entries = Array(fetchedEntries)
                    completion()
                }
            } catch {
                DispatchQueue.main.async {
                    self.logger.warning("\(error.localizedDescription, privacy: .public)")
                    completion()
                }
            }
        }
    }
}
