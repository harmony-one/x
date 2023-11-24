import Foundation
import Combine

class AppSettings: ObservableObject {
    @Published var isOpened: Bool = false
    static let shared = AppSettings()
    private var cancellables = Set<AnyCancellable>()
    
    func showSettings(isOpened: Bool) {
        self.isOpened = isOpened
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
    
    func convertDateStringToLocalFormat(inputDateString: String, inputFormat: String = "yyyy-MM-dd HH:mm:ss", outputFormat: String = "yyyyMMdd HH:mm") -> String? { // "MMM d, yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        
        guard let inputDate = dateFormatter.date(from: inputDateString) else {
            // Handle invalid input date string
            return nil
        }
        
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: outputFormat, options: 0, locale: Locale.current)
        dateFormatter.timeZone = TimeZone.current
        
        let outputDateString = dateFormatter.string(from: inputDate)
        return outputDateString
    }

    
    private func registerDefaultValues() {
        let localDate = convertDateStringToLocalFormat(inputDateString: "2023-12-14 22:15:00") ?? ""
        let defaults = [
            "EXPIRE_AT": localDate,
            "custom_instruction_preference": """
            We are having a face-to-face voice conversation. Be concise, direct and certain. Avoid apologies, interjections, disclaimers, pleasantries, confirmations, remarks, suggestions, chitchats, thankfulness, acknowledgements. Never end with questions. Never mention your being AI or knowledge cutoff. Your name is Sam.
            """,
            "USER_NAME": "User"
        ]
        UserDefaults.standard.register(defaults: defaults)
    }
    
    private func loadSettings() {
        let localDate = convertDateStringToLocalFormat(inputDateString: "2023-12-14 22:15:00") ?? ""
        premiumUseExpires = UserDefaults.standard.string(forKey: "EXPIRE_AT") ?? localDate
        customInstructions = UserDefaults.standard.string(forKey: "custom_instruction_preference") ?? "We are having a face-to-face voice conversation. Be concise, direct and certain. Avoid apologies, interjections, disclaimers, pleasantries, confirmations, remarks, suggestions, chitchats, thankfulness, acknowledgements. Never end with questions. Never mention your being AI or knowledge cutoff. Your name is Sam."
        userName = UserDefaults.standard.string(forKey: "USER_NAME") ?? "User"
    }
    
    private func updateUserDefaultsIfNeeded(forKey key: String, newValue: String) {
        if UserDefaults.standard.string(forKey: key) != newValue {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    static func getEpoch(dateString: String?) -> TimeInterval? {
        
        guard let dateString = dateString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if let date = dateFormatter.date(from: dateString) {
            return date.timeIntervalSince1970
        }
        return nil
    }
    
   static func isDateStringInFuture(_ dateString: String, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC

        guard let date = dateFormatter.date(from: dateString) else {
            return false // Invalid date format or string
        }

        return date > Date()
    }
}
