//
//  SettingsBundleHelper.swift
//  Voice AI
//
//  Created by Francisco Egloff on 13/11/23.
//

import Foundation

class SettingsBundleHelper {
     struct SettingsBundleKeys {
         static let Reset = "RESET_APP_KEY"
         static let CustomInstruction = "custom_instruction_preference"
         static let Username = "USER_NAME"
     }

     class func checkAndExecuteSettings() {
         if UserDefaults.standard.bool(forKey: SettingsBundleKeys.Reset) {
             UserDefaults.standard.set(false, forKey: SettingsBundleKeys.Reset)
             setDefaulValues()
         }
     }

     class func setDefaulValues() {
         let defaultCustomInstruction = """
             We are having a face-to-face voice conversation. Be concise, direct and certain. Avoid apologies, interjections, disclaimers, pleasantries, confirmations, remarks, suggestions, chitchats, thankfulness, acknowledgements. Never end with questions. Never mention your being AI or knowledge cutoff. Your name is Sam.
             """
         UserDefaults.standard.set(defaultCustomInstruction, forKey: "custom_instruction_preference")
     }
    
    class func hasPremiumMode(_ username: String) -> Bool {
        let username = UserDefaults.standard.string(forKey: SettingsBundleKeys.Username)
        return username!.trimmingCharacters(in: .whitespaces) == username
    }
 }
