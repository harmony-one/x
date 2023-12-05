import AppIntents

@available(iOS 16.0, *)
struct VoiceAIShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
      return [
        AppShortcut(
          intent: SurpriseIntent(),
          phrases: [
            "Surprise me"
          ]),
        AppShortcut(
            intent: AppSettingsIntent(),
            phrases: [
                "Open Settings"
            ]
        )
      ]
  }
}
