import Foundation
class SettingsBundleHelper {
    enum SettingsBundleKeys {
        static let Reset = "RESET_APP_KEY"
        static let CustomInstruction = "custom_instruction_preference"
        static let Username = "USER_NAME"
        static let CustomMode = "custom_mode"
        static let UserProfile = "USER_PROFILE"
        static let FollowNews = "FOLLOW_NEWS"
    }
    
    // TODO: Not being used -- I believe this is work in progress?
//     class func checkAndExecuteSettings() {
//         var content = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
//         if content == nil {
//             SettingsBundleHelper.setDefaultValues()
//             content = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
//         }
//     }
    
    static var DefaultFollowNews = "APPL"

     class func setDefaultValues(customMode: String? = nil) {
         var defaultCustomInstruction = String(localized: "customInstruction.default")
         let quickFacts = String(localized: "customInstruction.quickFacts")
         let interactiveTutor = String(localized: "customInstruction.interactiveTutor")
         let modeToUse = customMode ?? UserDefaults.standard.string(forKey: SettingsBundleKeys.CustomMode)
         switch modeToUse {
         case "mode_quick_facts":
             defaultCustomInstruction = quickFacts
         case "mode_interactive_tutor":
             defaultCustomInstruction = interactiveTutor
         default:
             break
         }
         UserDefaults.standard.set(defaultCustomInstruction, forKey: "custom_instruction_preference")
     }
    
    class func setUserProfile(profile: String) {
        UserDefaults.standard.set(profile, forKey: SettingsBundleKeys.UserProfile)
    }
    
    class func resetUserProfile() {
        UserDefaults.standard.set("", forKey: SettingsBundleKeys.UserProfile)
    }
    
    class func resetFollowNews() {
        UserDefaults.standard.set("", forKey: SettingsBundleKeys.FollowNews)
    }
    
    class func getFollowNews() -> String? {
        return UserDefaults.standard.string(forKey: SettingsBundleKeys.FollowNews)
    }
    
    class func hasPremiumMode() -> Bool {
         if let whiteLabelList = AppConfig.shared.getWhiteLabelListString(),
           let username = UserDefaults.standard.string(forKey: SettingsBundleKeys.Username),
           whiteLabelList.contains(username) {
            return true
        } else {
            return false
        }
    }
    
    class func getUserName() -> String? {
        let username = UserDefaults.standard.string(forKey: SettingsBundleKeys.Username)
        return username
    }
}
