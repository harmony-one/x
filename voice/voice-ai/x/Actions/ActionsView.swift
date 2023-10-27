//
//  ActionsView.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 20/10/23.
//

import Foundation
import SwiftUI

enum ActionType {
    case reset
    case skip
    case randomFact
    case play
    case repeatLast
    case speak
}

struct ButtonData: Identifiable {
    let id = UUID()
    let label: String
    let image: String
    let action: ActionType
}

struct ActionsView: View {
    // var dismissAction: () -> Void
    let buttonSize: CGFloat = 100
    let imageTextSpacing: CGFloat = 30
    
    @State private var isListening = false
    @State private var isSynthesizing = false
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isPressing = false
    @State private var isRecording = false
    @State private var hasStartedListening = false
    @State private var hasStoppedListening = false
    @State private var isRecordingContinued = false
    @State private var orientation = UIDevice.current.orientation
    
    
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

            if isSynthesizing {
                overlayView
            }
        }
        .onChange(of: isSynthesizing) { newValue in
            if newValue {
                print("isSynthesizing is now true")
            }
        }
        .onAppear(perform: SpeechRecognition.shared.setup)
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
    
    var overlayView: some View {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Circle()
                                .trim(from: 0, to: 0.8)
                                .stroke(Color.white, lineWidth: 5)
                                .frame(width: 90, height: 90)
                                .rotationEffect(Angle(degrees: isSynthesizing ? 360 : 0))
                                .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false), value: isSynthesizing)
                        )
                )
        }
    
    var pulsatingIndicator: some View {
           Group {
               if isSynthesizing {
                   Circle()
                       .fill(Color.blue)
                       .frame(width: 100, height: 100)
                       .scaleEffect(isSynthesizing ? 1.5 : 1)
                       .opacity(isSynthesizing ? 0 : 1)
                       .animation(.easeOut(duration: 1).repeatForever(autoreverses: false), value: isSynthesizing)
                       .onAppear() {
                           self.isSynthesizing = true
                       }
               }
           }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
            GridButton(button: button, geometry: geometry, foregroundColor: .black, active: isRecording) {
                handleOtherActions(actionType: button.action)
            }
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.1)
                    .onEnded { _ in handleOtherActions(actionType: button.action)}
            )
        } else {
            GridButton(button: button, geometry: geometry, foregroundColor: .black) {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.isSynthesizing = true
                    
                    // Set isSynthesizing back to false after 3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.isSynthesizing = false
                        }
                    }
                }
            }
        }
    }
    
    func handleOtherActions(actionType: ActionType) {
        switch actionType {
        case .reset:
            SpeechRecognition.shared.reset()
        case .skip:
            stopRecording()
        case .randomFact:
            SpeechRecognition.shared.randomFacts()
        case .play:
            if SpeechRecognition.shared.isPaused() {
                SpeechRecognition.shared.continueSpeech()
            } else {
                SpeechRecognition.shared.pause()
            }
        case .repeatLast:
            SpeechRecognition.shared.repeate()
        case .speak:
            if self.isRecording == false {
                startRecording()
                SpeechRecognition.shared.speak()
            } else {
                // Introducing a delay before stopping the recording
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.stopRecording()
                }
            }
        default:
            break
        }
    }
    
}
