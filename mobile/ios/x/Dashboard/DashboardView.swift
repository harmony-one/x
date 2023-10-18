//
//  ContentView.swift
//  x
//
//  Created by Aaron Li on 10/13/23.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var latencyText = "256"
    @State private var elapaedTime = "01:01:13.211"
    @State private var voiceDecibel = "42 / 64 dB"
    @State private var paymentsCredits = "8.067 ONE"
    @State private var source = "x.country/ai"
    @State private var optimiseValue = "101 + 27 + 127"
    @State private var sessionIdentifier = "1234-5678-90ab"
    
    var body: some View {
        Color(hex:0x313131).ignoresSafeArea()
            .overlay(
                VStack {
                    HStack {
                        Text(elapaedTime)
                            .font(.customFont())
                            .foregroundColor(.white)
                        Spacer()
                        Text(voiceDecibel){ text in
                            text.font = .customFont()
                            text.foregroundColor = Color(hex: 0x00AEE9)
                            if let range = text.range(of: "/"),
                               let dbRange = text.range(of: "dB") {
                                text[range].foregroundColor = Color.white
                                text[dbRange].foregroundColor = Color.white
                            }
                        }
                    }
                    .padding(.top, 30)
                    Spacer()
                    
                    HStack {
                        VStack {
                            Text(latencyText){ text in
                                text.font = .customFont(size: 84)
                                text.foregroundColor = Color(hex: 0x00AEE9)
                            }
                        }
                        Text("ms"){ text in
                            text.font = .customFont(size: 54)
                            text.foregroundColor = Color.white
                        }.padding(.top, 10)
                    }
                    Spacer()
                    HStack {
                        Text(paymentsCredits){ text in
                            text.font = .customFont()
                            text.foregroundColor = Color(hex: 0x00AEE9)
                            
                            if let range = text.range(of: "ONE"){
                                text[range].foregroundColor = Color.white
                            }
                        }
                        Spacer()
                        Text(optimiseValue){ text in
                            text.font = .customFont()
                            text.foregroundColor = Color(hex: 0x00AEE9)
                            for each in text.characters.ranges(of: "+"){
                                text[each].foregroundColor = Color.white
                            }
                        }
                    }
                    HStack {
                        Text(source)
                            .font(.customFont())
                            .foregroundColor(.white)
                        Spacer()
                        Text(sessionIdentifier)
                            .font(.customFont())
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 30)
                }
                    .padding(10)
            ).onAppear(
                perform: SpeechRecognition().setup
            )
    }
}

#Preview {
    NavigationView {
        DashboardView()
    }
}
