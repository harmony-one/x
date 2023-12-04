import Foundation
import SwiftUI

class SettingsBundleHelper {
    
    enum SettingsBundleKeys {
        static let Reset = "RESET_APP_KEY"
        static let UserCustomInstruction = "USER_CUSTOM_INSTRUCTION"
        static let Username = "USER_NAME"
    }

    class func checkAndExecuteSettings() {
        var content = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.UserCustomInstruction)
        if content == nil {
//            SettingsBundleHelper.setDefaultValues()
            content = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.UserCustomInstruction)
        }
    }

//    class func setDefaultValues() {
//        print("ACTIVE_CUSTOM_INSTRUCTION setDefaultValues")
//        var defaultCustomInstruction = CustomInstructionsHandler().getDefaultText()
////        CustomInstructionsHandler().saveCustomText(defaultCustomInstruction)
////        UserDefaults.standard.set(defaultCustomInstruction, forKey: "ACTIVE_CUSTOM_INSTRUCTION")
//    }

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
