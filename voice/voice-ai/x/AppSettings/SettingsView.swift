import SwiftUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @Environment(\.presentationMode) var presentationMode
    @State private var showShareSheet: Bool = false

    var body: some View {
        NavigationView {
                    Form {
                        Button("3-Day ChatGPT4 Use") {
                            self.showPurchaseDialog()
                            print("Settings: showPurchaseDialog clicked")
                        }
                        Button("Sign In") {
                            let keyWindow = UIApplication.shared.connectedScenes
                                .filter { $0.activationState == .foregroundActive }
                                .compactMap { $0 as? UIWindowScene }
                                .first?.windows
                                .filter { $0.isKeyWindow }.first
                            if let keyWindow = keyWindow {
                                AppleSignInManager.shared.performAppleSignIn(using: keyWindow)
                            }
                        }
                        Button("Share") {
                            self.showShareSheet = true
                            print("Settings: share clicked")
                        }
                        Button("Open System Settings") {
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                            print("Settings: system settings clicked")
                        }
                    }
                    .navigationBarTitle("Settings")
                    .navigationBarItems(trailing: Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    })
                }.sheet(isPresented: $showShareSheet, onDismiss: { showShareSheet = false }) {
                    let url = URL(string: "https://apps.apple.com/us/app/voice-ai-talk-with-gpt4/id6470936896")!
                    let shareLink = ShareLink(title: "Check out this Voice AI app! x.country/app", url: url)

                    ActivityView(activityItems: [shareLink.title, shareLink.url])
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
}
