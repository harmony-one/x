import SwiftUI
import UIKit
import Sentry

struct PurchaseOptionsView: View {
    var showPurchaseDialog: () -> Void
    var performSignIn: () -> Void
    var showDeleteAccountAlert: Binding<Bool>
    var dismiss: () -> Void

    var body: some View {
        NavigationView {
            List {
                Button("Pay $5 via Apple", action: showPurchaseDialog)
                Button("Restore purchase", action: { /* Add logic for restoring purchase */ })
                Button("Sign-in account", action: performSignIn)
                Button("Delete account", action: { showDeleteAccountAlert.wrappedValue = true })
            }
            .navigationBarTitle(Text("Purchase Options"), displayMode: .inline)
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var appSettings: AppSettings
    @State private var showShareSheet: Bool = false
    @State private var showTweet: Bool = false
    @State private var userName: String?
    @State private var showAlert = false
    @State private var isSaveTranscript = false
    @State private var showDeleteAccountAlert = false
    @State private var showPurchaseOptionsModal = false

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
        .sheet(isPresented: $showPurchaseOptionsModal) {
            PurchaseOptionsView(
                showPurchaseDialog: showPurchaseDialog,
                performSignIn: performSignIn,
                showDeleteAccountAlert: $showDeleteAccountAlert,
                dismiss: { self.showPurchaseOptionsModal = false }
            )
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
        return ActionSheet(title: Text(""), buttons: [
            .cancel({
                appSettings.showSettings(isOpened: false)
            }),
            .default(Text("Share transcript")) { saveTranscript() },
            .default(Text("Custom instructions")) { /* Add logic for custom instructions */ },
            .default(Text("Tweet Feedback")) { tweet() },
            .default(Text("Share app link")) { self.showShareSheet = true },
            .default(Text("System Settings")) { openSystemSettings() },
            .default(Text("Purchase premium")) { self.showPurchaseOptionsModal = true }
        ])
    }

    // TODO: Summon purchaseOptionsActionSheet with Purchase premium option
//    func purchaseOptionsActionSheet() -> ActionSheet {
//        return ActionSheet(title: Text(""), buttons: [
//           .default(Text("Pay $5 via Apple")) { showPurchaseDialog() },
//           .default(Text("Restore purchase")) { /* Add logic for restoring purchase */ },
//           .default(Text("Sign-in account")) { performSignIn() },
//           .default(Text("Delete account")) { self.showDeleteAccountAlert = true },
//           .cancel()
//        ])
//    }
    
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
        
//        KeychainService.shared.clearAll()
        
        print("[SettingsView][deleteUserAccount]")
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
