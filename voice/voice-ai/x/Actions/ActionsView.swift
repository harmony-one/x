//
//  ActionsView.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 20/10/23.
//

import Foundation
import SwiftUI



struct ActionsView: View {
    let config = AppConfig()
    
    @State var currentTheme:Theme = Theme()
    
    func changeTheme(name: String){
        let themeManager = ThemeManager()
        let themeName = ThemeName.fromString(name)
        self.currentTheme = themeManager.getThemeByName(themeName)
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
    
    @ObservedObject var speechRecognition = SpeechRecognition.shared
    
    let oneValue = "2111.01 ONE"
    
    let buttonReset = ButtonData(label: "New Session", image: "new session", action: .reset)
    let buttonSkip = ButtonData(label: "Skip 5 Seconds", image: "skip 5 seconds", action: .skip)
    let buttonRandom = ButtonData(label: "Random Fact", image: "random fact", action: .randomFact)
    let buttonSpeak = ButtonData(label: "Press & Hold", image: "press & hold", action: .speak)
    let buttonRepeat = ButtonData(label: "Repeat Last", image: "repeat last", action: .repeatLast)
    let buttonPlay = ButtonData(label: "Pause / Play", image: "pause play", action: .play)
    
    let buttonsPortrait: [ButtonData]
    let buttonsLandscape: [ButtonData]
    
    init() {
        buttonsPortrait = [
            buttonReset,
            buttonSkip,
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
            buttonSkip,
            buttonRepeat,
            buttonRandom,
            buttonSpeak,
            buttonPlay
        ]
        // Disable idle timer when the view is created
        UIApplication.shared.isIdleTimerDisabled = true
        changeTheme(name: config.getThemeName())
    }
    
    var body: some View {
        let isLandscape = verticalSizeClass == .compact ? true : false
        let buttons = isLandscape ? buttonsLandscape : buttonsPortrait
        let colums = isLandscape ? 3 : 2
        Group {
            baseView(colums: colums, buttons: buttons)
        }.background(Color(hex: 0xDDF6FF).animation(.none))
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
            .background(Color(hex: 0xDDF6FF).animation(.none))
        }
        .padding(0)
    }
    
    @ViewBuilder
    func viewButton(button: ButtonData) -> some View {
        let isActive = (button.action == .play && speechRecognition.isPlaying() && !self.isSpeakButtonPressed)

        if button.action == .speak {
            GridButton(button: button, foregroundColor: .black, active: self.isSpeakButtonPressed) {}.simultaneousGesture(
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
        } else if button.action == .skip {
            GridButton(button: button, foregroundColor: .black, active: false) {}.simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        actionHandler.handle(actionType: ActionType.speak)
                        if(self.skipPressedTimer == nil) {
                            if(!store.products.isEmpty) {
                                let product = store.products[0]
                                self.skipPressedTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
                                        Task {
                                            print("Purchase product: \(product)")
                                            try await self.store.purchase(product)
                                        }
                                        timer.invalidate()
                                    }
                                print("Start skip button pressed timer")
                            } else {
                                print("Cannot purchase: products list is empty. Check productId in IAP Store.")
                            }
                        }
                        }
                    .onEnded { _ in
                        if(self.skipPressedTimer != nil) {
                            self.skipPressedTimer?.invalidate()
                            self.skipPressedTimer = nil
                            print("Destroy skip button pressed timer")
                        }
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
                    .simultaneousGesture(LongPressGesture(minimumDuration: 2.8, maximumDistance: max(buttonFrame.width, buttonFrame.height)).onEnded { _ in
                        DispatchQueue.main.async {
                            openSettingsApp()
                        }
                    })
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
