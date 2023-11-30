import SwiftUI
import UIKit
import Sentry

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var appSettings: AppSettings
    @State private var showShareSheet: Bool = false
    @State private var showTweet: Bool = false
    @State private var userName: String?
    @State private var showAlert = false
    @State private var isSaveTranscript = false
    @State private var showDeleteAccountAlert = false

    private var shareTitle = "Check out Voice AI: Super-Intelligence app!"
    private var appUrl = "https://apps.apple.com/ca/app/voice-ai-super-intelligence/id6470936896"
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
        }
        .actionSheet(isPresented: $appSettings.isOpened, content: actionSheet)
        .sheet(isPresented: $showShareSheet, onDismiss: { showShareSheet = false }) {
            let url = URL(string: self.appUrl)!
            let shareLink = ShareLink(title: self.shareTitle, url: url)
            ActivityView(activityItems: [shareLink.title, shareLink.url])
        }
        .sheet(isPresented: $isSaveTranscript, onDismiss: { isSaveTranscript = false }) {
             let jsonString = convertMessagesToTranscript(messages: SpeechRecognition.shared.conversation)
                ActivityView(activityItems: [jsonString])
        }
            .alert(isPresented: $showAlert) {
            Alert(title: Text(""),
                  message: Text("There is no transcript available to save."),
                  dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showDeleteAccountAlert) {
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Your account and any associated purchases will be permanently deleted."),
                    primaryButton: .destructive(Text("Delete")) {
                        // Handle the deletion here
                        deleteUserAccount()
                    },
                    secondaryButton: .cancel()
                )
            }
    }
    
    func actionSheet() -> ActionSheet {
        return ActionSheet(title: Text("Select an Option"), buttons: [
            .cancel({
                appSettings.showSettings(isOpened: false)
            }),
            .default(Text(getUserName())) { performSignIn() },
            .default(Text("Purchase")) { showPurchaseDialog() },
            .default(Text("Share")) { self.showShareSheet = true },
            .default(Text("Tweet")) { tweet() },
            .default(Text("System Settings")) { openSystemSettings() },
            .default(Text("Save Transcript")) { saveTranscript() },
            .default(Text("Delete Account")) { self.showDeleteAccountAlert = true }
        ])
    }
    
    func tweet() {
        let shareString = "https://x.com/intent/tweet?text=\(self.shareTitle) \(self.appUrl)"
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: escapedShareString)
        UIApplication.shared.open(url!)
    }
    
    func performSignIn() {
        if KeychainService.shared.isAppleIdAvailable() {
            return
        }
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first
        if let keyWindow = keyWindow {
            AppleSignInManager.shared.performAppleSignIn(using: keyWindow)
        }
    }
    
    func showPurchaseDialog() {
        DispatchQueue.main.async {
            Task {
                if self.store.products.isEmpty {
                    print("[AppleSignInManager] No products available")
                } else {
                    let product = self.store.products[0]
                    do {
                        try await self.store.purchase(product)
                    } catch {
                        print("[AppleSignInManager] Error during purchase")
                    }
                }
            }
        }
    }
    
    func openSystemSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        print("Settings: system settings clicked")
    }
    
    func getUserName() -> String {
        let keychain = KeychainService.shared
        if keychain.isAppleIdAvailable() {
            guard let email = keychain.retrieveEmail() else {
                let userID =  keychain.retrieveUserid() ?? "User id not found"
                return userID
            }
            return email
        }
        return "Sign In"
    }
    
    func saveTranscript() {
        if SpeechRecognition.shared.conversation.isEmpty {
            showAlert = true
            return
        }       
        isSaveTranscript = true
    }
  
    func convertMessagesToTranscript(messages: [Message]) -> String {
        var transcript = ""

        for message in messages {
            let label = message.role?.lowercased() == "user" ? "User:" : "GPT:"
            if let content = message.content {
                transcript += "\(label) \(content)\n"
            }
        }

        return transcript
    }
    
    func deleteUserAccount() {
        guard let serverAPIKey = AppConfig.shared.getServerAPIKey() else {
            return
        }
        UserAPI().deleteUserAccount(apiKey: serverAPIKey) { success in
            
            if success {
                print("Account deletion successful.")
                // Perform any additional tasks if the deletion is successful
                SentrySDK.capture(message: "[UserAPI][DeleteAccount] Sucess")
                KeychainService.shared.clearAll()
                return
            }
            SentrySDK.capture(message: "[UserAPI][DeleteAccount] Account deletion failed.")
            // Handle the failure case
        }
    }
}

