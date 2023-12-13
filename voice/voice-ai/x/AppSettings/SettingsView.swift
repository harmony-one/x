import SwiftUI
import UIKit
import Sentry
import OSLog
import Darwin.sys.sysctl

struct SettingsView: View {
    var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: "[SettingsView]")
    )
    @EnvironmentObject var logStore: LogStore
    @EnvironmentObject var store: Store
    @EnvironmentObject var appSettings: AppSettings
    @State private var showShareSheet: Bool = false
    @State private var userName: String?
    @State private var isSaveTranscript = false
    @State private var isShareLogs = false


    private var shareTitle = "hey @voiceaiapp "

    private var maxByteSize = 10 * 1024 * 1024 // 10MB in bytes

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
            ActivityView(activityItems: [shareLink.title, shareLink.url], isSharing: $appSettings.isSharing)
        }
        .sheet(isPresented: $isSaveTranscript, onDismiss: { isSaveTranscript = false }) {
            let jsonString = convertMessagesToTranscript(messages: SpeechRecognition.shared.conversation)
            ActivityView(activityItems: [jsonString], isSharing: $appSettings.isSharing)
        }
        .sheet(isPresented: $isShareLogs, onDismiss: { isShareLogs = false }) {
            ActivityView(activityItems: [logStore.entries.joined(separator: "\n")], isSharing: $appSettings.isSharing)
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
            Button("settingsView.mainMenu.shareTranscript") {
                self.appSettings.isPopoverPresented = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    saveTranscript()
                }
            }
            Button("settingsView.mainMenu.telegramGroup") {
                telegramGroup()
            }
            Button("settingsView.mainMenu.premiumVoices") {
                self.appSettings.isPopoverPresented = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    premiumVoices()
                }
            }
            //                Button("Restore Purchase") { /* Add logic for restoring purchase */ }
            Button("settingsView.purchaseMenu.signInAccount") { performSignIn() }
            Button("settingsView.purchaseMenu.deleteAccount") {
                appSettings.isPopoverPresented = false
                showDeleteAccountAlert()
            }
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
            .default(Text("settingsView.mainMenu.shareTranscript")) { shareLogs() },
            .default(Text("settingsView.mainMenu.telegramGroup")) { telegramGroup() },
            .default(Text("settingsView.mainMenu.premiumVoices")) { premiumVoices() },
            .default(Text(getUserName())) {
                if KeychainService.shared.isAppleIdAvailable() {
                    appSettings.isOpened = false // Close the current sheet first
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showSignOutAlert()
                    }
                } else {
                    performSignIn()
                }
            },
            .default(Text("settingsView.purchaseMenu.deleteAccount")) {
                showDeleteAccountAlert()
            },
            .cancel()
        ])
    }

    func tweet() {
        let shareString = "https://x.com/intent/tweet?text=\(self.shareTitle)"
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: escapedShareString)
        UIApplication.shared.open(url!)
    }
    
    func telegramGroup() {
        let shareString = "https://x.country/telegram"
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
                    logger.log("[AppleSignInManager] No products available")
                } else {
                    let product = self.store.products[0]
                    do {
                        try await self.store.purchase(product)
                    } catch {
                        logger.log("[AppleSignInManager] Error during purchase")
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
    
    func premiumVoices() {
        MixpanelManager.shared.trackEvent(name: "Premium Voices", properties: nil)
        let cancel = UIAlertAction(title: String(localized: "button.cancel"), style: .cancel)
        AlertManager.showAlertForSettings(title: String(localized: "settingsView.alert.premiumVoices.title"), message: String(localized: "settingsView.alert.premiumVoices.message"), actions: [cancel])
        logger.log("Settings: Premium Voices clicked")
    }

    func getUserName() -> String {
        let keychain = KeychainService.shared
        if keychain.isAppleIdAvailable() {
            //            return getSettingsText(for: languageCode, buttonName: "signOut")
            return String(localized: "settingsView.purchaseOptions.button.signOut")
        }
        //        return getSettingsText(for: languageCode, buttonName: "signIn")
        return String(localized: "settingsView.purchaseOptions.button.signInAccountOut")
    }

    func saveTranscript() {
        MixpanelManager.shared.trackEvent(name: "Save Transcript", properties: nil)
        if SpeechRecognition.shared.conversation.isEmpty {
            let okAction = UIAlertAction(title: String(localized: "button.ok"), style: .default)
            AlertManager.showAlertForSettings(title: "", message: String(localized: "settingsView.alert.noTranscriptAvailable.message"), actions: [okAction])
            return
        }
        isSaveTranscript = true
    }

    func shareLogs() {
        DispatchQueue.main.async {
            appSettings.isSharing = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isShareLogs = true
            logStore.export()
        }
    }

    func convertMessagesToTranscript(messages: [Message]) -> String {
        var transcript = ""

        // include settings here
        transcript = settingsToTranscript(transcript: transcript)
        var currentSize = transcript.data(using: .utf8)?.count ?? 0

        for message in messages {
            let label = message.role?.lowercased() == "user" ? "User:" : "GPT:"
            if let content = message.content {
                if label == "GPT:" && content == String(localized: "customInstruction.default") {
                    continue
                }

                let newEntry = "\(label) \(content)\n"
                let newEntrySize = newEntry.data(using: .utf8)?.count ?? 0

                if currentSize + newEntrySize <= maxByteSize {
                    transcript += newEntry
                    currentSize += newEntrySize
                } else {
                    break
                }
            }
        }

        return transcript
    }

    func settingsToTranscript(transcript: String) -> String {
        var updatedTranscript = transcript

        func getAppVersion() -> String? {
            guard let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
                return nil
            }
            return appVersion
        }

        if let versionNumber = getAppVersion() {
            updatedTranscript += "App Version: \(versionNumber)\n"
        } else {
            updatedTranscript += "App Version: Unknown\n"
        }

        // specific hardware model identifier
        func getHardwareModel() -> String? {
            var size: Int = 0
            if sysctlbyname("hw.machine", nil, &size, nil, 0) != 0 {
                self.logger.log("Error: Could not determine size of hardware model string")
                return nil
            }

            var machine = [CChar](repeating: 0, count: size)
            if sysctlbyname("hw.machine", &machine, &size, nil, 0) != 0 {
                self.logger.log("Error: Could not retrieve hardware model string")
                return nil
            }

            return String(cString: machine)
        }

        if let deviceModel = getHardwareModel() {
            updatedTranscript += "Device: \(deviceModel)\n"
        } else {
            updatedTranscript += "Device: Unknown\n"
        }

        let iosVersion = UIDevice.current.systemVersion
        updatedTranscript += "iOS Version: \(iosVersion)\n"

        // new line for readability
        updatedTranscript += "\n"

        return updatedTranscript
    }

    func deleteUserAccount() {
        MixpanelManager.shared.trackEvent(name: "Delete Account", properties: nil)
        guard let serverAPIKey = AppConfig.shared.getServerAPIKey() else {
            SentrySDK.capture(message: "[UserAPI][DeleteAccount] serverAPIKey missing.")
            return
        }
        logger.log("[SettingsView][deleteUserAccount]")
        UserAPI().deleteUserAccount(apiKey: serverAPIKey) { success in
            if success {
                logger.log("Account deletion successful.")
                // Perform any additional tasks if the deletion is successful
                SentrySDK.capture(message: "[UserAPI][DeleteAccount] Sucess")
                KeychainService.shared.clearAll()
                return
            }
            SentrySDK.capture(message: "[UserAPI][DeleteAccount] Account deletion failed.")
            // Handle the failure case
        }
    }

    func showSignOutAlert() {

        let cancel = UIAlertAction(title: String(localized: "button.cancel"), style: .cancel)
        let deleteAction = UIAlertAction(title: String(localized: "settingsView.alert.signOut.button"), style: .destructive) { _ in
            // Handle sign out action here
            KeychainService.shared.clearAll()
        }
        AlertManager.showAlertForSettings(title: String(localized: "settingsView.alert.signOut.title"), message: String(localized: "settingsView.alert.signOut.message"), actions: [cancel, deleteAction])
    }

    func showDeleteAccountAlert() {
        let cancel = UIAlertAction(title: String(localized: "button.cancel"), style: .cancel)
        let deleteAction = UIAlertAction(title: String(localized: "settingsView.alert.deleteAccount.button"), style: .destructive) { _ in
            // Handle the deletion here
            deleteUserAccount()
        }
        AlertManager.showAlertForSettings(title: String(localized: "settingsView.alert.deleteAccount.title"), message: String(localized: "settingsView.alert.deleteAccount.message"), actions: [cancel, deleteAction])
    }
}
