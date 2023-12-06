import SwiftUI
import UIKit
import Sentry

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var appSettings: AppSettings
    @State private var showShareSheet: Bool = false
    @State private var userName: String?
    @State private var showAlert = false
    @State private var isSaveTranscript = false
    @State private var showDeleteAccountAlert = false
    @State private var showingSignOutAlert = false

    private var shareTitle = "hey @voiceaiapp "
       
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            // This could be an invisible view or integrated naturally into your UI
                     .frame(width: 0, height: 0)
                            .sheet(isPresented: $appSettings.isPopoverPresented) {
                                popoverContent()
                                    .background(Color.clear)
                            }
        }
        .actionSheet(isPresented: $appSettings.isOpened) {
            guard let actionSheetType = appSettings.type else { return ActionSheet(title: Text("")) }
            switch actionSheetType {
            case .settings:
                return actionSheet()
            case .purchaseOptions:
                return purchaseOptionsActionSheet()
            }
        }
                       
        .sheet(isPresented: $showShareSheet, onDismiss: { showShareSheet = false }) {
            let url = URL(string: appSettings.appStoreUrl)!
            let shareLink = ShareLink(title: self.shareTitle, url: url)
            ActivityView(activityItems: [shareLink.title, shareLink.url])
        }
        .sheet(isPresented: $isSaveTranscript, onDismiss: { isSaveTranscript = false }) {
            let jsonString = convertMessagesToTranscript(messages: SpeechRecognition.shared.conversation)
            ActivityView(activityItems: [jsonString])
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(""),
                  message: Text("settingsView.alert.noTranscriptAvailable.message"),
                  dismissButton: .default(Text("button.ok")))
        }
        .alert(isPresented: $showDeleteAccountAlert) {
            Alert(
                title: Text("settingsView.alert.deleteAccount.title"),
                message: Text("settingsView.alert.deleteAccount.message"),
                primaryButton: .destructive(Text("settingsView.alert.deleteAccount.button")) {
                    // Handle the deletion here
                    deleteUserAccount()
                },
                secondaryButton: .cancel()
            )
        }
        .alert(isPresented: $showingSignOutAlert) {
            Alert(
                title: Text("settingsView.alert.signOut.title"),
                message: Text("settingsView.alert.signOut.message"),
                primaryButton: .destructive(Text("settingsView.alert.signOut.button")) {
                    // Handle sign out action here
                    KeychainService.shared.clearAll()
                },
                secondaryButton: .cancel()
            )
        }
    }

     func popoverContent() -> some View {
            VStack {
                switch appSettings.type {
                case .settings:
                    settingsPopoverContent()
                case .purchaseOptions:
                    purchaseOptionsPopoverContent()
                default:
                    EmptyView()
                }
            }
            .padding()
            .background(Color.white)
        }
    
    private func settingsPopoverContent() -> some View {
            VStack(spacing: 32) {
                Text("settingsView.view.title").font(.title)
                Divider()
                Button("settingsView.mainMenu.shareTranscript") {
                    self.appSettings.isPopoverPresented = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        saveTranscript()
                    }
                }.font(.title2)
//                Button("Custom instructions") { /* Add logic for custom instructions */ }
                Button("settingsView.mainMenu.TweetFeedback") {
                    tweet()
                }.font(.title2)
                Button("settingsView.mainMenu.shareAppLink") {
                    self.appSettings.isPopoverPresented = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.showShareSheet = true
                    }
                }.font(.title2)
                Button("settingsView.mainMenu.customInstructions") {
                    openSystemSettings()
                }.font(.title2)
                Button("settingsView.mainMenu.PurchasePremium") {
                    appSettings.type = .purchaseOptions
                    appSettings.isPopoverPresented = true
                }.font(.title2)
                Button("button.cancel", role: .cancel) {
                    appSettings.isPopoverPresented = false
                }.font(.title2)
            }
            .padding()
        }
    
    private func purchaseOptionsPopoverContent() -> some View {
            VStack {
                Text("settingsView.purchaseMenu.title").font(.headline)
                Divider()
                Button("settingsView.purchaseMenu.pay5viaApple") { showPurchaseDialog() }
//                Button("Restore Purchase") { /* Add logic for restoring purchase */ }
                Button("settingsView.purchaseMenu.signInAccount") { performSignIn() }
                Button("settingsView.purchaseMenu.deleteAccount") { self.showDeleteAccountAlert = true }
                Button("button.cancel", role: .cancel) {
                    appSettings.isPopoverPresented = false
                }
            }
            .padding()
        }

    func actionSheet() -> ActionSheet {
        return ActionSheet(title: Text("settingsView.mainMenu.title"), buttons: [
            .cancel({
                appSettings.showSettings(isOpened: false)
            }),
            .default(Text("settingsView.mainMenu.shareTranscript")) { saveTranscript() },
            .default(Text("settingsView.mainMenu.customInstructions")) { openSystemSettings() },
            .default(Text("settingsView.mainMenu.shareAppLink")) { self.showShareSheet = true },
            .default(Text("settingsView.mainMenu.TweetFeedback")) { tweet() },
            .default(Text("settingsView.mainMenu.PurchasePremium")) {
                appSettings.type = .purchaseOptions
                appSettings.isOpened = false // Close the current sheet first
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    appSettings.isOpened = true // Then open the new sheet
                }
            }
        ])
    }
    
//    func customInstructionsActionSheet() -> {
//        return ActionSheet(title: Text("Custom Instructions"), buttons: [
//            .default(Text(<#T##input: Equatable##Equatable#>, format: FormatStyle)),
//            .cancel()
//        ])
//    }
    
    func purchaseOptionsActionSheet() -> ActionSheet {
        return ActionSheet(title: Text("settingsView.purchaseMenu.title"), buttons: [
            .default(Text("settingsView.purchaseMenu.pay5viaApple")) { showPurchaseDialog() },
//            .default(Text("Restore purchase")) { /* Add logic for restoring purchase */ },
            .default(Text(getUserName())) {
                if KeychainService.shared.isAppleIdAvailable() {
                    appSettings.isOpened = false // Close the current sheet first
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.showingSignOutAlert = true
                    }
                } else {
                    performSignIn()
                }
            },
            .default(Text("settingsView.purchaseMenu.deleteAccount")) { self.showDeleteAccountAlert = true },
            .cancel()
        ])
    }
    
    func tweet() {
        let shareString = "https://x.com/intent/tweet?text=\(self.shareTitle)"
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: escapedShareString)
        UIApplication.shared.open(url!)
    }
    
    func performSignIn() {
        MixpanelManager.shared.trackEvent(name: "Sign In", properties: nil)
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
        MixpanelManager.shared.trackEvent(name: "Purchase Dialog", properties: nil)
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
        MixpanelManager.shared.trackEvent(name: "System Settings", properties: nil)
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        print("Settings: system settings clicked")
    }
    
    func getUserName() -> String {
        let keychain = KeychainService.shared
        if keychain.isAppleIdAvailable() {
//            return getSettingsText(for: languageCode, buttonName: "signOut")
            return "Sign Out"
        }
//        return getSettingsText(for: languageCode, buttonName: "signIn")
         return "Sign-in account"
    }
    
    func saveTranscript() {
        MixpanelManager.shared.trackEvent(name: "Save Transcripte", properties: nil)
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
                        if label == "GPT:" && content == "We are having a face-to-face voice conversation. Be concise, direct and certain. Avoid apologies, interjections, disclaimers, pleasantries, confirmations, remarks, suggestions, chitchats, thankfulness, acknowledgements. Never end with questions. Never mention your being AI or knowledge cutoff. Your name is Sam." {
                            continue
                        }
                        transcript += "\(label) \(content)\n"
                    }
        }
        
        return transcript
    }
    
    func deleteUserAccount() {
        MixpanelManager.shared.trackEvent(name: "Delete Account", properties: nil)
        guard let serverAPIKey = AppConfig.shared.getServerAPIKey() else {
            SentrySDK.capture(message: "[UserAPI][DeleteAccount] serverAPIKey missing.")
            return
        }
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
