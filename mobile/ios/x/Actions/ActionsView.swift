//
//  ActionsView.swift
//  x
//
//  Created by Nagesh Kumar Mishra on 20/10/23.
//

import Foundation
import SwiftUI

struct ActionsView: View {
    var dismissAction: () -> Void
    let buttonSize: CGFloat = 100
    let imageTextSpacing: CGFloat = 30
    @State private var isPlaying = false
    @State private var isListening = false
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let buttonTitles = ["Hide", "Speak", "Reset", "Repeat", "Pause", "Cut"]
    
    var body: some View {
        Group {
            if verticalSizeClass == .compact {
                landscapeView
            } else {
                portraitView
            }
        }
        .navigationBarTitle("Grid of Buttons")
        .edgesIgnoringSafeArea(.all)
    }
    
    var landscapeView: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0),
                    GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0),
                    GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0)
                ], spacing: 0) {
                    
                    if isPlaying {
                        Text("Playing")
                            .font(.title)
                            .foregroundColor(.green)
                            .padding()
                    } else {
                        Text("Paused")
                            .font(.title)
                            .foregroundColor(.red)
                            .padding()
                    }
                    ForEach(0..<buttonTitles.count, id: \.self) { index in
                        
                        if index == 0 {
                            
                            Button(action: dismissAction) {
                                VStack(spacing: imageTextSpacing){
                                    Image(buttonTitles[index].lowercased())
                                        .aspectRatio(contentMode: .fit)
                                    Text(buttonTitles[index])
                                        .foregroundColor(.white)
                                        .font(.customFont())
                                        .padding(.top)
                                }
                                .frame(width: geometry.size.width / 3, height: geometry.size.height / 2)
                                .background(getColor(index: index))
                                .cornerRadius(0)
                            }
                            
                        }  else if index  == 1 {
                            
                            Button(action: {
                                
                            }) {
                                VStack(spacing: imageTextSpacing) {
                                    Image(buttonTitles[index].lowercased())
                                    // .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    // .frame(width: 30, height: 30)
                                    Text(buttonTitles[index])
                                        .foregroundColor(.black)
                                        .font(.customFont())
                                }
                                .frame(width: geometry.size.width / 3, height: geometry.size.height / 2)
                                .background(getColor(index: index))
                                .cornerRadius(0)
                            }.simultaneousGesture(
                                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                    .onChanged { _ in
                                        if !isListening {
                                            isListening = true
                                            print("Started Listening...")
                                            SpeechRecognition.shared.speak()
                                            
                                            
                                        }
                                    }
                                    .onEnded { _ in
                                        if isListening {
                                            isListening = false
                                            print("Stopped Listening")
                                        }
                                    }
                            )
                            
                        } else {
                            Button(action: {
                                if index == 2 {
                                    SpeechRecognition.shared.reset()
                                } else if index == 3 {
                                    SpeechRecognition.shared.repeate()
                                }  else if index == 4 {
                                    
                                    if isPlaying {
                                        SpeechRecognition.shared.continueSpeech()
                                    } else {
                                        SpeechRecognition.shared.pause()
                                    }
                                    self.isPlaying.toggle()
                                } else if index == 5 {
                                    SpeechRecognition.shared.cut()
                                }
                                
                            }) {
                                VStack(spacing: imageTextSpacing) {
                                    Image(buttonTitles[index].lowercased())
                                        .aspectRatio(contentMode: .fit)
                                    Text(buttonTitles[index])
                                        .foregroundColor(.black)
                                        .font(.customFont())
                                }
                                .frame(width: geometry.size.width / 3, height: geometry.size.height / 2)
                                .background(getColor(index: index))
                                .cornerRadius(0)
                            }
                        }
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
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0),
                    GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0)
                ], spacing: 0) {
                    ForEach(0..<buttonTitles.count, id: \.self) { index in
                        
                        if index == 0 {
                            Button(action: dismissAction) {
                                VStack(spacing: imageTextSpacing){
                                    Image(buttonTitles[index].lowercased())
                                        .aspectRatio(contentMode: .fit)
                                    Text(buttonTitles[index])
                                        .foregroundColor(.white)
                                        .font(.customFont())
                                }
                                .frame(width: geometry.size.width / 2, height: geometry.size.height / 3)
                                .background(getColor(index: index))
                                .cornerRadius(0)
                            }
                        } else if index == 1{
                            Button(action: {
                                SpeechRecognition.shared.speak()
                            }) {
                                VStack(spacing: imageTextSpacing) {
                                    
                                    Image(buttonTitles[index].lowercased())
                                        .aspectRatio(contentMode: .fit)
                                    Text(buttonTitles[index])
                                        .foregroundColor(.black)
                                        .font(.customFont())
                                }
                                .frame(width: geometry.size.width / 2, height: geometry.size.height / 3)
                                .background(getColor(index: index))
                                .cornerRadius(0)
                            }.simultaneousGesture(
                                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                    .onChanged { _ in
                                        if !isListening {
                                            isListening = true
                                            print("Started Listening...")
                                            SpeechRecognition.shared.speak()
                                            
                                            
                                        }
                                    }
                                    .onEnded { _ in
                                        if isListening {
                                            isListening = false
                                            print("Stopped Listening")
                                        }
                                    }
                            )
                        } else {
                            Button(action: {
                                if index == 2 {
                                    SpeechRecognition.shared.reset()
                                } else if index == 3 {
                                    SpeechRecognition.shared.repeate()
                                }  else if index == 4 {
                                    if isPlaying {
                                        SpeechRecognition.shared.continueSpeech()
                                    } else {
                                        SpeechRecognition.shared.pause()
                                    }
                                    self.isPlaying.toggle()
                                } else if index == 5 {
                                    SpeechRecognition.shared.cut()
                                }
                                
                            }) {
                                VStack(spacing: imageTextSpacing) {
                                    
                                    Image(buttonTitles[index].lowercased())
                                        .aspectRatio(contentMode: .fit)
                                    Text(buttonTitles[index])
                                        .foregroundColor(.black)
                                        .font(.customFont())
                                }
                                .frame(width: geometry.size.width / 2, height: geometry.size.height / 3)
                                .background(getColor(index: index))
                                .cornerRadius(0)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(0)
        }
    }
    
    func getColor(index: Int) -> Color {
        let colors: [Color] = [Color(hex:0x101042),
                               Color(hex:0x00AEE9),
                               Color(hex:0x69FABD),
                               Color(hex:0xE0757C),
                               Color(hex:0xF7BA67),
                               Color(hex:0x3E95B5)]
        return colors[index]
    }
}
