import Foundation
import AVFoundation

class AudioManager: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingSession: AVAudioSession?
    @Published var recordings = [Recording]()
    @Published var isRecording = false

    override init() {
        super.init()
        prepareAudioSession()
        loadRecordings()
    }

    func prepareAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothA2DP, .allowAirPlay])
            try recordingSession?.setActive(true, options: .notifyOthersOnDeactivation)
            try recordingSession?.setMode(.spokenAudio)
            try recordingSession?.setActive(true)
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
        } catch {
            finishRecording(success: false)
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
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
