//
//  ActionsView.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 20/10/23.
//

import Foundation
import SwiftUI

struct PressEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color(hex: 0x0088B0) : Color(hex: 0xDDF6FF))
            .foregroundColor(configuration.isPressed ? Color(hex: 0xDDF6FF) : Color(hex: 0x0088B0))
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

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
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isPressing = false
    @State private var isRecording = false
    @State private var hasStartedListening = false
    @State private var hasStoppedListening = false
    @State private var isPlaying = false
    
    let oneValue = "2111.01 ONE"

    let buttonsList: [ButtonData] = [
        ButtonData(label: "New Session", image: "new session"),
        ButtonData(label: "Skip 5 Seconds", image: "skip 5 seconds"),
        ButtonData(label: "Random Fact", image: "random fact"),
        ButtonData(label: "Pause / Play", image: "pause play"),
        ButtonData(label: "Repeat Last", image: "repeat last"),
        ButtonData(label: "You can Speak now", image: "press to speak")
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
            // perform: SpeechRecognition.shared.setup
            perform: DeepgramASR.shared.setup
        )
        .edgesIgnoringSafeArea(.all)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    if UIDevice.current.orientation != orientation {
                        if isRecording {
                            isRecordingContinued = true
                            
                            print("Recording stopSpeak...")
                            SpeechRecognition.shared.cancelSpeak()
                        }
                        orientation = UIDevice.current.orientation
                    }
                }
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
            gridButton(button: button, geometry: geometry, foregroundColor: .black) {
                handleOtherActions(actionType: button.action)
            }
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.1)
                    .onChanged { _ in
                        // Start recording
                        isRecording = true
                        isRecordingContinued = true
                        print("Recording started...")
                        SpeechRecognition.shared.speak()
                    }
                    .onEnded { _ in
                        isRecordingContinued = false
                    }
            )
        } else {
            gridButton(button: button, geometry: geometry, foregroundColor: .black) {
                handleOtherActions(actionType: button.action)
            }
        }
    }
    
    @ViewBuilder
    func gridButton(button: ButtonData, geometry: GeometryProxy, foregroundColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: imageTextSpacing) {
                Image(button.image)
                    .fixedSize()
                    .aspectRatio(contentMode: .fit)
                Text(button.label)
                    .font(.customFont(size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(width: geometry.size.width / CGFloat(verticalSizeClass == .compact ? 3 : 2), height: geometry.size.height / CGFloat(verticalSizeClass == .compact ? 2 : 3))
            .cornerRadius(0)
            .alignmentGuide(.bottom) { _ in 0.5 }
        }
        .buttonStyle(PressEffectButtonStyle())
    }
    
    
    func getColor(index: Int) -> Color {
        let colors: [Color] = [Color(hex: 0xDDF6FF),
                               Color(hex: 0xDDF6FF),
                               Color(hex: 0xDDF6FF),
                               Color(hex: 0xDDF6FF),
                               Color(hex: 0xDDF6FF),
                               Color(hex: 0xDDF6FF)]
        return colors[index]
    }
    
    func startRecording() {
        isRecording = true
        // Start your recording logic here
        print("Started Recording...")
    }
    
    func stopRecording() {
        if isRecording {
            isRecording = false
            if !isRecordingContinued {
                // Stop your recording logic here
                print("Stopped Recording")
                SpeechRecognition.shared.stopSpeak()
            }
        }
    }
    
    func handleOtherActions(index: Int) {
        switch index {
        case 0:
            DeepgramASR.shared.reset()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                DeepgramASR.shared.setup()
            }
            
            self.isPlaying = false
            break;
        case 1:
            // stopRecording()
            break;
        case 2:
            DeepgramASR.shared.makeQuery("Give me one random fact")
            break;
        case 3:
            if isPlaying {
                DeepgramASR.shared.continueSpeech()
            } else {
                DeepgramASR.shared.pause()
            }
            self.isPlaying.toggle()
            break;
        case 4:
            DeepgramASR.shared.repeate()
        default:
            break
        }
    }
    
}
