import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject var store: Store
    @State private var showShareSheet: Bool = false
    @State private var showingActionSheet: Bool = false

    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
        }
//        ZStack {
//            Color.black.opacity(0.4)
//                .edgesIgnoringSafeArea(.all)
//            VStack {
//                Text("Please select an option")
//                    .font(.title)
//                    .foregroundColor(.white)
//                    .padding()
//            }
//        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Select an Option"), buttons: [
                .default(Text("Sign in")) { performSignIn() },
                .default(Text("Purchase")) { showPurchaseDialog() },
                .default(Text("Share")) { self.showShareSheet = true },
                .default(Text("Tweet")) { /* Add Tweet action here */ },
                .default(Text("System Settings")) { openSystemSettings() }
            ])
        }
        .sheet(isPresented: $showShareSheet, onDismiss: { showShareSheet = false }) {
            let url = URL(string: "https://apps.apple.com/us/app/voice-ai-talk-with-gpt4/id6470936896")!
            let shareLink = ShareLink(title: "Check out this Voice AI app! x.country/app", url: url)

            ActivityView(activityItems: [shareLink.title, shareLink.url])
        }
        .onAppear {
            self.showingActionSheet = true
        }
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
