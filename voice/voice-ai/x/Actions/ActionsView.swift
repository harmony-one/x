import Combine
import Foundation
import StoreKit
import SwiftUI
import AudioToolbox
import CoreHaptics
import UIKit

struct ActionsView: View {
    let config = AppConfig.shared
    
    @ObservedObject private var timerManager = TimerManager.shared

    @State var currentTheme: Theme = .init()

    func changeTheme(name: String) {
        let theme = AppThemeSettings.fromString(name)
        currentTheme.setTheme(theme: theme)
    }

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
    
    @State private var orientation = UIDevice.current.orientation
    @StateObject var actionHandler: ActionHandler = .init()
    @EnvironmentObject var store: Store
    @State private var skipPressedTimer: Timer? = nil

    @State private var buttonFrame: CGRect = .zero
    @State private var tapCount: Int = 0
    
    @State private var showShareSheet: Bool = false
    @State private var showShareAlert: Bool = false
    
    static let DelayBeforeShowingAlert: TimeInterval = 600 // seconds
    
    @ObservedObject var speechRecognition = SpeechRecognition.shared
    
    let oneValue = "2111.01 ONE "
    
    var buttonsPortrait: [ButtonData] = []
    var buttonsLandscape: [ButtonData] = []
    
    @State private var storage = Set<AnyCancellable>()
    
    @State private var keyWindow: UIWindow?

    let maxResetClicks = 10
    @State private var resetClickCounter = 0
    
    init() {
        let theme = AppThemeSettings.fromString(config.getThemeName())
        currentTheme.setTheme(theme: theme)

        let themePrefix = currentTheme.name
        let buttonReset = ButtonData(label: "New Session", image: "\(themePrefix) - new session", action: .reset)
//        let buttonSayMore = ButtonData(label: "Say More", image: "\(themePrefix) say more", action: .sayMore)
//        let buttonUserGuide = ButtonData(label: "User Guide", image: "\(themePrefix) - user guide", action: .userGuide)
        let buttonTapSpeak = ButtonData(label: "Tap to SPEAK", pressedLabel: "Tap to SEND", image: "\(themePrefix) - square", action: .speak)
        let buttonSurprise = ButtonData(label: "Surprise ME!", image: "\(themePrefix) - random fact", action: .surprise)
        let buttonSpeak = ButtonData(label: "Press & Hold", image: "\(themePrefix) - press & hold", action: .speak)
        let buttonRepeat = ButtonData(label: "Repeat Last", image: "\(themePrefix) - repeat last", action: .repeatLast)
        let buttonPlay = ButtonData(label: "Pause / Play", image: "\(themePrefix) - pause play", pressedImage: "\(themePrefix) - play", action: .play)
        
//        changeTheme(name: config.getThemeName())
        buttonsPortrait = [
            buttonReset,
//            buttonSayMore,
//            buttonUserGuide,gi
            buttonTapSpeak,
            buttonSurprise,
            buttonSpeak,
            buttonRepeat,
            buttonPlay
        ]
        
        // v2
//        buttonsLandscape = [
//            buttonRepeat,
//            buttonRandom,
//            buttonReset,
//            buttonPlay,
//            buttonSpeak,
//            buttonSkip,
//        ]
        
        // v1
        buttonsLandscape = [
            buttonReset,
//            buttonSayMore,
//            buttonUserGuide,
            buttonTapSpeak,
            buttonRepeat,
            buttonSurprise,
            buttonSpeak,
            buttonPlay
        ]
        // Disable idle timer when the view is created
        UIApplication.shared.isIdleTimerDisabled = true
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
                        let r = Double.random(in: 0.0 ..< 1.0)
                        if r < 0.5 {
                            self.showShareAlert = true
                            return
                        }
                        let daysElapsed = Calendar.current.dateComponents([.day], from: ReviewRequester.shared.lastReviewRequestDate ?? Date(timeIntervalSince1970: 0), to: Date()).day!
                        if daysElapsed < 120 {
                            self.showShareAlert = true
                        } else {
                            ReviewRequester.shared.tryPromptForReview(forced: true)
                        }
                    }
                    
                    // This is simply to confirm and retrieve the userID. While the keychain contains the Apple ID, it lacks the server's user ID.
                    if KeychainService.shared.isAppleIdAvailable() {
                        UserAPI().getUserBy(appleId: KeychainService.shared.retrieveAppleID() ?? "")
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
                    if (speechRecognition.checkContextChange()) {
                        speechRecognition.reset()
                    }
                    keyWindow = UIApplication.shared.connectedScenes
                        .filter { $0.activationState == .foregroundActive }
                        .compactMap { $0 as? UIWindowScene }
                        .first?.windows
                        .filter { $0.isKeyWindow }.first
                    
                    if AppleSignInManager.shared.isShowIAPFromSignIn {
                        print("App isShowIAPFromSignIn active")
                        showPurchaseDiglog()
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
//            .alert(isPresented: $showShareAlert) {
//                Alert(
//                    title: Text("Share the app with friends?"),
//                    message: Text("Send the link: x.country/app"),
//                    primaryButton: .default(Text("Sure!")) {
//                        showShareSheet = true
//                    },
//                    secondaryButton: .default(Text("Cancel")) {
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
    
    func baseView(colums: Int, buttons: [ButtonData]) -> some View {
        return GeometryReader { geometry in
            let gridItem = GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0)
            let columns = Array(repeating: gridItem, count: colums)
            let numOfRows: Int = .init(ceil(Double(buttons.count) / Double(colums)))
            let height = geometry.size.height / CGFloat(numOfRows)
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(buttons) { button in
                    viewButton(button: button).frame(minHeight: height, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0x1E1E1E).animation(.none))
        }
        .padding(0)
        .sheet(isPresented: $showShareSheet, onDismiss: { showShareSheet = false }) {
            let url = URL(string: "https://testflight.apple.com/join/TXohwYOn")!
            let shareLink = ShareLink(title: "Check out this Voice AI app! x.country/app", url: url)
            
            ActivityView(activityItems: [shareLink.title, shareLink.url])
        }
    }

    func vibration() {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
    }
    
    @ViewBuilder
    func viewButton(button: ButtonData) -> some View {
        let isActive = (button.action == .play && speechRecognition.isPlaying() && !isSpeakButtonPressed)

        if button.action == .speak {
            if button.pressedLabel != nil {
                // Press to Speak & Press to Send
                GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: actionHandler.isTapToSpeakActive, isPressed: actionHandler.isTapToSpeakActive) {
                 self.vibration()
                  Task {
                        if !actionHandler.isTapToSpeakActive {
                            actionHandler.handle(actionType: ActionType.tapSpeak)
                        } else {
                            actionHandler.handle(actionType: ActionType.tapStopSpeak)
                        }
                    }
                }
                .simultaneousGesture(LongPressGesture(maximumDistance: max(buttonFrame.width, buttonFrame.height)).onEnded { _ in
                    Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { _ in
                        actionHandler.handle(actionType: ActionType.tapStopSpeak)
                       
                    }
//                    DispatchQueue.main.async {
//                        let url = URL(string: "https://x.country/voice")
//                        if UIApplication.shared.canOpenURL(url!) {
//                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//                        } else {
//                            print("Cannot open URL")
//                        }
//                    }
                })
            } else {
                // Press & Hold

                let isPressed: Bool = true

                GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isSpeakButtonPressed, isPressed: isPressed) {}.simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if self.isSpeakButtonPressed == false {
                                actionHandler.handle(actionType: ActionType.speak)
                            }
                            self.isSpeakButtonPressed = true
                        }
                        .onEnded { _ in
                            self.isSpeakButtonPressed = false
                            actionHandler.handle(actionType: ActionType.stopSpeak)
                        }
                )
            }
        } else if button.action == .repeatLast {
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive) {
              self.vibration()
                Task {
                    await handleOtherActions(actionType: button.action)
                }
            }
            .simultaneousGesture(LongPressGesture(maximumDistance: max(buttonFrame.width, buttonFrame.height)).onEnded { _ in
                DispatchQueue.main.async {
                    let url = URL(string: "https://x.com/intent/tweet?text=hey+@voiceaiapp+")
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    } else {
                        print("Cannot open URL")
                    }
                }
            })

        } else if button.action == .play {
            let isPressed: Bool = isActive && speechRecognition.isPaused()
            
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive, isPressed: isPressed) {
              self.vibration()
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
            .simultaneousGesture(LongPressGesture(maximumDistance: max(buttonFrame.width, buttonFrame.height)).onEnded { _ in
                DispatchQueue.main.async {
                    openSettingsApp()
                }
            }).accessibilityIdentifier("button-play")
//            .simultaneousGesture(
//                LongPressGesture(minimumDuration: 5).onEnded { _ in
//                    self.timerManager.resetTimer()
//                    speechRecognition.isTimerDidFired = false
//                    print("Timer reset after long press.")
//                }
//            )
            
        } else if button.action == .reset {
            
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive) {
              self.vibration()
                Task {
                    await handleOtherActions(actionType: button.action)
                    self.resetClickCounter += 1
                    if (self.resetClickCounter >= self.maxResetClicks) {
                        self.resetClickCounter = 0
                        let number = Int.random(in: 0 ..< 4)
                        if (number == 1) {
                            ReviewRequester.shared.tryPromptForReview(forced: true)
                        }
                        
                    }
                }
            }
            .simultaneousGesture(LongPressGesture(maximumDistance: max(buttonFrame.width, buttonFrame.height)).onEnded { _ in
                self.checkUserAuthentication()
            })
        } else if button.action == .surprise {
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive) {
              self.vibration()
                Task {
                    await handleOtherActions(actionType: button.action)
                }
            }
            .simultaneousGesture(LongPressGesture(maximumDistance: max(buttonFrame.width, buttonFrame.height)).onEnded { _ in
                self.showShareSheet = true
            }).accessibilityIdentifier("randomfact")
        } else {
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive) {
              self.vibration()
                Task {
                    await handleOtherActions(actionType: button.action)
                }
            }
        }
    }
    
    
    func openSettingsApp() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func requestReview() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.windows.first?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
    
    func handleOtherActions(actionType: ActionType) async {
        actionHandler.handle(actionType: actionType)
    }
    
    func checkUserAuthentication() {
        if KeychainService.shared.isAppleIdAvailable() {
            // User ID is available, proceed with automatic login or similar functionality
            showPurchaseDiglog()
        } else {
            // User ID not found, prompt user to log in or register
            if let keyWindow = keyWindow {
                AppleSignInManager.shared.performAppleSignIn(using: keyWindow)
            }
        }
    }
    
    func showPurchaseDiglog() {
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

#Preview {
    NavigationView {
        ActionsView()
    }
}
