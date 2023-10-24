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
    
    @State private var isPlaying = false
    @State private var isListening = false
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isPressing = false
    @State private var hasStartedListening = false
    @State private var hasStoppedListening = false

    @State private var isRecording = false

    
    let buttonTitles = ["Reset All", "Press Speak", "Fast Forward", "Repeat", "Pause", "Random Facts"]
    let oneValue = "2111.01 ONE"
    
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
                    ForEach(0..<buttonTitles.count, id: \.self) { index in
                        landscapeViewButton(index: index, geometry: geometry)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(0)
        }
    }
    
    var portraitView: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0), count: 2), spacing: 0) {
                    ForEach(0..<buttonTitles.count, id: \.self) { index in
                        portraitViewButton(index: index, geometry: geometry)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(0)
        }
    }
    
    @ViewBuilder
    func landscapeViewButton(index: Int, geometry: GeometryProxy) -> some View {
        if index == 1 {
            gridButton(index: index, geometry: geometry, foregroundColor: .black) {
                handleOtherActions(index: index)
            }
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .onChanged { _ in
                            // Start recording
                            isRecording = true
                            print("Recording started...")
                        }
                )

        }  else {
            gridButton(index: index, geometry: geometry, foregroundColor:  index == 0 ? .white : .black) {
                handleOtherActions(index: index)
            }
        }
    }
    
    @ViewBuilder
    func portraitViewButton(index: Int, geometry: GeometryProxy) -> some View {
        if index == 1 {
    
            gridButton(index: index, geometry: geometry, foregroundColor: .black) {
                handleOtherActions(index: index)
            }
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .onChanged { _ in
                            // Start recording
                            isRecording = true
                            print("Recording started...")
                            SpeechRecognition.shared.speak()
                        }
                )

        }  else {
            gridButton(index: index, geometry: geometry, foregroundColor:  index == 0 ? .white : .black) {
                handleOtherActions(index: index)
            }
        }
    }
    
    @ViewBuilder
    func gridButton(index: Int, geometry: GeometryProxy, foregroundColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: imageTextSpacing) {
            
                Image(buttonTitles[index].lowercased())
                    .fixedSize()
                    .aspectRatio(contentMode: .fit)
                Text(buttonTitles[index])
                    .foregroundColor(foregroundColor)
                    .font(.customFont())
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(width: geometry.size.width / CGFloat(verticalSizeClass == .compact ? 3 : 2), height: geometry.size.height / CGFloat(verticalSizeClass == .compact ? 2 : 3))
            .background(getColor(index: index))
            .cornerRadius(0)
            .alignmentGuide(.bottom) { _ in 0.5 }
        } .overlay(
            index == 5 ?
                AnyView(
                    VStack {
                        Spacer()
                        Text(oneValue)
                            .foregroundColor(.black)
                            .frame(width: geometry.size.width / CGFloat(verticalSizeClass == .compact ? 3 : 2))
                            .font(.customFont(size: 18))
                            .padding(.vertical,(verticalSizeClass == .compact ? 5 : 10))
                            .background(Color(hex: 0xA7C9D8))
                    }
                ) : AnyView(EmptyView())
        )
    }
    
    func getColor(index: Int) -> Color {
        let colors: [Color] = [Color(hex: 0x101042),
                               Color(hex: 0xDDF6FF),
                               Color(hex: 0x69FABD),
                               Color(hex: 0xE0757C),
                               Color(hex: 0xF7BA67),
                               Color(hex: 0x3E95B5)]
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
    
    func handleOtherActions(index: Int) {
        switch index {
        case 0:
            SpeechRecognition.shared.reset()
        //    dismissAction()
            
        case 1:
            stopRecording()

        case 3:
            SpeechRecognition.shared.repeate()
        case 4:
            if isPlaying {
                SpeechRecognition.shared.continueSpeech()
            } else {
                SpeechRecognition.shared.pause()
            }
            self.isPlaying.toggle()
        case 5:
            SpeechRecognition.shared.randomFacts()
        default:
            break
        }
    }
}
