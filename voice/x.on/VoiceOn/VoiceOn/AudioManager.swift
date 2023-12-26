import Foundation
import Speech
import AVFoundation

class AudioManager: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingSession: AVAudioSession?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private let recognitionLock = DispatchSemaphore(value: 1)
    private let speechRecognizer: SFSpeechRecognizer? = {
        let preferredLocale = "en-US"
        let locale = Locale(identifier: preferredLocale)
        return SFSpeechRecognizer(locale: locale)
    }()
    private var messageInRecongnition = ""
    @Published var recordings = [Recording]()
    @Published var isRecording = false

    override init() {
        super.init()
        prepareAudioSession()
        prepareAudioEngineSession()
        loadRecordings()
    }

    func prepareAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothA2DP, .allowAirPlay])
            try recordingSession?.setActive(true, options: .notifyOthersOnDeactivation)
            try recordingSession?.setMode(.spokenAudio)
            try self.recordingSession?.setActive(true)
            recordingSession?.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        // Handle the failure of getting permission
                    }
                }
            }
        } catch {
            // Handle the error of setting up the audio session
        }
    }
    
    func prepareAudioEngineSession() {
        if !audioEngine.isRunning {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: [.defaultToSpeaker, .allowBluetoothA2DP, .allowAirPlay])
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                try AVAudioSession.sharedInstance().setMode(.spokenAudio)
                try AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(true)
            } catch {
                // Handle the error of setting up the audio session
            }
        }
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(Date().formatted()).m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            isRecording = true
            let inputNode = audioEngine.inputNode
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            recognitionRequest?.shouldReportPartialResults = true
            handleRecognition(inputNode: inputNode)
        } catch {
            finishRecording(success: false)
        }
    }

    private func handleRecognition(inputNode: AVAudioNode) {
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            guard let result = result else {
                print("ERROR \(error)")
                return
            }
            let message = result.bestTranscription.formattedString
            print("[handleRecognition] \(message)")
            print("[handleRecognition] isFinal: \(result.isFinal)")
            
            if !message.isEmpty {
                self.recognitionLock.wait()
                self.messageInRecongnition = message
                self.recognitionLock.signal()
            }
        }
        installTapAndStartEngine(inputNode: inputNode)
    }
    
    private func installTapAndStartEngine(inputNode: AVAudioNode) {
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        if recordingFormat.sampleRate == 0.0 {
            return
        }
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        do {
            audioEngine.prepare()
            try audioEngine.start()
            print("Audio engine started")
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
//            audioPlayer.playSound(false)
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        recognitionTask?.finish()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        isRecording = false
        loadRecordings()
    }

    func finishRecording(success: Bool) {
        isRecording = false
        loadRecordings()
    }

    func playRecording(_ recording: Recording) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recording.fileURL)
            audioPlayer?.delegate = self
            audioPlayer?.volume = 1.0  // Set maximum volume
            audioPlayer?.play()
        } catch {
            // Playback failed
        }
    }

    func loadRecordings() {
        recordings.removeAll()

        let fileManager = FileManager.default
        let documentDirectory = getDocumentsDirectory()
        guard let files = try? fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil) else { return }

        for file in files where file.pathExtension == "m4a" {
            let recording = Recording(fileURL: file, createdAt: getFileDate(file))
            recordings.append(recording)
        }

        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending })
    }

    func getFileDate(_ file: URL) -> Date {
        // Ideally, parse the date from the file's name
        // Here we're using the file's last modified date as a fallback
        let attributes = try? FileManager.default.attributesOfItem(atPath: file.path)
        return (attributes?[.modificationDate] as? Date) ?? Date()
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct Recording {
    let fileURL: URL
    let createdAt: Date
}

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return formatter.string(from: self)
    }
}
