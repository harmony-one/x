# Recognizing speech in live audio

Perform speech recognition on audio coming from the microphone of an iOS device.

## Overview

This sample project demonstrates how to use the Speech framework to recognize words from captured audio. When the user taps the Start Recording button, the SpokenWord app begins capturing audio from the device’s microphone. It routes that audio to the APIs of the Speech framework, which process the audio and send back any recognized text. The app displays the recognized text in its text view, continuously updating that text until you tap the Stop Recording button. The sample app doesn't run in Simulator, so you need to run it on a physical device with iOS 17 or later, or iPadOS 17 or later.

![On the left, the app lets the user know that it is ready to begin speech recognition. On the right, the app uses speech recognition to display what the user said.](Documentation/sample-screens_2x.png) 


- Important: Apps need to include the `NSSpeechRecognitionUsageDescription` key in their `Info.plist` file and request authorization to perform speech recognition. For information about requesting authorization, see [Asking Permission to Use Speech Recognition](https://developer.apple.com/documentation/speech/asking_permission_to_use_speech_recognition). 

## Customize the language model

Developers can enhance the `SFSpeechRecognizer` for specific use cases and applications by customizing its language model. The SpokenWord app uses language model customization to improve accuracy when recognizing certain chess moves. The high-level steps in this process are:

- Training data generation
- Training data preparation
- Request configuration

This sample code project includes a command-line utility named `datagenerator` that produces a training data file. The project includes a sample output file in the SpokenWord app bundle at `customlm/en_US/CustomLMData.bin`. The `datagenerator` utility uses classes that the Speech framework defines to generate data, starting with the [SFCustomLanguageModelData](https://developer.apple.com/documentation/speech/sfcustomlanguagemodeldata), which the `ResultBuilder` DSL builds. 

``` swift
let data = SFCustomLanguageModelData(locale: Locale(identifier: "en_US"), identifier: "com.apple.SpokenWord", version: "1.0") {
```

Training data samples can include exact phrases that the app is likely to encounter.

``` swift
SFCustomLanguageModelData.PhraseCount(phrase: "Play the Albin counter gambit", count: 10)
```

The app can also define phrases using templates, which expand automatically to generate large amounts of data.

``` swift
SFCustomLanguageModelData.PhraseCountsFromTemplates(classes: [
    "piece": ["pawn", "rook", "knight", "bishop", "queen", "king"],
    "royal": ["queen", "king"],
    "rank": Array(1...8).map({ String($0) })
]) {
    SFCustomLanguageModelData.TemplatePhraseCountGenerator.Template(
        "<piece> to <royal> <piece> <rank>",
        count: 10_000
    )
}
```

An app that uses specialized terminology can also define custom vocabulary, complete with pronunciation information.

``` swift
SFCustomLanguageModelData.CustomPronunciation(grapheme: "Winawer", phonemes: ["w I n aU @r"])
SFCustomLanguageModelData.CustomPronunciation(grapheme: "Tartakower", phonemes: ["t A r t @ k aU @r"])

SFCustomLanguageModelData.PhraseCount(phrase: "Play the Winawer variation", count: 10)
SFCustomLanguageModelData.PhraseCount(phrase: "Play the Tartakower", count: 10)
```

## Configure the microphone using AVFoundation

The SpokenWord app uses AVFoundation to communicate with the device’s microphone. Specifically, the app configures the shared [AVAudioSession](https://developer.apple.com/documentation/avfaudio/avaudiosession) object to manage the app’s audio interactions with the rest of the system, and it configures an [AVAudioEngine](https://developer.apple.com/documentation/avfaudio/avaudioengine) object to retrieve the microphone input.

``` swift
private let audioEngine = AVAudioEngine()
```

Tapping the app's Start Recording button retrieves the shared [AVAudioSession](https://developer.apple.com/documentation/avfaudio/avaudiosession) object, configures it for recording, and makes it the active session. Activating the session lets the system know that the app needs the microphone resource. If that resource is unavailable — perhaps because the user is talking on the phone — the [setActive(_:options:)](https://developer.apple.com/documentation/avfaudio/avaudiosession/1616627-setactive) method throws an exception. 

``` swift
// Configure the audio session for the app.
let audioSession = AVAudioSession.sharedInstance()
try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
let inputNode = audioEngine.inputNode
```

When the session is active, the app retrieves the [AVAudioInputNode](https://developer.apple.com/documentation/avfaudio/avaudioinputnode) object from its audio engine and stores it in the local `inputNode` variable. The input node represents the current audio input path, which can be the device’s built-in microphone or a microphone connected to a set of headphones. 

To begin recording, the app installs a tap on the input node and starts up the audio engine, which begins collecting samples into an internal buffer. When a buffer is full, the audio engine calls the provided block. The app’s implementation of that block passes the samples directly to the request object's [append(_:)](https://developer.apple.com/documentation/speech/sfspeechaudiobufferrecognitionrequest/1649389-append) method, which accumulates the audio samples and delivers them to the speech recognition system. 

``` swift
// Configure the microphone input.
let recordingFormat = inputNode.outputFormat(forBus: 0)
inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
    self.recognitionRequest?.append(buffer)
}

audioEngine.prepare()
try audioEngine.start()
```

The SpokenWord app processes the training data that the `datagenerator` utility produces by calling [prepareCustomLanguageModel(for:clientIdentifier:configuration:)](https://developer.apple.com/speech/sfspeechlanguagemodel/4165618-preparecustomlanguagemodelforurl). This method can have a large amount of associated latency, so the system calls it off the main thread.

``` swift
Task.detached {
    do {
        let assetPath = Bundle.main.path(forResource: "CustomLMData", ofType: "bin", inDirectory: "customlm/en_US")!
        let assetUrl = URL(fileURLWithPath: assetPath)
        try await SFSpeechLanguageModel.prepareCustomLanguageModel(for: assetUrl,
                                                                   clientIdentifier: "com.apple.SpokenWord",
                                                                   configuration: self.lmConfiguration)
    } catch {
        NSLog("Failed to prepare custom LM: \(error.localizedDescription)")
    }
    await MainActor.run { self.recordButton.isEnabled = true }
}
```

## Create the speech recognition request

To recognize speech from live audio, SpokenWord creates and configures an [SFSpeechAudioBufferRecognitionRequest](https://developer.apple.com/documentation/speech/sfspeechaudiobufferrecognitionrequest) object. When it receives recognition results, the app updates its text view accordingly. The app sets the request object's [shouldReportPartialResults](https://developer.apple.com/documentation/speech/sfspeechrecognitionrequest/1649392-shouldreportpartialresults) property to `true`, which causes the speech recognition system to return intermediate results as they are recognized. 

``` swift
// Create and configure the speech recognition request.
recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
recognitionRequest.shouldReportPartialResults = true
```

The SpokenWord app then configures the request to use language model customization, using the same configuration object that the system provides earlier to `prepareCustomLanguageModel`. The system needs to service customized requests on the device, which it enforces using the `requiresOnDeviceRecognition` flag.

``` swift
// Keep speech recognition data on device
if #available(iOS 13, *) {
    recognitionRequest.requiresOnDeviceRecognition = true
    if #available(iOS 17, *) {
        recognitionRequest.customizedLanguageModel = self.lmConfiguration
    }
}
```

To begin the speech recognition process, the app calls [recognitionTask(with:resultHandler:)](https://developer.apple.com/documentation/speech/sfspeechrecognizer/1649883-recognitiontask) on its [SFSpeechRecognizer](https://developer.apple.com/documentation/speech/sfspeechrecognizer) object. That method uses the information in the provided request object to configure the speech recognition system and to begin processing audio asynchronously. Shortly after calling it, the app begins appending audio samples to the request object. When you tap the Stop Recording button, the app stops adding samples and ends the speech recognition process.

Because the request's [shouldReportPartialResults](https://developer.apple.com/documentation/speech/sfspeechrecognitionrequest/1649392-shouldreportpartialresults) property is `true`, the [recognitionTask(with:resultHandler:)](https://developer.apple.com/documentation/speech/sfspeechrecognizer/1649883-recognitiontask) method executes its block periodically to deliver partial results. The app uses that block to update its text view with the text in the [bestTranscription](https://developer.apple.com/documentation/speech/sfspeechrecognitionresult/1648280-besttranscription) property of the result object. If it receives an error instead of a result, the app stops the recognition process altogether.  

``` swift
// Create a recognition task for the speech recognition session.
// Keep a reference to the task so that it can be canceled.
recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
    var isFinal = false
    
    if let result = result {
        // Update the text view with the results.
        self.textView.text = result.bestTranscription.formattedString
        isFinal = result.isFinal
    }
    
    if error != nil || isFinal {
        // Stop recognizing speech if there is a problem.
        self.audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        
        self.recognitionRequest = nil
        self.recognitionTask = nil
        
        self.recordButton.isEnabled = true
        self.recordButton.setTitle("Start Recording", for: [])
    }
}
```

## Respond to availability changes for speech recognition

The availability of speech recognition services can change at any time. For some languages, speech recognition relies on Apple servers, which requires an active Internet connection. If that Internet connection is lost, an app must be ready to handle the disruption of service that can occur. 

Whenever the availability of speech recognition services changes, the [SFSpeechRecognizer](https://developer.apple.com/documentation/speech/sfspeechrecognizer) object notifies its delegate. SpokenWord provides a delegate object and implements the [speechRecognizer(_:availabilityDidChange:)](https://developer.apple.com/documentation/speech/sfspeechrecognizerdelegate/1649879-speechrecognizer) method to respond to availability changes. When services become unavailable, the method disables the Start Recording button and updates its title. When services become available, the method reenables the button and restores its original title.  

``` swift
public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
    if available {
        recordButton.isEnabled = true
        recordButton.setTitle("Start Recording", for: [])
    } else {
        recordButton.isEnabled = false
        recordButton.setTitle("Recognition Not Available", for: .disabled)
    }
}
```
