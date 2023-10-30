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
    @State private var scale: CGFloat = 1.2
    @StateObject var actionHandler: ActionHandler = ActionHandler()
    
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
        ZStack {
            Group {
                if verticalSizeClass == .compact {
                    landscapeView
                } else {
                    portraitView
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onChange(of: actionHandler.isSynthesizing) { newValue in
            if newValue {
                print("isSynthesizing is now true")
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    // Update your view's animation state here
                }
            } else {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    // Update your view's animation state here
                }
            }
        }
        .onAppear(perform: SpeechRecognition.shared.setup)
        .onAppear {
            actionHandler.onSynthesizingChanged = { [weak actionHandler] newIsSynthesizing in
                DispatchQueue.main.async {
                    actionHandler?.isSynthesizing = newIsSynthesizing
                }
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
        if button.action == .speak {
            ZStack {
                GridButton(button: button, geometry: geometry, foregroundColor: .black, active: isRecording) {
                    handleOtherActions(actionType: button.action)
                }
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.1)
                        .onEnded { _ in handleOtherActions(actionType: button.action)}
                )
                .zIndex(1) // Ensure buttons are below the circle
                
                if actionHandler.isSynthesizing {
                    Circle()
                        .strokeBorder(Color(red: 0x00 / 255, green: 0x88 / 255, blue: 0xB0 / 255), lineWidth: 1)
                        .frame(width: buttonSize * 0.9, height: buttonSize * 0.9) // Make the circle a little smaller
                        .scaleEffect(scale)
                        .opacity(2 - Double(scale))
                        .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: true), value: actionHandler.isSynthesizing)
                        .offset(y: -buttonSize * 0.2)
                        .zIndex(2)
                }
            }
            .onChange(of: actionHandler.isSynthesizing) { newValue in
                if newValue {
                    withAnimation(Animation.easeOut(duration: 1).repeatForever(autoreverses: true)) {
                        scale = 1.5
                    }
                } else {
                    scale = 1.2
                }
            }
        } else {
            GridButton(button: button, geometry: geometry, foregroundColor: .black) {
                handleOtherActions(actionType: button.action)
            }
        }
    }
    
    func handleOtherActions(actionType: ActionType) {
        actionHandler.handle(actionType: actionType)
    }
    
}
