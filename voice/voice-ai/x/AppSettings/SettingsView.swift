import SwiftUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var appSettings: AppSettings
    @State private var showShareSheet: Bool = false
    @State private var showActionsSheet: Bool = true

    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
        }
        .actionSheet(isPresented: $showActionsSheet, content: actionSheet)
    }

    func actionSheet() -> ActionSheet {
        return ActionSheet(title: Text("Select an Option"), buttons: [
            .cancel({
                appSettings.showSettings(isOpened: false)
            }),
            .default(Text("Sign in")) { performSignIn() },
            .default(Text("Purchase")) { showPurchaseDialog() },
            .default(Text("Share")) { self.showShareSheet = true },
            .default(Text("Tweet")) { /* Add Tweet action here */ },
            .default(Text("System Settings")) { openSystemSettings() }
        ])
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
