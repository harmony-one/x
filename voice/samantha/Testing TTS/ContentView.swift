import SwiftUI
import AVFoundation

class SpeechDelegate: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var startTime: Date?
    @Published var endTime: Date?
    @Published var duration: TimeInterval?

    // AVSpeechSynthesizerDelegate method to handle speech starting
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        endTime = Date() // Record the end time
        if let startTime = startTime, let endTime = endTime {
            duration = endTime.timeIntervalSince(startTime) // Calculate the duration
        }
    }
    
    // Function to get available voices
    func getAvailableVoices() -> [AVSpeechSynthesisVoice] {
            return AVSpeechSynthesisVoice.speechVoices()
    }
}

struct ContentView: View {
    @ObservedObject var speechDelegate = SpeechDelegate()
    let synthesizer = AVSpeechSynthesizer()
    @State private var inputText = ""
    @State private var selectedVoice: AVSpeechSynthesisVoice?

    func speakText() {
        speechDelegate.startTime = Date() // Record the start time
        let utterance = AVSpeechUtterance(string: inputText)
        utterance.voice = selectedVoice ?? AVSpeechSynthesisVoice(identifier: "com.apple.speech.voice.Alex")
        synthesizer.speak(utterance)
    }

    var body: some View {
        VStack {
            TextField("Enter text", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: speakText) {
                Text("Speak")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if let duration = speechDelegate.duration {
                Text("Duration: \(String(format: "%.2f seconds", duration))")
            }

            // Display available voices with name and language
            List(speechDelegate.getAvailableVoices(), id: \.identifier) { voice in
                Button(action: {
                    selectedVoice = voice
                }) {
                    VStack(alignment: .leading) {
                        Text(voice.name)
                            .font(.headline)
                        Text("Language: \(voice.language)")
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}
