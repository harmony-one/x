import AppIntents

@available(iOS 16.0, *)
struct VoiceAIShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: SurpriseIntent(),
      phrases: [
        "Surprise me",
      ]
    )
  }
}
