//
//  ActionsView.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 20/10/23.
//

import Foundation
import SwiftUI

struct ButtonData {
    let label: String
    let image: String
}

struct PressEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
                .background(configuration.isPressed ? Color(hex: 0x0088B0) : Color(hex: 0xDDF6FF))
                .foregroundColor(configuration.isPressed ? Color(hex: 0xDDF6FF) : Color(hex: 0x0088B0))
                .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct ActionsView: View {
   // var dismissAction: () -> Void
    let buttonSize: CGFloat = 100
    let imageTextSpacing: CGFloat = 30
    
    @State private var isListening = false
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isPressing = false
    @State private var hasStartedListening = false
    @State private var hasStoppedListening = false

    @State private var isRecording = false


    let oneValue = "2111.01 ONE"

    let buttonsList: [ButtonData] = [
        ButtonData(label: "New Session", image: "new session"),
        ButtonData(label: "Skip 5 Seconds", image: "skip 5 seconds"),
        ButtonData(label: "Random Fact", image: "random fact"),
        ButtonData(label: "Pause / Play", image: "pause play"),
        ButtonData(label: "Repeat Last", image: "repeat last"),
        ButtonData(label: "Press to Speak", image: "press to speak")
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
        .navigationBarTitle("Grid of Buttons")
        .edgesIgnoringSafeArea(.all)
    }
    
    var landscapeView: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0), count: 3), spacing: 0) {
                    ForEach(buttonsList.indices, id: \.self) { index in
                        landscapeViewButton(index: index, geometry: geometry)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(0)
            .scrollDisabled(true)
        }
    }
    
    var portraitView: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0), count: 2), spacing: 0) {
                    ForEach(buttonsList.indices, id: \.self) { index in
                        portraitViewButton(index: index, geometry: geometry)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(0)
            .scrollDisabled(true)
        }
    }
    
    @ViewBuilder
    func landscapeViewButton(index: Int, geometry: GeometryProxy) -> some View {
        gridButton(index: index, geometry: geometry, foregroundColor: Color(hex: 0x0088B0)) {
            handleOtherActions(index: index)
        }
    }
    
    @ViewBuilder
    func portraitViewButton(index: Int, geometry: GeometryProxy) -> some View {
        gridButton(index: index, geometry: geometry, foregroundColor: Color(hex: 0x0088B0)) {
            handleOtherActions(index: index)
        }
    }
    
    @ViewBuilder
    func gridButton(index: Int, geometry: GeometryProxy, foregroundColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: imageTextSpacing) {
                let button = buttonsList[index]
                Image(button.image)
                    .fixedSize()
                    .aspectRatio(contentMode: .fit)
                Text(button.label)
                    .font(.customFont(size: 18))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(width: geometry.size.width / CGFloat(verticalSizeClass == .compact ? 3 : 2), height: geometry.size.height / CGFloat(verticalSizeClass == .compact ? 2 : 3))
            .cornerRadius(0)
            .alignmentGuide(.bottom) { _ in 0.5 }
        }
        .buttonStyle(PressEffectButtonStyle())
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5).onChanged { _ in
                if index == 5 {
                    handleOtherActions(index: index, isLongPress: true)
                }
            }
        )
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
            // Stop your recording logic here
            print("Stopped Recording")
            SpeechRecognition.shared.stopSpeak()

        }
    }
    
    func handleOtherActions(index: Int, isLongPress: Bool = false) {
        switch index {
        case 0:
            SpeechRecognition.shared.reset()
        case 1:
            stopRecording()
        case 2:
            SpeechRecognition.shared.randomFacts()
        case 3:
            if SpeechRecognition.shared.isPaused() {
                SpeechRecognition.shared.continueSpeech()
            } else {
                SpeechRecognition.shared.pause()
            }
        case 4:
            SpeechRecognition.shared.repeate()
        case 5:
            if isLongPress {
                // Handle long press actions
                startRecording()
                SpeechRecognition.shared.speak()
            }
        default:
            break
        }
    }

}
