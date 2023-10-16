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
    @State private var topLeftText = "01:01:13.211"
    @State private var topRightText = "42 / 64 dB"
    @State private var bottomLeftText1 = "8.067 ONE"
    @State private var bottomLeftText2 = "x.country/ai"
    @State private var bottomRightText2 = "101 + 27 + 127"
    @State private var bottomRightText1 = "1234-5678-90ab"
    
    var body: some View {
        
        Color.black.ignoresSafeArea()
            .overlay(
                VStack {
                    HStack {
                        Text(topLeftText).font(.customFont())
                            .foregroundColor(.white)
                        Spacer()
                        Text(topRightText){ text in
                            text.font = .custom("TimesSquare", size: 24)
                            text.foregroundColor = Color.blue
                            if let range = text.range(of: "/"), let dbRange = text.range(of: "dB") {
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
                        Text(bottomLeftText1){ text in
                            text.font = .customFont()
                            text.foregroundColor = Color(hex: 0x479CCC)
                            
                            if let range = text.range(of: "ONE"){
                                text[range].foregroundColor = Color.white
                            }
                        }
                        Spacer()
                        Text(bottomRightText2){ text in
                            text.font = .customFont()
                            text.foregroundColor = Color(hex: 0x479CCC)
                            if let range = text.range(of: "+"){
                                text[range].foregroundColor = Color.white
                            }
                        }
                    }
                    HStack {
                        Text(bottomLeftText2).font(.customFont())
                            .foregroundColor(.white)
                        Spacer()
                        Text(bottomRightText1).font(.customFont())
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
