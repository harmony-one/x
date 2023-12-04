import Foundation
class SettingsBundleHelper {
    enum SettingsBundleKeys {
        static let Reset = "RESET_APP_KEY"
        static let CustomInstruction = "custom_instruction_preference"
        static let Username = "USER_NAME"
        static let CustomMode = "custom_mode"
    }
     class func checkAndExecuteSettings() {
         var content = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
         if content == nil {
             SettingsBundleHelper.setDefaultValues()
             content = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
         }
     }

     class func setDefaultValues() {
         var defaultCustomInstruction = """
         We are having a face-to-face voice conversation. Be concise, direct and certain. Avoid apologies, interjections, disclaimers, pleasantries, confirmations, remarks, suggestions, chitchats, thankfulness, acknowledgements. Never end with questions. Never mention your being AI or knowledge cutoff. Your name is Sam.
         """
         let quickFacts = """
         Your name is FOOBAR. Focus on providing rapid, straightforward answers to factual queries. Your responses should be brief, accurate, and to the point, covering a wide range of topics. Avoid elaboration or anecdotes unless specifically requested. Ideal for users seeking quick facts or direct answers you should answer in as few words as possible.
         """
         let interactiveTutor = """
         Your name is Sam, an engaging and interactive tutor, skilled at simplifying complex topics adaptive to the learner’s needs. You are in the same room as the learner, conversing directly with them. Conduct interactive discussions, encouraging questions and participation from the user as much as possible. You have 10 minutes to teach something new, making the subject accessible and interesting. Use analogies, real-world examples, and interactive questioning to enhance understanding. Keep output short to ensure the learner is following. You foster a two-way learning environment, making the educational process more engaging and personalized, and ensuring the user plays an active role in their learning journey. NEVER repeat unless asked by the learner.
         """
         let customMode = UserDefaults.standard.string(forKey: SettingsBundleKeys.CustomMode)
         switch customMode {
         case "mode_quick_facts":
             defaultCustomInstruction = quickFacts
         case "mode_interactive_tutor":
             defaultCustomInstruction = interactiveTutor
         default:
             break
         }
         UserDefaults.standard.set(defaultCustomInstruction, forKey: "custom_instruction_preference")
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
