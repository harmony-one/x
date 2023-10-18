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
    
    @State private var latencyText = "256 ms"
    @State private var elapaedTime = "01:01:13.211"
    @State private var voiceDecibel = "42 / 64 dB"
    @State private var paymentsCredits = "8.067 ONE"
    @State private var source = "x.country/ai"
    @State private var optimiseValue = "101 + 27 + 127"
    @State private var sessionIdentifier = "1234-5678-90ab"
    
    var body: some View {
        
        Color.black.ignoresSafeArea()
            .overlay(
                VStack {
                    HStack {
                        Text(elapaedTime).font(.customFont())
                            .foregroundColor(.white)
                        Spacer()
                        Text(voiceDecibel){ text in
                            text.font = .customFont()
                            text.foregroundColor = Color(hex: 0x479CCC)
                            if let range = text.range(of: "/"),
                               let dbRange = text.range(of: "dB") {
                                text[range].foregroundColor = Color.white
                                text[dbRange].foregroundColor = Color.white
                            }
                        }
                    }
                    .padding(.top, 30)
                    Spacer()
                    Text(latencyText){ text in
                        text.font = .customFont(size: 64)
                        text.foregroundColor = Color(hex: 0x479CCC)
                        if let range = text.range(of: "ms") {
                            text[range].font = .customFont(size: 32)
                            text[range].foregroundColor = Color.white
                        }
                    }
                    Spacer()
                    HStack {
                        Text(paymentsCredits){ text in
                            text.font = .customFont()
                            text.foregroundColor = Color(hex: 0x479CCC)
                            
                            if let range = text.range(of: "ONE"){
                                text[range].foregroundColor = Color.white
                            }
                        }
                        Spacer()
                        
                        Text(optimiseValue){ text in
                            text.font = .customFont()
                            text.foregroundColor = Color(hex: 0x479CCC)
                            for each in text.characters.ranges(of: "+"){
                                text[each].foregroundColor = Color.white
                            }
                        }
                    }
                    HStack {
                        Text(source).font(.customFont())
                            .foregroundColor(.white)
                        Spacer()
                        Text(sessionIdentifier).font(.customFont())
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 30)
                }
                    .padding(10)
            )
    }
    
}

#Preview {
    NavigationView {
        DashboardView()
    }
}
