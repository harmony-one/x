//
//  ContentView.swift
//  VoiceOn
//
//  Created by Nagesh Kumar Mishra on 19/12/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var audioManager = AudioManager()

    var body: some View {
        VStack {
            List(audioManager.recordings, id: \.fileURL) { recording in
                HStack {
                    Text(recording.fileURL.lastPathComponent)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Spacer()

                    Button(action: {
                        audioManager.playRecording(recording)
                    }) {
                        Image(systemName: "play.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }

            Spacer()

            Button(action: {
                if audioManager.isRecording {
                    audioManager.stopRecording()
                } else {
                    audioManager.startRecording()
                }
            }) {
                Image(systemName: audioManager.isRecording ? "stop.circle" : "mic.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.red)
            }
            .padding()
        }
    }
}

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

#Preview {
    ContentView()
}
