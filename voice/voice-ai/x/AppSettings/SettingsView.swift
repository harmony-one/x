import SwiftUI
import UIKit
import Sentry
import OSLog


struct SettingsView: View {
    var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: "main")
    )
    @EnvironmentObject var logStore: LogStore
    @EnvironmentObject var store: Store
    @EnvironmentObject var appSettings: AppSettings
    @State private var showShareSheet: Bool = false
    @State private var userName: String?
    @State private var showTranscriptAlert = false
    @State private var isSaveTranscript = false
    @State private var showDeleteAccountAlert = false
    @State private var showingSignOutAlert = false
    @State private var isShareLogs = false

    var languageCode = getLanguageCode()
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
        .sheet(isPresented: $isShareLogs, onDismiss: { isShareLogs = false }) {
            ActivityView(activityItems: logStore.entries)
        }
        .alert(isPresented: $showTranscriptAlert) {
            Alert(
                title: Text(""),
                message: Text("There is no transcript available to save."),
                dismissButton: .default(Text("OK"))
            )
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
        .alert(isPresented: $showingSignOutAlert) {
            Alert(
                title: Text("Sign Out"),
                message: Text("Are you sure you want to sign out?"),
                primaryButton: .destructive(Text("Sign Out")) {
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
                Text("Actions").font(.title)
                Divider()
                Button("Share Transcript") {
                    self.appSettings.isPopoverPresented = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        saveTranscript()
                    }
                }.font(.title2)
//                Button("Custom instructions") { /* Add logic for custom instructions */ }
                Button("Tweet feedback") {
                    tweet()
                }.font(.title2)
                Button("Share App") {
                    self.appSettings.isPopoverPresented = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.showShareSheet = true
                    }
                }.font(.title2)
                Button("System Settings") { 
                    openSystemSettings()
                }.font(.title2)
                Button("Purchase Premium") {
                    appSettings.type = .purchaseOptions
                    appSettings.isPopoverPresented = true
                }.font(.title2)
                Button("Cancel", role: .cancel) {
                    appSettings.isPopoverPresented = false
                }.font(.title2)
            }
            .padding()
        }
    
    private func purchaseOptionsPopoverContent() -> some View {
            VStack {
                Text("Purchase Options").font(.headline)
                Divider()
                Button("Pay $5 via Apple") { showPurchaseDialog() }
//                Button("Restore Purchase") { /* Add logic for restoring purchase */ }
                Button("Sign-in Account") { performSignIn() }
                Button("Delete Account") { self.showDeleteAccountAlert = true }
                Button("Cancel", role: .cancel) {
                    appSettings.isPopoverPresented = false
                }
            }
            .padding()
        }

    func actionSheet() -> ActionSheet {
        return ActionSheet(title: Text("Voice AI - Super-Intelligence"), buttons: [
            .cancel({
                appSettings.showSettings(isOpened: false)
            }),
            .default(Text("Share transcript")) { saveTranscript() },
            .default(Text("Share logs")) { shareLogs() },
            .default(Text("Custom instructions")) { openSystemSettings() },
            .default(Text("Share app link")) { self.showShareSheet = true },
            .default(Text("Tweet feedback")) { tweet() },
            .default(Text("Purchase premium")) {
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
        return ActionSheet(title: Text("Purchase Options"), buttons: [
            .default(Text("Pay $5 via Apple")) { showPurchaseDialog() },
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
            .default(Text("Delete account")) { self.showDeleteAccountAlert = true },
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
        logger.log("Settings: system settings clicked")
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
        MixpanelManager.shared.trackEvent(name: "Save Transcript", properties: nil)
        if SpeechRecognition.shared.conversation.isEmpty {
            self.showTranscriptAlert = true
            return
        }
        isSaveTranscript = true
    }
    
    func shareLogs() {
        logStore.export()
        isShareLogs = true
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
