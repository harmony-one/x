//
//  ActionsView.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 20/10/23.
//

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
    
    @ObservedObject var speechRecognition = SpeechRecognition.shared
    
    let oneValue = "2111.01 ONE"
    
    let buttonReset = ButtonData(label: "New Session", image: "new session", action: .reset)
    let buttonSkip = ButtonData(label: "Skip 5 Seconds", image: "skip 5 seconds", action: .skip)
    let buttonRandom = ButtonData(label: "Random Fact", image: "random fact", action: .randomFact)
    let buttonSpeak = ButtonData(label: "Press to Speak", image: "press to speak", action: .speak)
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
    }
    
    var body: some View {
        let isLandscape = verticalSizeClass == .compact ? true : false
        let buttons = isLandscape ? buttonsLandscape : buttonsPortrait
        let colums = isLandscape ? 3 : 2
        Group {
            baseView(colums: colums, buttons: buttons)
        }.onAppear(
            perform: SpeechRecognition.shared.setup
        )
        .edgesIgnoringSafeArea(.all)
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                print("App became active")
            case .inactive:
                print("App became inactive")
//                speechRecognition.reset(feedback: false)
                speechRecognition.pause()
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
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0), count: colums), spacing: 0) {
                    ForEach(buttons) { button in
                        viewButton(button: button, geometry: geometry)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(0)
            .scrollDisabled(true)
        }
    }
    
    @ViewBuilder
    func viewButton(button: ButtonData, geometry: GeometryProxy) -> some View {
        let isActive = (button.action == .play && speechRecognition.isPlaying() && !self.isSpeakButtonPressed)

        if button.action == .speak {
            GridButton(button: button, geometry: geometry, foregroundColor: .black, active: self.isSpeakButtonPressed) {}.simultaneousGesture(
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
        } else {
            GridButton(button: button, geometry: geometry, foregroundColor: .black, active: isActive) {
                handleOtherActions(actionType: button.action)
            }
        }
    }
    
    func handleOtherActions(actionType: ActionType) {
        actionHandler.handle(actionType: actionType)
    }
}
