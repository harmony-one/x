import SwiftUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var appSettings: AppSettings
    @State public var showShareSheet: Bool = false
    @State public var showTweet: Bool = false
    @State public var userName: String?
    @State public var showTranscriptAlert = false
    @State public var isSaveTranscript = false
    internal var didAppear: ((Self) -> Void)? // for ViewInspector testing purposes

    private var shareTitle = "Check out Voice AI: Super-Intelligence app!"
    private var appUrl = "https://apps.apple.com/ca/app/voice-ai-super-intelligence/id6470936896"
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear { self.didAppear?(self) } // for ViewInspector testing purposes
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
        .alert(isPresented: $showTranscriptAlert) {
            Alert(title: Text(""),
                  message: Text("There is no transcript available to save."),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func actionSheet() -> ActionSheet {
        return ActionSheet(title: Text("Select an Option"), buttons: [
            .cancel({
                appSettings.showSettings(isOpened: false)
            }),
            .default(Text(getUserName())) { performSignIn() },
            .default(Text("Purchase")) { showPurchaseDialog() },
            .default(Text("Share")) { share() },
            .default(Text("Tweet")) { tweet() },
            .default(Text("System Settings")) { openSystemSettings() },
            .default(Text("Save Transcript")) { saveTranscript() }
            
        ])
    }
    
    func share() {
        self.showShareSheet = true
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
            showTranscriptAlert = true
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
}
