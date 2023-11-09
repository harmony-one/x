import Foundation
import SwiftUI
import Combine



struct ActionsView: View {
    let config = AppConfig()

    @State var currentTheme:Theme = Theme()

    func changeTheme(name: String){
        let theme = AppThemeSettings.fromString(name)
        self.currentTheme.setTheme(theme: theme)
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
    
    @ObservedObject var speechRecognition = SpeechRecognition.shared
    
    let oneValue = "2111.01 ONE"
    
    var buttonsPortrait: [ButtonData] = []
    var buttonsLandscape: [ButtonData] = []
    
    @State private var storage = Set<AnyCancellable>()
    
    init() {
        let theme = AppThemeSettings.fromString(config.getThemeName())
        currentTheme.setTheme(theme: theme)

        let themePrefix = self.currentTheme.name
        let buttonReset = ButtonData(label: "New Session", image: "\(themePrefix) - new session", action: .reset)
//        let buttonSayMore = ButtonData(label: "Say More", image: "\(themePrefix) say more", action: .sayMore)
//        let buttonUserGuide = ButtonData(label: "User Guide", image: "\(themePrefix) - user guide", action: .userGuide)
        let buttonTapSpeak = ButtonData(label: "Tap to Speak", pressedLabel: "Tap to Send", image: "\(themePrefix) - press & hold", action: .speak)
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
            perform: SpeechRecognition.shared.setup
        )
        .edgesIgnoringSafeArea(.all)
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                print("App became active")
            case .inactive:
                print("App became inactive")
                speechRecognition.pause(feedback: false)
            case .background:
                print("App moved to the background")
            @unknown default:
                break
            }
        }
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
            let numOfRows: Int = Int(ceil(Double(buttons.count) / Double(colums)))
            let height = geometry.size.height / CGFloat(numOfRows);
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(buttons) { button in
                    viewButton(button: button).frame(minHeight: height, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0x1E1E1E).animation(.none))
        }
        .padding(0)
        .sheet(isPresented: $showShareSheet, onDismiss: {showShareSheet = false}) {
            let url = URL(string: "https://x.country")!
            let shareLink = ShareLink(title: "Voice AI App", url: url)
            
            ActivityView(activityItems: [shareLink.title, shareLink.url])
        }
    }
    
    @ViewBuilder
    func viewButton(button: ButtonData) -> some View {
        let isActive = (button.action == .play && speechRecognition.isPlaying() && !self.isSpeakButtonPressed)

        if button.action == .speak {
            if button.pressedLabel != nil {
                // Press to Speak & Press to Send
                GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: actionHandler.isTapToSpeakActive, isPressed: actionHandler.isTapToSpeakActive) {
                    Task {
                        if !actionHandler.isTapToSpeakActive {
                            actionHandler.handle(actionType: ActionType.tapSpeak)
                        } else {
                            actionHandler.handle(actionType: ActionType.tapStopSpeak)
                        }
                    }
                }

            } else {
                // Press & Hold

                let isPressed: Bool = true

                GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: self.isSpeakButtonPressed, isPressed: isPressed) {}.simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            self.isSpeakButtonPressed = true;
                            actionHandler.handle(actionType: ActionType.speak)
                        }
                        .onEnded { _ in
                            self.isSpeakButtonPressed = false;
                            actionHandler.handle(actionType: ActionType.stopSpeak)
                        }
                )
            }
        } else if button.action == .repeatLast {
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive) {
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
                    })
        } else if button.action == .play {
            
            let isPressed: Bool = isActive && speechRecognition.isPaused()
            
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive, isPressed: isPressed) {
                Task {
                    await handleOtherActions(actionType: button.action)
                }
            }
            
        } else if button.action == .reset {
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive) {
                Task {
//                    tapCount += 1
//                    
//                    if tapCount % 7 == 0 {
//                        showShareSheet = true
//                    }
                    await handleOtherActions(actionType: button.action)
                }
            }
        } else if button.action == .surprise {
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive) {
                Task {
                    await handleOtherActions(actionType: button.action)
                }
            }
            .simultaneousGesture(LongPressGesture(maximumDistance: max(buttonFrame.width, buttonFrame.height)).onEnded { _ in
                self.showShareSheet = true
            })
        } else {
            GridButton(currentTheme: currentTheme, button: button, foregroundColor: .black, active: isActive) {
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
    
    func handleOtherActions(actionType: ActionType) async {
//        if(actionType == .skip) {
//            let product = store.products[0]
//            let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
//                            Task {
//                                try await self.store.purchase(product)
//                            }
//                }
//        }
        actionHandler.handle(actionType: actionType)
    }
}
