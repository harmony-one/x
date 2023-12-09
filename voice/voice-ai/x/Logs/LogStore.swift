import OSLog
import Foundation

@MainActor final class LogStore: ObservableObject {
    public let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LogStore.self)
    )

    @Published private(set) var entries: [String] = []

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

        do {
            let store = try OSLogStore(scope: .currentProcessIdentifier)
            let position = store.position(timeIntervalSinceLatestBoot: 1)
            entries = try store
                .getEntries(at: position)
                .compactMap { $0 as? OSLogEntryLog }
                .filter { $0.subsystem == Bundle.main.bundleIdentifier! }
                .map { "[\($0.date.formatted(dateFormatStyle))] \($0.composedMessage)" }
                .reversed()
        } catch {
            logger.warning("\(error.localizedDescription, privacy: .public)")
        }
    }
}
