import Foundation
import SwiftUI

struct ActionsView: View {
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
    
    @ObservedObject var speechRecognition = SpeechRecognition.shared
    
    let oneValue = "2111.01 ONE"
    
    let themePrefix:String = "blackredTheme -"

    
    let buttonsPortrait: [ButtonData]
    let buttonsLandscape: [ButtonData]
    
    init() {

        let buttonReset = ButtonData(label: "New Session", image: "\(themePrefix) new session", action: .reset)
//        let buttonSayMore = ButtonData(label: "Say More", image: "\(themePrefix) say more", action: .sayMore)
//        let buttonUserGuide = ButtonData(label: "User Guide", image: "\(themePrefix) user guide", action: .userGuide)
        let buttonTapSpeak = ButtonData(label: "Tap to Speak", image: "\(themePrefix) user guide", action: .tapSpeak)
        let buttonRandom = ButtonData(label: "Surprise Me!", image: "\(themePrefix) random fact", action: .randomFact)
        let buttonSpeak = ButtonData(label: "Press & Hold", image: "\(themePrefix) press & hold", action: .speak)
        let buttonRepeat = ButtonData(label: "Repeat Last", image: "\(themePrefix) repeat last", action: .repeatLast)
        let buttonPlay = ButtonData(label: "Pause / Play", image: "\(themePrefix) pause play", pressedImage: "\(themePrefix) play", action: .play)
        
        buttonsPortrait = [
            buttonReset,
//            buttonSayMore,
//            buttonUserGuide,
            buttonTapSpeak,
            buttonRandom,
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
            buttonRandom,
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
    }
    
    @ViewBuilder
    func viewButton(button: ButtonData) -> some View {
        let isActive = (button.action == .play && speechRecognition.isPlaying() && !self.isSpeakButtonPressed)

        if button.action == .speak {
            let isPressed: Bool = true
            
            GridButton(button: button, foregroundColor: .black, active: self.isSpeakButtonPressed, isPressed: isPressed) {}.simultaneousGesture(
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
        } else if button.action == .repeatLast {
            GridButton(button: button, foregroundColor: .black, active: isActive) {
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
            
            GridButton(button: button, foregroundColor: .black, active: isActive, isPressed: isPressed) {
                Task {
                    await handleOtherActions(actionType: button.action)
                }
            }
            
        } else if button.action == .tapSpeak {
            
            let isPressed: Bool = isActive && speechRecognition.isPaused()
            
            GridButton(button: button, foregroundColor: .black, active: isActive, isPressed: isPressed) {
                Task {
                    await handleOtherActions(actionType: button.action)
                }
            }
            
        } else {
            GridButton(button: button, foregroundColor: .black, active: isActive) {
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
