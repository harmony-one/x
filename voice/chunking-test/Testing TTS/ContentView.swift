import SwiftUI
import AVFoundation

class SpeechDelegate: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var startTime: Date?
    @Published var endTime: Date?
    @Published var duration: TimeInterval?
    private var synthesizer: AVSpeechSynthesizer?

    init(synthesizer: AVSpeechSynthesizer) {
        self.synthesizer = synthesizer
        super.init()
        self.synthesizer?.delegate = self
    }

    // AVSpeechSynthesizerDelegate method to handle speech starting
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    }
    
    func willSpeak() {
        startTime = Date() // Record the time when the Speak button is pressed
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        endTime = Date()
        if let startTime = startTime, let endTime = endTime {
            duration = endTime.timeIntervalSince(startTime)
        }
    }

    // Method to stop speech
    func stopSpeech() {
        synthesizer?.stopSpeaking(at: .immediate)
        endTime = Date() // Record the end time when stopped
        if let startTime = startTime, let endTime = endTime {
            duration = endTime.timeIntervalSince(startTime) // Update the duration
        }
    }
    
    // Function to get available voices filtered by English language
    func getAvailableVoices() -> [AVSpeechSynthesisVoice] {
        return AVSpeechSynthesisVoice.speechVoices().filter { voice in
            voice.language.starts(with: "en-") && !voice.identifier.contains("synthesis")
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct ContentView: View {
    @ObservedObject var speechDelegate: SpeechDelegate
    let synthesizer = AVSpeechSynthesizer()
    @State private var inputText = ""
    @State private var wordChunkSize: String = ""
    @State private var selectedVoice: AVSpeechSynthesisVoice?
    
    init() {
        speechDelegate = SpeechDelegate(synthesizer: synthesizer)
    }
    
    func chunkText(_ text: String, by wordCount: Int) -> [String] {
        let words = text.split(separator: " ")
        var chunks: [String] = []
        var currentChunk: [Substring] = []
        
        words.enumerated().forEach { index, word in
            currentChunk.append(word)
            if (index + 1) % wordCount == 0 || index == words.count - 1 {
                chunks.append(currentChunk.joined(separator: " "))
                currentChunk = []
            }
        }
        
        return chunks
    }

    func speakText() {
        let chunkSize = Int(wordChunkSize) ?? 1
        
        let chunks = chunkText(inputText, by: chunkSize)
        
        chunks.forEach { chunk in
            let utterance = AVSpeechUtterance(string: String(chunk))
            utterance.voice = selectedVoice ?? AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(utterance)
        }
        speechDelegate.willSpeak()
    }

    var body: some View {
            VStack {
                TextField("Enter text", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer() // Use spacer to push the Done button to the right
                            Button("Done") {
                                hideKeyboard()
                            }
                        }
                    }
                TextField("Enter chunk size", text: $wordChunkSize)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer() // Use spacer to push the Done button to the right
                            Button("Done") {
                                hideKeyboard()
                            }
                        }
                    }
                HStack {
                    Button(action: {
                            speechDelegate.stopSpeech()
                        }) {
                            Text("Stop")
                                .font(.title)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    Button(action: speakText) {
                        Text("Speak")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                Button(action: {
                    self.inputText = "Cats, commonly referred to as domestic cats or house cats, are small, carnivorous mammals scientifically known as Felis catus. They are one of humanity's oldest and most popular pets, and their domestication dates back at least 9,000 years. Cats possess strong, flexible bodies, quick reflexes, sharp retractable claws, and teeth adapted to killing small prey. They are known for their acute hearing, their ability to see in near darkness, their sense of smell, and a communication system that includes vocalizations like meowing, purring, trilling, hissing, growling, and grunting as well as cat-specific body language. They are solitary hunters but are a social species, capable of forming colonies or living with human families as pets. Cats use a variety of vocalizations and types of body language for communication. They are also known for their cleanliness, spending a significant portion of their day grooming themselves."
                }) {
                    Text("Fill Text")
                        .font(.title)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
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
                        Text(voice.identifier)
                            .font(.subheadline)
                        Text("Language: \(voice.language)")
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}
