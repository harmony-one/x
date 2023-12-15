import Foundation
import UIKit
import Combine

enum ActionSheetType {
    case settings, purchaseOptions
    // Other cases if needed
}

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

class AppSettings: ObservableObject {
    @Published var isOpened: Bool = false
    @Published var isPopoverPresented = false
    @Published var isSharing = false
    @Published var appStoreUrl = "https://apps.apple.com/ca/app/voice-ai-super-intelligence/id6470936896"

    static let shared = AppSettings()
    private var cancellables = Set<AnyCancellable>()
    @Published var type: ActionSheetType?
    
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
    
    @Published var address: String {
        didSet {
            updateUserDefaultsIfNeeded(forKey: "ADDRESS_KEY", newValue: address)
        }
    }
    
    func showSettings(isOpened: Bool) {
        self.isOpened = isOpened
    }
    
    // Function to show specific action sheet
    func showActionSheet(type: ActionSheetType, deviceType: UIUserInterfaceIdiom? = (UIDevice.current.userInterfaceIdiom)) {
        self.type = type
        if deviceType == .pad {
            self.isPopoverPresented = true
        } else {
            self.isOpened = true
        }
    }
    
//    // Function to present popover with specific content
//        private func presentPopover(with content: PopoverContent) {
//            popoverContent = content
//            isPopoverPresented = true
//        }
    
    public init() {
        // Initialize properties with default values
        premiumUseExpires = UserDefaults.standard.string(forKey: "EXPIRE_AT") ?? "N/A"
        customInstructions = UserDefaults.standard.string(forKey: "custom_instruction_preference") ?? "N/A"
        userName = UserDefaults.standard.string(forKey: "USER_NAME") ?? "N/A"
        address = UserDefaults.standard.string(forKey: "ADDRESS_KEY") ?? "N/A"

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
            "custom_instruction_preference": String(localized: "customInstruction.default"),
            "USER_NAME": "User",
            "ADDRESS_KEY": "N/A"
        ]
        UserDefaults.standard.register(defaults: defaults)
    }
    
    private func loadSettings() {
        let localDate = convertDateStringToLocalFormat(inputDateString: "2023-12-14 22:15:00") ?? ""
        let modeToUse = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomMode)
//        print("[Mode To Use]: \(modeToUse)")
        
        premiumUseExpires = UserDefaults.standard.string(forKey: "EXPIRE_AT") ?? localDate
        userName = UserDefaults.standard.string(forKey: "USER_NAME") ?? "User"
        address = UserDefaults.standard.string(forKey: "ADDRESS_KEY") ?? "N/A"

//        customInstructions = UserDefaults.standard.string(forKey: "custom_instruction_preference") ?? String(localized: "customInstruction.default")

        switch modeToUse {
        case "mode_quick_facts":
            customInstructions = String(localized: "customInstruction.quickFacts")
        case "mode_interactive_tutor":
            customInstructions = String(localized: "customInstruction.interactiveTutor")
        default:
            customInstructions = String(localized: "customInstruction.default")
        }
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

    func isUpdateAvailable(completion: @escaping (Bool?, String?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
            }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                let versionArray = version.split(separator: ".").compactMap { Int($0) }
                let localVersionArray = currentVersion.split(separator: ".").compactMap { Int($0) }
                
                if localVersionArray.count != versionArray.count {
                    completion(true, version, nil) // different versioning system
                    return
                }
                
                for (localSegment, storeSegment) in zip(localVersionArray, versionArray) where localSegment < storeSegment {
                    completion(true, version, nil)
                    return
                }
                completion(false, version, nil)
            } catch {
                completion(nil, nil, error)
            }
        }
        task.resume()
        return task
    }
}
