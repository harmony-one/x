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
    @State private var orientation = UIDevice.current.orientation
    @StateObject var actionHandler: ActionHandler = .init()
    
    @ObservedObject var speechRecognition = SpeechRecognition.shared
    
    let oneValue = "2111.01 ONE"
    
    @State private var buttonsPortrait: [ButtonData] = [
        ButtonData(label: "New Session", image: "new session", action: .reset),
        ButtonData(label: "Skip 5 Seconds", image: "skip 5 seconds", action: .skip),
        ButtonData(label: "Random Fact", image: "random fact", action: .randomFact),
        ButtonData(label: "Press to Speak", image: "press to speak", action: .speak),
        ButtonData(label: "Repeat Last", image: "repeat last", action: .repeatLast),
        ButtonData(label: "Pause / Play", image: "pause play", action: .play),
    ]
    
    @State private var buttonsLandscape: [ButtonData] = [
        ButtonData(label: "New Session", image: "new session", action: .reset),
        ButtonData(label: "Skip 5 Seconds", image: "skip 5 seconds", action: .skip),
        ButtonData(label: "Repeat Last", image: "repeat last", action: .repeatLast),
        ButtonData(label: "Random Fact", image: "random fact", action: .randomFact),
        ButtonData(label: "Press to Speak", image: "press to speak", action: .speak),
        ButtonData(label: "Pause / Play", image: "pause play", action: .play),
    ]
    
    init() {
        // Disable idle timer when the view is created
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    var body: some View {
        Group {
            if verticalSizeClass == .compact {
                landscapeView
            } else {
                portraitView
            }
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
                speechRecognition.reset(feedback: false)
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
    
    var landscapeView: some View {
        baseView(colums: 3, buttons: buttonsLandscape)
    }
    
    var portraitView: some View {
        baseView(colums: 2, buttons: buttonsPortrait)
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
        let isActive = (button.action == .play && speechRecognition.isPlaying())

        if button.action == .speak {
            GridButton(button: button, geometry: geometry, foregroundColor: .black, active: false) {}.simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        actionHandler.handle(actionType: ActionType.speak)
                    }
                    .onEnded { _ in
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
