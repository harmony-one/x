import CryptoKit
import DeviceCheck
import Foundation
import SwiftyJSON

class OpenAIServiceViaRelay: NSObject, URLSessionDataDelegate {
    private var session: URLSession
    private var completion: (String?, Error?) -> Void
    private let relay = Self.config.getRelay() ?? "https://x-country-app-relay.hiddenstate.xyz"

    static let config = AppConfig()
    private static var token: String?

    // TODO: move this to app's local storage or cloud kit so it persists between runs
    private static var keyId: String?

    init(completion: @escaping (String?, Error?) -> Void) {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
        self.completion = completion
        super.init()
    }

    @discardableResult func generateKeyId() async -> String? {
        // TODO: switch to throwing
        return await withCheckedContinuation { continuation in
            DCAppAttestService.shared.generateKey { keyId, error in
                guard error == nil else {
                    print("[Attestation] failed to generate key", error!)
                    continuation.resume(returning: nil)
                    return
                }
                Self.keyId = keyId
                continuation.resume(returning: keyId)
                // TODO: persist keyId
            }
        }
    }

    // TODO: make static
    func getChallenge() async -> String? {
        guard let url = URL(string: "\(self.relay)/challenge") else {
            print("Invalid Relay URL")
            return nil
        }

        let req = URLRequest(url: url)
        do {
            let (data, _) = try await self.session.data(for: req)
            let res = JSON(data)
            let challenge = res["challenge"].string
            return challenge
        } catch {
            print("[Attestation] error", error)
            return nil
        }
    }

    // TODO: make static
    func getAttestation(hash: Data) async throws -> String? {
        // TODO: require valid keyId
        return try await withCheckedThrowingContinuation { continuation in
            DCAppAttestService.shared.attestKey(Self.keyId!, clientDataHash: hash) { attestation, error in
                guard error == nil else {
                    print("Unable to get attestation from Apple")
                    continuation.resume(throwing: error!)
                    return
                }
                // TODO: Send the attestation object to your server for verification.
                let attestationString = attestation?.base64EncodedString()
                continuation.resume(returning: attestationString)
            }
        }
    }

    // TODO: make static
    func refreshToken() async {
        // TODO:
        let service = DCAppAttestService.shared
        guard service.isSupported else {
            print("CRITICAL ERROR: DCAppAttestService not supported. Exiting")
            exit(0)
        }
        if Self.keyId == nil {
            await self.generateKeyId()
        }
        let challenge = await self.getChallenge()
        guard let challenge = challenge else {
            print("Unable to get challenge from server")
            // TODO: retry or give some UI feedback / fallback
            return
        }
        let hash = Data(SHA256.hash(data: Data(challenge.utf8)))
        do {
            let attestation = try await self.getAttestation(hash: hash)
            // TODO: send attestation to relay, get token
        } catch {
            print("[Attestation] can't get attestation", error)
        }
    }
    
// Note: Individual requests can also be asserted and verified by server
//        let request = [ "action": "blah", "challenge": challenge ]
//        guard let clientData = try? JSONEncoder().encode(request) else { return }
//        let clientDataHash = Data(SHA256.hash(data: clientData))
//        service.generateAssertion(Self.keyId!, clientDataHash: clientDataHash) { assertion, error in
//            guard error == nil else { /* Handle the error. */ }
//            // Send the assertion and request to your server.
//        }

    // Function to send input text to OpenAI for processing
    func query(prompt: String) {
        guard let token = Self.token else {
            self.completion(nil, NSError(domain: "No token", code: -2))
            return
        }

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(token)"
        ]

        let body: [String: Any] = [
            "model": "gpt-4-32k",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "temperature": 0.5, // TODO: make temperature adjustable by init
            "stream": true
        ]

        // Validate the URL
        guard let url = URL(string: "\(self.relay)/openai/completions") else {
            let error = NSError(domain: "Invalid API URL", code: -1, userInfo: nil)
            self.completion(nil, error)
            return
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        // Try to serialize the body as JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            self.completion(nil, error)
            return
        }

        // Print the input text being sent to OpenAI
        print("Sending to OpenAI: \(prompt)")

        // Initiate the data task for the request
        let task = self.session.dataTask(with: request)
        task.delegate = self
        task.resume()
    }

    // https://stackoverflow.com/questions/72630702/how-to-open-http-stream-on-ios-using-ndjson
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        print("Raw response from OpenAI: \(String(data: data, encoding: .utf8) ?? "Unable to decode response")")
        let str = String(data: data, encoding: .utf8)
        guard let str = str else {
            let error = NSError(domain: "Unable to decode string", code: -2, userInfo: ["body": str ?? ""])
            self.completion(nil, error)
            return
        }
//        print("OpenAI: raw response: ", str)
        let chunks = str.components(separatedBy: "\n\n").filter { chunk in chunk.hasPrefix("data:") }
//        print("OpenAI: chunks", chunks)
        for chunk in chunks {
            let dataBody = chunk.suffix(chunk.count - 5).trimmingCharacters(in: .whitespacesAndNewlines)
            if dataBody == "[DONE]" {
                continue
            }
            let res = JSON(parseJSON: dataBody)

            let delta = res["choices"][0]["delta"]["content"].string
            self.completion(delta, nil)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error as NSError? {
            self.completion(nil, error)
            NSLog("OpenAI: received error: %@ / %d", error.domain, error.code)
        } else {
            NSLog("OpenAI: task complete")
        }
    }
}
