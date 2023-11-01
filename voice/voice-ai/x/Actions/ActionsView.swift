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
    @State private var isRecording = false
    @State private var isRecordingContinued = false
    @State private var orientation = UIDevice.current.orientation
    @StateObject var actionHandler: ActionHandler = ActionHandler()
    
    @ObservedObject var speechRecognition = SpeechRecognition.shared
    
    let oneValue = "2111.01 ONE"
    
    let buttonsPortrait: [ButtonData] = [
        ButtonData(label: "New Session", image: "new session", action: .reset),
        ButtonData(label: "Skip 5 Seconds", image: "skip 5 seconds", action: .skip),
        ButtonData(label: "Random Fact", image: "random fact", action: .randomFact),
        ButtonData(label: "Press to Speak", image: "press to speak", action: .speak),
        ButtonData(label: "Repeat Last", image: "repeat last", action: .repeatLast),
        ButtonData(label: "Pause / Play", image: "pause play", action: .play),
    ]
    
    let buttonsLandscape: [ButtonData] = [
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
        let isActive =
        ( button.action == .speak && !speechRecognition.isPaused() )
        || ( button.action == .play && speechRecognition.isPlaying() )
        
        if button.action == .speak {
            GridButton(button: button, geometry: geometry, foregroundColor: .black, active: isActive ) {
                handleOtherActions(actionType: button.action)
            }
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.0)
                    .onEnded { _ in handleOtherActions(actionType: button.action)}
            )
        } else {
            GridButton(button: button, geometry: geometry, foregroundColor: .black, active: isActive) {
                handleOtherActions(actionType: button.action)
            }
        }
    }
    
    func startRecording() {
            isRecording = true
            // Start your recording logic here
            print("Started Recording...")
        }
        
    func stopRecording() {
        if isRecording {
            isRecording = false
            // Stop your recording logic here
            print("Stopped Recording")
            SpeechRecognition.shared.stopSpeak()
        }
    }
    
    func handleOtherActions(actionType: ActionType) {
        actionHandler.handle(actionType: actionType)
    }
    
}
