import SwiftUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var appSettings: AppSettings
    @State private var showShareSheet: Bool = false
    @State private var showTweet: Bool = false

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
    }

    func actionSheet() -> ActionSheet {
        return ActionSheet(title: Text("Select an Option"), buttons: [
            .cancel({
                appSettings.showSettings(isOpened: false)
            }),
            .default(Text("Sign in")) { performSignIn() },
            .default(Text("Purchase")) { showPurchaseDialog() },
            .default(Text("Share")) { self.showShareSheet = true },
            .default(Text("Tweet")) { tweet() },
            .default(Text("System Settings")) { openSystemSettings() }
        ])
    }
    
    func tweet() {
        let shareString = "https://x.com/intent/tweet?text=\(self.shareTitle) \(self.appUrl)"
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: escapedShareString)
        UIApplication.shared.open(url!)
    }

    func performSignIn() {
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
}
