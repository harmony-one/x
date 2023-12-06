import AudioToolbox
import Combine
import CoreHaptics
import Foundation
import StoreKit
import SwiftUI
import UIKit

protocol ActionsViewProtocol {
    func openSettingsApp()
    func openPurchaseDialog()
    func showInAppPurchasesIfNotLoggedIn()
    func vibration()
}

struct ActionsView: ActionsViewProtocol, View {
    
    @StateObject var actionHandler: ActionHandler
    
    let config = AppConfig.shared
    @State var currentTheme: Theme = .init()

    // var dismissAction: () -> Void
    let buttonSize: CGFloat = 100
    let imageTextSpacing: CGFloat = 30
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.scenePhase) private var scenePhase
    @State private var isRecording = false
    @State private var isRecordingContinued = false

    // need it to sync speak button animation with pause button
    @State private var isSpeakButtonPressed = false
    @State private var speakButtonDebounceTimer: Timer?
    
    @State private var isTapToSpeakActive = false
    @State private var tapToSpeakDebounceTimer: Timer?
    
    @State private var lastButtonPressed: ActionType?

    @State var isSurpriseButtonPressed = true
    @State private var orientation = UIDevice.current.orientation
    
    @EnvironmentObject var store: Store
    @EnvironmentObject var appSettings: AppSettings
    @State private var skipPressedTimer: Timer?

    @State private var buttonFrame: CGRect = .zero
    @State private var tapCount: Int = 0

    @State private var showShareSheet: Bool = false
    @State private var showShareAlert: Bool = false
    @State private var showNewAppVersionAlert: Bool = false
    @State private var newAppVersion: String?

    static var generator: UIImpactFeedbackGenerator?

    static let DelayBeforeShowingAlert: TimeInterval = 600 // seconds

    @ObservedObject var speechRecognition = SpeechRecognition.shared

    let oneValue = "2111.01 ONE "

    var buttonsPortrait: [ButtonData] = []
    var buttonsLandscape: [ButtonData] = []

    @State private var storage = Set<AnyCancellable>()

    @State private var keyWindow: UIWindow?

    let maxResetClicks = 20
    @State private var resetClickCounter = 0

    init(actionHandler: ActionHandlerProtocol? = nil) {
        _actionHandler = StateObject(wrappedValue: actionHandler as? ActionHandler ?? ActionHandler())

        let theme = AppThemeSettings.fromString(config.getThemeName())
        currentTheme.setTheme(theme: theme)

        let themePrefix = currentTheme.name
        let buttonReset = ButtonData(label: String(localized: "actionView.button.reset"), image: "\(themePrefix) - new session", action: .reset, testId: "button-newSession")
        let buttonTapSpeak = ButtonData(label: String(localized: "actionView.button.tapSpeak"), pressedLabel: String(localized: "actionView.button.tapSpeak.send"), image: "\(themePrefix) - square", action: .speak, testId: "button-tapToSpeak")
        let buttonSurprise = ButtonData(label: String(localized: "actionView.button.surprise"), image: "\(themePrefix) - surprise me", action: .surprise, testId: "button-surpriseMe")
        let buttonSpeak = ButtonData(label: String(localized: "actionView.button.speak.hold"), image: "\(themePrefix) - press & hold", action: .speak, testId: "button-press&hold")
        let buttonMore = ButtonData(label: String(localized: "actionView.button.more"), image: "\(themePrefix) - more action", action: .openSettings, testId: "button-more")
        let buttonPlay = ButtonData(label: String(localized: "actionView.button.play"), image: "\(themePrefix) - pause play", pressedImage: "\(themePrefix) - play", action: .play, testId: "button-playPause", thinking: "\(themePrefix) - thinking")

        buttonsPortrait = [
            buttonReset,
            buttonTapSpeak,
            buttonSurprise,
            buttonSpeak,
            /*buttonRepeat*/
            buttonMore,
            buttonPlay
        ]

        // v1
        buttonsLandscape = [
            buttonReset,
            buttonTapSpeak,
            /*buttonRepeat*/
            buttonMore,
            buttonSurprise,
            buttonSpeak,
            buttonPlay
        ]
        // Disable idle timer when the view is created
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func changeTheme(name: String) {
        let theme = AppThemeSettings.fromString(name)
        currentTheme.setTheme(theme: theme)
    }
    
    var body: some View {
        let isLandscape = verticalSizeClass == .compact ? true : false
        let buttons = isLandscape ? buttonsLandscape : buttonsPortrait
        let colums = isLandscape ? 3 : 2
        Group {
                baseView(colums: colums, buttons: buttons)
        }.background(Color(hex: 0x1E1E1E).animation(.none))
            .onAppear(
                perform: {
                    SpeechRecognition.shared.setup()
                    Timer.scheduledTimer(withTimeInterval: Self.DelayBeforeShowingAlert, repeats: true) { _ in
                        let random = Double.random(in: 0.0 ..< 1.0)
                        if random < 0.5 {
                            self.showShareAlert = true
                            return
                        }
                        let daysElapsed = Calendar.current.dateComponents([.day], from: ReviewRequester.shared.lastReviewRequestDate ?? Date(timeIntervalSince1970: 0), to: Date()).day!
                        if daysElapsed < 120 {
                            self.showShareAlert = true
                        } else {
                            print("Days Elapsed \(daysElapsed)")
                            ReviewRequester.shared.tryPromptForReview(forced: true)
                        }
                    }
                    
                    // This is simply to confirm and retrieve the userID. While the keychain contains the Apple ID, it lacks the server's user ID.
                    if KeychainService.shared.isAppleIdAvailable() {
                        UserAPI().getUserBy(appleId: KeychainService.shared.retrieveAppleID() ?? "")
                    }
                    
                    if KeychainService.shared.isAppVersionAvailable() {
                        var appVersionFromKeyChain = KeychainService.shared.retrieveAppVersion()
                        if let appVersionFromBundle = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            if let keyChainVersion = appVersionFromKeyChain {
                                print("App version from bundle: \(appVersionFromBundle), app version from key chain: \(keyChainVersion)")
                            } else {
                                print("App version from bundle: \(appVersionFromBundle), app version from key chain: nil")
                            }
                            if appVersionFromBundle != appVersionFromKeyChain {
                                guard let serverAPIKey = AppConfig.shared.getServerAPIKey() else {
                                    print("Cannot get payments service API key")
                                    return
                                }
                                UserAPI().updateUser(apiKey: serverAPIKey, appVersion: appVersionFromBundle)
                            }
                        }
                    }
                    try? appSettings.isUpdateAvailable { (updateAvailable, version, error) in
                        if let error = error {
                            print("[isUpdateAvailable]: error", error)
                        } else if let updateAvailable = updateAvailable {
                            if let version = version {
                                print("[isUpdateAvailable]: ", updateAvailable, version)
                            } else {
                                print("[isUpdateAvailable]: ", updateAvailable, "nil")
                            }
                            if updateAvailable {
                                self.showNewAppVersionAlert = true
                                self.newAppVersion = version
                            }
                        }
                    }
                }
            )
            .edgesIgnoringSafeArea(.all)
            .onChange(of: scenePhase) { newPhase in
                switch newPhase {
                case .active:
                    print("App became active")
                    // SettingsBundleHelper.checkAndExecuteSettings()
                    _ = AppSettings.shared
                    if speechRecognition.checkContextChange() {
                        speechRecognition.reset()
                    }
                    keyWindow = UIApplication.shared.connectedScenes
                        .filter { $0.activationState == .foregroundActive }
                        .compactMap { $0 as? UIWindowScene }
                        .first?.windows
                        .filter { $0.isKeyWindow }.first
                    
                    if AppleSignInManager.shared.isShowIAPFromSignIn {
                        print("App isShowIAPFromSignIn active")
                        openPurchaseDialog()
                        AppleSignInManager.shared.isShowIAPFromSignIn = false
                    }
                case .inactive:
                    print("App became inactive")
                    speechRecognition.pause(feedback: false)
                case .background:
                    print("App moved to the background")
                @unknown default:
                    break
                }
            }
//                     .alert(isPresented: $showNewAppVersionAlert) {
//                         Alert(
//                             title: Text("actionsView.alert.newAppVersion.title"),
//                             message: Text("\(self.newAppVersion ?? "")"),
//                             primaryButton: .default(Text("actionsView.alert.newAppVersion.button1")) {
//                                 showNewAppVersionAlert = false
//                                 if let url = URL(string: appSettings.appStoreUrl) {
//                                     UIApplication.shared.open(url)
//                                 }
//                             },
//                             secondaryButton: .default(Text("button.cancel")) {
//                                 showNewAppVersionAlert = false
//                             }
//                         )
//                     }
        //            .alert(isPresented: $showShareAlert) {
        //                Alert(
        //                    title: Text("Share the app with friends?"),
        //                    message: Text("Send the link: x.country/app"),
        //                    primaryButton: .default(Text("Sure!")) {
        //                        showShareSheet = true
        //                    },
        //                    secondaryButton: .default(Text("button.cancel")) {
        //                        showShareAlert = false
        //                    }
        //                )
        //            }

        // TODO: Remove the orientation logic for now
        // .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
        //             if UIDevice.current.orientation != orientation {
        //                 if isRecording {
        //                     isRecordingContinued = true

        //                     print("Recording stopSpeak...")
        //                     SpeechRecognition.shared.cancelSpeak()
        //                 }
        //                 orientation = UIDevice.current.orientation
        //             }
        //         }
    }
    
    func isButtonDisabled (action: ActionType) -> Bool {
        return (self.lastButtonPressed != nil) && self.lastButtonPressed != action
    }
    
    func getLastButtonPressed() -> ActionType? {
        return self.lastButtonPressed
    }
    
    func setLastButtonPressed (action: ActionType, event: EventType?) {
        if event == .onStart {
            self.lastButtonPressed = action
            
            if self.isTapToSpeakActive {
                self.isTapToSpeakActive = !self.isTapToSpeakActive
            }
        }
        
        if event == .onEnd {
            self.lastButtonPressed = nil
        }
    }

    func baseView(colums: Int, buttons: [ButtonData]) -> some View {
        return GeometryReader { geometry in
            let gridItem = GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0)
            let columns = Array(repeating: gridItem, count: colums)
            let numOfRows: Int = .init(ceil(Double(buttons.count) / Double(colums)))
            let height = geometry.size.height / CGFloat(numOfRows)

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(buttons) { button in
                    viewButton(button: button, actionHandler: self.actionHandler)
                        .frame(minHeight: height, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0x1E1E1E).animation(.none))
        }
        .padding(0)
        .sheet(isPresented: $showShareSheet, onDismiss: { showShareSheet = false }) {
            let url = URL(string: "https://apps.apple.com/us/app/voice-ai-talk-with-gpt4/id6470936896")!
            let shareLink = ShareLink(title: "Check out this Voice AI app! x.country/app", url: url)

            ActivityView(activityItems: [shareLink.title, shareLink.url])
        }
    }

    func vibration() {
        if ActionsView.generator == nil {
            ActionsView.generator = UIImpactFeedbackGenerator(style: .medium)
        }
        ActionsView.generator?.prepare()
        ActionsView.generator?.impactOccurred()
    }
    
    @ViewBuilder
    private func createDefaultButton(button: ButtonData, actionHandler: ActionHandlerProtocol) -> some View {
        let isActive = (button.action == .play && speechRecognition.isPlaying() && !isSpeakButtonPressed)
        
        GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive) {event in
            self.setLastButtonPressed(action: button.action, event: event)
            if event != nil {
                return
            }
            self.vibration()
            Task {
                await handleOtherActions(actionType: button.action)
            }
        }.accessibilityIdentifier(button.testId)
        .disabled(self.isButtonDisabled(action: button.action))
    }
    
    @ViewBuilder
    private func createSpeakButton(button: ButtonData, actionHandler: ActionHandlerProtocol) -> some View {
        if button.pressedLabel != nil {
            // Press to Speak & Press to Send
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: self.isTapToSpeakActive, isPressed: self.isTapToSpeakActive, clickCounterStartOn: 100) {event in
                if event != nil {
                    return
                }

               self.isTapToSpeakActive = !self.isTapToSpeakActive
               self.vibration()
               self.tapToSpeakDebounceTimer?.invalidate()
                MixpanelManager.shared.trackEvent(name: "Tap to Speak", properties: nil)

                if String(actionHandler.isTapToSpeakActive) != String(self.isTapToSpeakActive) {
                    self.tapToSpeakDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in

                        Task {
                            if !actionHandler.isTapToSpeakActive {
                                actionHandler.handle(actionType: ActionType.tapSpeak)
                            } else {
                                actionHandler.handle(actionType: ActionType.tapStopSpeak)
                            }
                        }
                    }
                }
            }
            .disabled(self.isButtonDisabled(action: .tapSpeak))
            .accessibilityIdentifier(button.testId)
        } else {
            // Press & Hold
            
            let isPressed: Bool = true
            
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isSpeakButtonPressed, isPressed: isPressed) {event in
                self.setLastButtonPressed(action: button.action, event: event)
                speechRecognition.isThinking = false
                if event != nil {
                    return
                }
                self.vibration()
                MixpanelManager.shared.trackEvent(name: "Press & Hold", properties: nil)

            }.simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        self.setLastButtonPressed(action: button.action, event: .onStart)
                        
                        self.speakButtonDebounceTimer?.invalidate()
                        
                        if self.isSpeakButtonPressed == false {
                            self.speakButtonDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                                actionHandler.handle(actionType: ActionType.speak)
                            }
                        }
                        self.isSpeakButtonPressed = true
                    }
                    .onEnded { _ in
                        self.setLastButtonPressed(action: button.action, event: .onEnd)
                        
                        self.speakButtonDebounceTimer?.invalidate()
                        self.isSpeakButtonPressed = false
                        
                        if actionHandler.isPressAndHoldActive {
                            actionHandler.handle(actionType: ActionType.stopSpeak)
                        }
                    }
            ).accessibilityIdentifier(button.testId)
            .disabled(self.isButtonDisabled(action: button.action))
        }
    }
    
    @ViewBuilder
    private func createActionButton(button: ButtonData, actionHandler: ActionHandlerProtocol) -> some View {
        let isActive = (button.action == .play && speechRecognition.isPlaying() && !isSpeakButtonPressed)
        
        if button.action == .openSettings {
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive) {event in
                self.setLastButtonPressed(action: button.action, event: event)
                if event != nil {
                    return
                }
                self.vibration()
                DispatchQueue.main.async {
                    openSettingsApp()
                }
            }
            .accessibilityIdentifier(button.testId)
            .disabled(self.isButtonDisabled(action: button.action))

        } else if button.action == .play {
            let isPressed: Bool = isActive && speechRecognition.isPaused()
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: speechRecognition.isThinking ? true : isActive, isPressed: isPressed, isThinking: speechRecognition.isThinking) {event in
                self.setLastButtonPressed(action: button.action, event: event)
                if event != nil {
                    return
                }
                self.vibration()
                MixpanelManager.shared.trackEvent(name: "Play", properties: nil)

                Task {
                    await handleOtherActions(actionType: button.action)
                }
            }
            .background(GeometryReader { geometry in
                Color.clear.onAppear {
                    // Capture the button's frame size to use as the maximum distance for the long press gesture
                    buttonFrame = geometry.frame(in: .local)
                }
            })
            .accessibilityIdentifier(button.testId)
            .disabled(self.isButtonDisabled(action: button.action))

        } else if button.action == .reset {
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive) {event in
                self.setLastButtonPressed(action: button.action, event: event)
                if event != nil {
                    return
                }
                self.vibration()
                Task {
                    MixpanelManager.shared.trackEvent(name: "New Session", properties: nil)
                    await handleOtherActions(actionType: button.action)
                    self.resetClickCounter += 1
                    if self.resetClickCounter >= self.maxResetClicks {
                        self.resetClickCounter = 0
                        let number = Int.random(in: 0 ..< 4)
                        if number == 1 {
                           ReviewRequester.shared.tryPromptForReview(forced: true)
//                            showInAppPurchasesIfNotLoggedIn()

                        }
                    }
                }
            }
            .accessibilityIdentifier(button.testId)
            .disabled(self.isButtonDisabled(action: button.action))
        } else if button.action == .surprise {
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive, isButtonEnabled: isSurpriseButtonPressed) {event in
                self.setLastButtonPressed(action: button.action, event: event)
                if event != nil {
                    return
                }
                self.vibration()
                MixpanelManager.shared.trackEvent(name: "Surprise Me", properties: nil)

                if self.isSurpriseButtonPressed {
                    self.isSurpriseButtonPressed = false
                    Task {
                        await handleOtherActions(actionType: button.action)
                        do {
                            try await Task.sleep(nanoseconds: 1 * 500_000_000)
                        } catch {
                            print("Sleep failed")
                        }
                        self.isSurpriseButtonPressed = true
                    }
                }
            }
            .accessibilityIdentifier(button.testId)
            .disabled(self.isButtonDisabled(action: button.action))
            // .onStart: { self.lastActionPressed = .surprise }
        }
    }

    @ViewBuilder
    func viewButton(button: ButtonData, actionHandler: ActionHandlerProtocol) -> some View {
        switch button.action {
        case .speak:
            self.createSpeakButton(button: button, actionHandler: actionHandler)
        case .openSettings,
                .play,
                .reset,
                .surprise:
            self.createActionButton(button: button, actionHandler: actionHandler)
        default:
            self.createDefaultButton(button: button, actionHandler: actionHandler)
        }
    }

    func openSettingsApp() {
        MixpanelManager.shared.trackEvent(name: "More Actions", properties: nil)
        self.appSettings.showActionSheet(type: .settings)
        print("Show settings")
//        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url)
//        }
    }

    func handleOtherActions(actionType: ActionType) async {
        actionHandler.handle(actionType: actionType)
    }

    func checkUserAuthentication() {
        if KeychainService.shared.isAppleIdAvailable() {
            // User ID is available, proceed with automatic login or similar functionality
            openPurchaseDialog()
        } else {
            // User ID not found, prompt user to log in or register
            if let keyWindow = keyWindow {
                AppleSignInManager.shared.performAppleSignIn(using: keyWindow)
            }
        }
    }

    func openPurchaseDialog() {
        DispatchQueue.main.async {
            Task {
                if self.store.products.isEmpty {
                    print("[ActionsView] No products available")
                } else {
                    let product = self.store.products[0]
                    do {
                        try await self.store.purchase(product)
                    } catch {
                        print("[ActionsView] Error during purchase")
                    }
                }
            }
        }
    }
    
    func showInAppPurchasesIfNotLoggedIn() {
        if KeychainService.shared.isAppleIdAvailable() == false || 
            KeychainService.shared.retrieveIsSubscriptionActive() {
            openPurchaseDialog()
        }
    }
}
//
// #Preview {
//    NavigationView {
//        ActionsView() // actionHandler: nil)
//    }
// }
