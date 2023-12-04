import SwiftUI
import UIKit
import Sentry

struct CustomAlertView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        // Transparent background that covers the entire screen
        Color.black.opacity(0.4)
            .edgesIgnoringSafeArea(.all)
        // The alert content
            .overlay(
                VStack {
                    content
                }
                    .padding()
                    .frame(width: 400, height: 500) // Adjust the size as needed
                    .background(Color(hex: 0x1E1E1E).animation(.none))
                    .cornerRadius(15)
                    .shadow(radius: 10),
                alignment: .center
            )
    }
}

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var appSettings: AppSettings
    @State private var showShareSheet: Bool = false
    @State private var userName: String?
    @State private var showAlert = false
    @State private var isSaveTranscript = false
    @State private var showDeleteAccountAlert = false
    
    private var shareTitle = "hey @voiceaiapp "
    private var appUrl = "https://apps.apple.com/ca/app/voice-ai-super-intelligence/id6470936896"
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            // This could be an invisible view or integrated naturally into your UI
            if appSettings.isPopoverPresented {
                CustomAlertView {
                    popoverContent()
                }
                .transition(.scale) // Optional: Add a transition
                .onTapGesture {
                    appSettings.isPopoverPresented = false // Dismiss the custom alert
                }
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
    
    @ViewBuilder
    func popoverContent() -> some View {
        switch appSettings.type {
        case .settings:
            settingsPopoverContent()
        case .purchaseOptions:
            purchaseOptionsPopoverContent()
        default:
            EmptyView()
        }
    }
    
    private func settingsPopoverContent() -> some View {
        
        return VStack {
            
            Spacer()
            Text("Voice AI - Super-Intelligence").font(.title2)
                .foregroundColor(.white)
            Spacer()
            Button("Share Transcript") {
                appSettings.isOpened = false
                self.appSettings.isPopoverPresented = false
                saveTranscript()
            }.font(.title3)
                .foregroundColor(.red)
            Spacer()
            Button("Tweet Feedback") {
                tweet()
                self.appSettings.isPopoverPresented = false
            }.font(.title3)
                .foregroundColor(.red)
            Spacer()
            Button("Share App") {
                self.appSettings.isPopoverPresented = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.showShareSheet = true
                }
            }.font(.title3)
                .foregroundColor(.red)
            Spacer()
            Button("System Settings") {
                openSystemSettings()
                self.appSettings.isPopoverPresented = false
            }.font(.title3)
                .foregroundColor(.red)
            
            Spacer()
            Button("Purchase Premium") {
                appSettings.type = .purchaseOptions
                appSettings.isPopoverPresented = true
            }.font(.title3)
                .foregroundColor(.red)
            Spacer()
            Button("Cancel", role: .cancel) {
                appSettings.isPopoverPresented = false
            }.font(.title3)
                .foregroundColor(.red)
            Spacer()
        }
        .padding()
        .background(Color(hex: 0x1E1E1E).animation(.none))
    }
    
    private func purchaseOptionsPopoverContent() -> some View {
        VStack {
            Spacer()
            Text("Voice AI - Super-Intelligence")
                .font(.title2).foregroundColor(.white)
            Spacer()
            Button("Pay $5 via Apple") {
                showPurchaseDialog()
                appSettings.isPopoverPresented = true
            }.font(.title3).foregroundColor(.red)
            Spacer()
            Button("Restore Purchase") { /* Add logic for restoring purchase */
            }.font(.title3).foregroundColor(.red)
            Spacer()
            Button("Sign-in Account") {
                performSignIn()
                appSettings.isPopoverPresented = true
                appSettings.isPopoverPresented = false
            }.font(.title3).foregroundColor(.red)
            Spacer()
            Button("Delete Account") {
                //                appSettings.isOpened = false
                //                self.appSettings.isPopoverPresented = false
                self.showDeleteAccountAlert = true
            }.font(.title3).foregroundColor(.red)
            Spacer()
            Button("Cancel", role: .cancel) {
                appSettings.isPopoverPresented = false
            }.font(.title3).foregroundColor(.red)
            Spacer()
        }
        .padding()
    }
    
    func actionSheet() -> ActionSheet {
        return ActionSheet(title: Text("Voice AI - Super-Intelligence"), buttons: [
            .cancel({
                appSettings.showSettings(isOpened: false)
            }),
            .default(Text("Share transcript")) {
                appSettings.isOpened = false
                saveTranscript()
            },
            .default(Text("Custom instructions")) { /* Add logic for custom instructions */ },
            .default(Text("Share app link")) { self.showShareSheet = true },
            .default(Text("Tweet Feedback")) { tweet() },
            .default(Text("System Settings")) { openSystemSettings() },
            .default(Text("Purchase premium")) {
                appSettings.type = .purchaseOptions
                appSettings.isOpened = false // Close the current sheet first
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    appSettings.isOpened = true // Then open the new sheet
                }
            }
        ])
    }
    
    func purchaseOptionsActionSheet() -> ActionSheet {
        return ActionSheet(title: Text("Purchase Options"), buttons: [
            .default(Text("Pay $5 via Apple")) { showPurchaseDialog() },
            .default(Text("Restore purchase")) { /* Add logic for restoring purchase */ },
            .default(Text(getUserName())) { performSignIn() },
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
                        self.store.isPurchasing = false
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
        return "Sign-in account"
    }
    
    func saveTranscript() {
        if SpeechRecognition.shared.conversation.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showAlert = true
            }
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
