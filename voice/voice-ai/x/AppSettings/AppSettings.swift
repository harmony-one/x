import Foundation
import Combine

class AppSettings: ObservableObject {
    @Published var isOpened: Bool = false
    static let shared = AppSettings()
    private var cancellables = Set<AnyCancellable>()
    
    func showSettings(isVisible: Bool) {
        isOpened = isVisible
    }

    @Published var premiumUseExpires: String {
        didSet {
            updateUserDefaultsIfNeeded(forKey: "EXPIRE_AT", newValue: premiumUseExpires)
        }
    }
    @Published var customInstructions: String {
        didSet {
            updateUserDefaultsIfNeeded(forKey: "custom_instruction_preference", newValue: customInstructions)
        }
    }
    @Published var userName: String {
        didSet {
            updateUserDefaultsIfNeeded(forKey: "USER_NAME", newValue: userName)
        }
    }

    public init() {
        // Initialize properties with default values
        premiumUseExpires = UserDefaults.standard.string(forKey: "EXPIRE_AT") ?? "N/A"
        customInstructions = UserDefaults.standard.string(forKey: "custom_instruction_preference") ?? "N/A"
        userName = UserDefaults.standard.string(forKey: "USER_NAME") ?? "N/A"

        // Register default values after initialization
        registerDefaultValues()

        // Listen to UserDefaults changes
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.loadSettings()
                }
            }
            .store(in: &cancellables)
    }

    private func registerDefaultValues() {
        let defaults = [
            "EXPIRE_AT": "2023-12-14 22:15:00",
            "custom_instruction_preference": """
            We are having a face-to-face voice conversation. Be concise, direct and certain. Avoid apologies, interjections, disclaimers, pleasantries, confirmations, remarks, suggestions, chitchats, thankfulness, acknowledgements. Never end with questions. Never mention your being AI or knowledge cutoff. Your name is Sam.
            """,
            "USER_NAME": "User"
        ]
        UserDefaults.standard.register(defaults: defaults)
    }

    private func loadSettings() {
        premiumUseExpires = UserDefaults.standard.string(forKey: "EXPIRE_AT") ?? "2023-12-14 22:15:00"
        customInstructions = UserDefaults.standard.string(forKey: "custom_instruction_preference") ?? "We are having a face-to-face voice conversation. Be concise, direct and certain. Avoid apologies, interjections, disclaimers, pleasantries, confirmations, remarks, suggestions, chitchats, thankfulness, acknowledgements. Never end with questions. Never mention your being AI or knowledge cutoff. Your name is Sam."
        userName = UserDefaults.standard.string(forKey: "USER_NAME") ?? "User"
    }

    private func updateUserDefaultsIfNeeded(forKey key: String, newValue: String) {
        if UserDefaults.standard.string(forKey: key) != newValue {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
