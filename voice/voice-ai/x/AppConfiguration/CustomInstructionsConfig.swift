//
//  CustomInstructionsConfig.swift
//  Voice AI
//
//  Created by Francisco Egloff on 3/12/23.
//

import Foundation

class CustomInstructionsHandler {
    
    struct Constants {
        static let contextTexts = [
            "Default": """
    We are having a face-to-face voice conversation. Be concise, direct and certain. Avoid apologies, interjections, disclaimers, pleasantries, confirmations, remarks, suggestions, chitchats, thankfulness, acknowledgements. Never end with questions. Never mention your being AI or knowledge cutoff. Your name is Sam.
    """,
            "Quick Facts": """
    Your name is FOOBAR. Focus on providing rapid, straightforward answers to factual queries. Your responses should be brief, accurate, and to the point, covering a wide range of topics. Avoid elaboration or anecdotes unless specifically requested. Ideal for users seeking quick facts or direct answers you should answer in as few words as possible.
    """,
            "Interactive Tour": """
    Your name is Sam, an engaging and interactive tutor, skilled at simplifying complex topics adaptive to the learner’s needs. You are in the same room as the learner, conversing directly with them. Conduct interactive discussions, encouraging questions and participation from the user as much as possible. You have 10 minutes to teach something new, making the subject accessible and interesting. Use analogies, real-world examples, and interactive questioning to enhance understanding. Keep output short to ensure the learner is following. You foster a two-way learning environment, making the educational process more engaging and personalized, and ensuring the user plays an active role in their learning journey. NEVER repeat unless asked by the learner.
    """
        ]
        
        static let options = Array(contextTexts.keys) + ["Custom"]
        
        static let activeContextKey = "activeInstructionsMode"
        static let activeTextKey = "activeInstructionsText"
    }
    
    func storeActiveContext(_ context: String, withText text: String? = nil) {
        if context == "Custom", let customText = text {
            UserDefaults.standard.set(context, forKey: Constants.activeContextKey)
            UserDefaults.standard.set(customText, forKey: Constants.activeTextKey)
        } else if let defaultText = Constants.contextTexts[context] {
            UserDefaults.standard.set(context, forKey: Constants.activeContextKey)
            UserDefaults.standard.set(defaultText, forKey: Constants.activeTextKey)
        }
    }
    
    func retrieveActiveContext() -> String? {
        return UserDefaults.standard.string(forKey: Constants.activeContextKey)
    }
    
    func retrieveActiveText() -> String? {
        if let text = UserDefaults.standard.string(forKey: Constants.activeTextKey) {
            return text
        } else {
            storeActiveContext("Default")
            return Constants.contextTexts["Default"]
        }
        
    }
    
    func getOptions() -> [String] {
        return Constants.options
    }
    
    func saveCustomText(_ text: String) {
        UserDefaults.standard.set(text, forKey: "customText")
    }
}
