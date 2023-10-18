import SwiftUI
import AVFoundation

struct ContentView: View {
    let synthesizer = AVSpeechSynthesizer()
    @State private var inputText = ""

    func speakText() {
        let speaking_name = "com.apple.ttsbundle.siri_female_en-AU_compact"
        let utterance = AVSpeechUtterance(string: inputText)
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.voice.Alex")
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
