import AVFoundation
import Foundation
import SwiftyJSON

// TextToSpeechConverter class responsible for converting text to speech
class PlayHT: NSObject, URLSessionDataDelegate {
    
    private var session: URLSession
    private var receiveData: (String?, Error?) -> Void
    let (userId, apiKey) = AppConfig().getPlayHTCredentials()
    
    // TODO: add a playback unit here and a buffer we control
    
    init(receiveData: @escaping (String?, Error?) -> Void){
        self.session = URLSession(configuration: URLSessionConfiguration.default)
        self.receiveData = receiveData
        super.init()
    }
    
    func enque(text: String, quality: String = "high", sentiment: String = "female_happy", emotion: Double = 0.33, uniqueness: Double = 0.5, speed: Double = 1.0) {
        let url = URL(string: "https://api.play.ht/api/v2/tts/stream")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue(userId ?? "", forHTTPHeaderField: "X-USER-ID")
        request.addValue("audio/mpeg", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpMethod = "POST"
        request.httpBody = try! JSON([
//            "quality": "premium",
            "quality": quality,
//            "quality": "medium",
//            "quality": "low",
            "text": text,
            "sample_rate": 44100,
//            "seed": 0,
//            "tempurature": 1.0,
            "voice_engine": "PlayHT2.0-turbo",
            "emotion": sentiment,
            "voice": "s3://voice-cloning-zero-shot/1f44b3e7-22ea-4c2e-87d0-b4d9c8f1d47d/sophia/manifest.json", // sophia / american / PlayHT2.0
//            "voice": "s3://voice-cloning-zero-shot/820da3d2-3a3b-42e7-844d-e68db835a206/sarah/manifest.json", // sarah / british / PlayHT2.0
            "style_guidance": emotion * 29.0 + 1,
            "voice_guidance": uniqueness * 5.0 + 1,
        ]).rawData()
        
        // Print the input text being sent to OpenAI
        print("[PlayHT] Sending: \(text)")
        // Initiate the data task for the request
        let task = self.session.dataTask(with: request)
        task.delegate = self
        task.resume()
        
    }

    func stop() {
        // TODO: stop the playback unit and reset buffer
    }

    func pause() {
        // TODO: pause the playback unit.  Do not alter buffer
    }

    func resume() {
        // TODO: resume the playback unit. Do not alter buffer
    }
    
    
    // https://stackoverflow.com/questions/72630702/how-to-open-http-stream-on-ios-using-ndjson
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // TODO: add data to audio playback buffer
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error as NSError? {
            self.receiveData(nil, error)
            NSLog("[PlayHT] received error: %@ / %d", error.domain, error.code)
        } else {
            NSLog("[PlayHT] task complete")
        }
    }
}