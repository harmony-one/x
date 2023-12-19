import CryptoKit
import DeviceCheck
import Foundation
import OSLog
import Sentry
import SwiftyJSON

struct ClientUsageLog: Codable {
    let vendor: String
    let endpoint: String
    let model: String
    let requestTokens: Int32
    let responseTokens: Int32
    let requestNumMessages: Int32
    let requestNumUserMessages: Int32
    let requestMessage: String
    let responseMessage: String
    let cancelled: Bool
    let completed: Bool
    let error: String

    // measures
    let sttPreparationTime: Int64 // [APP-REC, STT-REC]
    let sttFinalizationTime: Int64 // [APP-REC-END, STT-END]
    let requestPreparationTime: Int64 // [STT-END, APP-SEND]
    let firstResponseTime: Int64 // [APP-SEND, APP-RES-1]
    let ttsPreparationTime: Int64 // [APP-RES-1, TTS-INIT]
    let firstUtteranceTime: Int64 // [TTS-INIT, APP-PLAY-1]
    let totalTtsTime: Int64 // [TTS-INIT, APP-PLAY-END]
    let totalClickToSpeechTime: Int64 // [APP-REC-END, APP-PLAY-1]
    let totalResponseTime: Int64 // [APP-SEND, APP-RES-END]
}

struct RelaySetting: Codable {
    let mode: String?
    let openaiBaseUrl: String?
}

protocol RelayAuthProtocol {
    
    var logger: Logger { get }
    func setup() async -> String?
    func refresh() async -> String?
    func generateKeyId(simulateError: Bool) async throws -> String
    func enableAutoRefreshToken(timeInterval: TimeInterval?)
    func disableAutoRefreshToken()
    func tryInitializeKeyId(simulateError: Bool) async throws
    func getToken() -> String?
    func getBaseUrl(_ customBaseUrl: String?) -> String?
    func getKeyId(_ customKeyId: String?) -> String?
    func getAttestationData(attestationDataErrorCode: Int?, keyId: String, clientDataHash: Data) async throws -> Data
    func getRelaySetting(customBaseUrl: String?) async -> RelaySetting?
    func getChallenge(customBaseUrl: String?) async -> String?
    func getAttestation(_ tryUseCached: Bool,
                        customKeyId: String?,
                        customBaseUrlInput: String?,
                        attestationDataErrorCode: Int?) async throws -> (String?, String?)
    func log(_ message: String)
    func getDeviceToken(_ regen: Bool, simulateError: Bool) async -> String?
}

class RelayAuth: RelayAuthProtocol {
    
    var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: "RelayAuth")
    )
    private static let baseUrl = AppConfig.shared.getRelayUrl()
    private static let disableLog = AppConfig.shared.getDisableRelayLog()
    private static let keyIdPath = "AppAttestKeyId"
    private static let attestationPath = "AppAttestationResult"
    private static let attestationChallengePath = "AppAttestationChallenge"
    static let shared = RelayAuth()

    private var deviceToken: String?
    private var keyId: String?
    private var token: String?
    private var autoRefreshTokenTimer: Timer?
    private var nextAvailableCallTime: Int64 = 0

    private func initializeKeyId(simulateError: Bool = false) async throws {
        keyId = try await generateKeyId(simulateError: simulateError)
        UserDefaults.standard.setValue(keyId, forKey: Self.keyIdPath)
        UserDefaults.standard.removeObject(forKey: Self.attestationPath)
        UserDefaults.standard.removeObject(forKey: Self.attestationChallengePath)
    }

    private func delayedRetry(on queue: DispatchQueue, retry: Int = 0, closure: @escaping () -> Void) {
        let delay = min(30000, Int(pow(2.0, Double(retry))) * 1000 + Int.random(in: 0 ... 1000))
        queue.asyncAfter(deadline: .now() + .milliseconds(delay), execute: closure)
    }

    private func autoRetryRefreshToken() async -> String? {
        let now = Int64(Date().timeIntervalSince1970 * 1000)
        if now < nextAvailableCallTime {
            log("[autoRetryRefreshToken] called too frequently, need to wait \(nextAvailableCallTime - now)ms")
            return nil
        }
        nextAvailableCallTime = now + 5000
        logger.log("[RelayAuth][autoRetryRefreshToken] setting nextAvailableCallTime=\(self.nextAvailableCallTime)")

        let maxRetry = 5
        var numRetries = 0
        while numRetries < maxRetry {
            do {
                return try await refreshToken()
            } catch {
                let error = error as NSError
                if error.code == -6 {
                    numRetries += 1
                    let delay = min(30000, Int(pow(2.0, Double(numRetries))) * 1000 + Int.random(in: 0 ... 1000))
                    do {
                        log("Refresh token error; Sleeping for \(delay)ms and try again (\(numRetries) attempts made)")
                        try await Task.sleep(nanoseconds: UInt64(delay * 1000000))
                    } catch {
                        logError("auto-retry cancelled", -7)
                        return nil
                    }
                } else {
                    logError(error, "numRetries: \(numRetries); major error; skipped retry for token refresh")
                    return nil
                }
            }
        }
        logError("auto-retry exceeded maximum number (\(maxRetry))", -7)
        return nil
    }

    @discardableResult func setup() async -> String? {
        defer { self.enableAutoRefreshToken() }
        return await autoRetryRefreshToken()
    }

    @discardableResult func refresh() async -> String? {
        let token = await autoRetryRefreshToken()
        disableAutoRefreshToken()
        enableAutoRefreshToken()
        return token
    }
    
    func generateDeviceToken(simulateError: Bool = false) async throws -> Data {
        if simulateError {
            throw NSError(domain: "RelayAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "RelayAuth generateDeviceToken error simulated"])
        } else {
            return try await DCDevice.current.generateToken()
        }
    }
    
    func generateKeyId(simulateError: Bool = false) async throws -> String {
        if simulateError {
            throw NSError(domain: "RelayAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "RelayAuth generateKeyId error simulated"])
        } else {
            return try await DCAppAttestService.shared.generateKey()
        }
    }

    func enableAutoRefreshToken(timeInterval: TimeInterval? = 20 * 60) {
        guard autoRefreshTokenTimer == nil else {
            return
        }
        autoRefreshTokenTimer = Timer.scheduledTimer(withTimeInterval: timeInterval!, repeats: true) { _ in
            Task {
                await self.autoRetryRefreshToken()
            }
        }
    }

    func disableAutoRefreshToken() {
        autoRefreshTokenTimer?.invalidate()
        autoRefreshTokenTimer = nil
    }

    func tryInitializeKeyId(simulateError: Bool = false) async {
        keyId = UserDefaults.standard.string(forKey: Self.keyIdPath)
        if keyId == nil {
            do {
                try await initializeKeyId(simulateError: simulateError)
            } catch {
                logError(error, "Cannot get key id")
            }
        }
    }
    
    func getToken() -> String? {
        return token
    }
    
    func getBaseUrl(_ customBaseUrl: String? = "") -> String? {
        if customBaseUrl == "" {
            return Self.baseUrl
        } else {
            return customBaseUrl
        }
    }
    
    func getKeyId(_ customKeyId: String? = "") -> String? {
        if customKeyId == "" {
            return keyId
        } else {
            return customKeyId
        }
    }
    
    func getAttestationData(attestationDataErrorCode: Int? = nil, keyId: String, clientDataHash: Data) async throws -> Data {
        if let errorCode = attestationDataErrorCode {
            throw NSError(domain: "RelayAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "RelayAuth getAttestationData error simulated"])
        } else {
            return try await DCAppAttestService.shared.attestKey(keyId, clientDataHash: clientDataHash)
        }
    }
    
    func getRelaySetting(customBaseUrl: String? = "") async -> RelaySetting? {
        let finalBaseUrl = getBaseUrl(customBaseUrl)
        guard let baseUrl = finalBaseUrl else {
            logError("Invalid base URL", -4)
            return nil
        }
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: conf)
        guard let url = URL(string: "\(baseUrl)/mode") else {
            logError("Invalid Relay URL", -3)
            return nil
        }

        let req = URLRequest(url: url)
        do {
            let (data, _) = try await session.data(for: req)
            let res = JSON(data)
            return RelaySetting(mode: res["mode"].string, openaiBaseUrl: res["openaiBaseUrl"].string)
        } catch {
            logError(error, "failed to get relay setting")
            return nil
        }
    }

    func getChallenge(customBaseUrl: String? = "") async -> String? {
        let finalBaseUrl = getBaseUrl(customBaseUrl)
        guard let baseUrl = finalBaseUrl else {
            logError("Invalid base URL", -4)
            return nil
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: "\(baseUrl)/hard/challenge") else {
            logError("Invalid Relay URL", -3)
            return nil
        }

        let req = URLRequest(url: url)
        do {
            let (data, _) = try await session.data(for: req)
            let res = JSON(data)
            let challenge = res["challenge"].string
            return challenge
        } catch {
            logError(error, "failed to get challenge")
            return nil
        }
    }

    func getAttestation(_ tryUseCached: Bool = true,
                        customKeyId: String? = "",
                        customBaseUrlInput: String? = "",
                        attestationDataErrorCode: Int? = nil) async throws -> (String?, String?) {
        let finalKeyId = getKeyId(customKeyId)
        guard let keyId = finalKeyId else {
            logError("No key id set", -5)
            return (nil, nil)
        }
        var attestation: String?, storedChallenge: String?
        if tryUseCached {
            // TODO: use keychain
            attestation = UserDefaults.standard.string(forKey: Self.attestationPath)
            storedChallenge = UserDefaults.standard.string(forKey: Self.attestationChallengePath)
            if attestation != nil, storedChallenge != nil {
                return (attestation, storedChallenge)
            }}

        // try await initializeKeyId()
        let challenge = await getChallenge(customBaseUrl: customBaseUrlInput)
        print("[logchallenge], \(challenge)")
        guard let challenge = challenge else {
            throw logError("Unable to get challenge from server", -2)
        }
        let hash = Data(SHA256.hash(data: Data(challenge.utf8)))
        var attestationData: Data?
        do {
            attestationData = try await getAttestationData(attestationDataErrorCode: attestationDataErrorCode, keyId: keyId, clientDataHash: hash)
        } catch {
            guard let error = error as? DCError else {
                throw error
            }
            logError(error, "[getAttestation] attestKey error")
            let errorCode = attestationDataErrorCode ?? error.code.rawValue
            if errorCode == DCError.Code.invalidKey.rawValue || errorCode == DCError.Code.serverUnavailable.rawValue || errorCode == DCError.Code.unknownSystemFailure.rawValue {
                try await initializeKeyId()
                attestationData = try await getAttestationData(keyId: keyId, clientDataHash: hash)
            }
        }
        let encodedString = attestationData?.base64EncodedString()
        UserDefaults.standard.setValue(encodedString, forKey: Self.attestationPath)
        UserDefaults.standard.setValue(challenge, forKey: Self.attestationChallengePath)
        return (encodedString, challenge)
    }

    func log(_ message: String) {
        logger.log("[RelayAuth] \(message)")
        SentrySDK.capture(message: "[RelayAuth] \(message)")
    }

    @discardableResult func logError(_ msg: String, _ code: Int) -> NSError {
        let error = NSError(domain: msg, code: code)
        logger.log("[RelayAuth][ERROR] \(code) \(msg)")
        SentrySDK.capture(error: error) { scope in
            scope.setTag(value: "RelayAuth", key: "module")
        }
        return error
    }

    @discardableResult func logError(_ error: Error, _ detail: String = "") -> Error {
        logger.log("[RelayAuth][ERROR] \(detail) \(error)")
        SentrySDK.capture(error: error) { scope in
            scope.setExtra(value: detail, key: "detail")
            scope.setTag(value: "RelayAuth", key: "module")
        }
        return error
    }

    @discardableResult private func refreshToken(_ useCache: Bool = true) async throws -> String? {
        let service = DCAppAttestService.shared
        guard service.isSupported else {
            throw logError("DCAppAttestService not supported", -1)
        }
        if keyId == nil {
            await tryInitializeKeyId()
        }

        var attestation: String?
        var challenge: String?
        do {
            (attestation, challenge) = try await getAttestation(useCache)
        } catch {
            throw logError("temporary error for getting attestation", -6)
        }

        guard let attestation = attestation else {
            throw logError("attestation is deliberately set to nil", -2)
        }
        guard let challenge = challenge else {
            throw logError("challenge is deliberately set to nil", -8)
        }

        do {
            let token = try await exchangeAttestationForToken(attestation: attestation, challenge: challenge)
            // throw NSError(domain:"testing", code: -6)
            self.token = token
            logger.log("[RelayAuth] received token \(token ?? "N/A", privacy: .public)")
            return token
        } catch {
            let error = error as NSError
            if error.code == -10 {
                try await Task.sleep(nanoseconds: 1000000000)
                try await initializeKeyId()
                return try await refreshToken(false)
            }
            throw error
        }
    }

    func exchangeAttestationForToken(attestation: String, challenge: String, customBaseUrl: String? = "", simulateErrorStatusCode: Int? = nil) async throws -> String? {
        let finalBaseUrl = getBaseUrl(customBaseUrl)
        guard let baseUrl = finalBaseUrl else {
            throw logError("Invalid base URL", -4)
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: "\(baseUrl)/hard/attestation") else {
            throw logError("Invalid Relay URL", -3)
        }

        let body = ["inputKeyId": keyId, "challenge": challenge, "attestation": attestation]

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSON(body).rawData()
//            self.logger.log("[RelayAuth][exchangeAttestationForToken] sending \(body)")
        let (data, response) = try await session.data(for: req)
        let httpResponse = response as? HTTPURLResponse
        let httpResponseStatusCode = simulateErrorStatusCode ?? httpResponse?.statusCode
        if httpResponseStatusCode == 410 {
            throw logError("new attestation and new key required", -10)
        }
        if httpResponseStatusCode == 200 {
            let res = JSON(data)
            let token = res["token"].string
            return token
        } else {
            throw logError("cannot get attestation from relay", -11)
        }
    }

    func getDeviceToken(_ regen: Bool = false, simulateError: Bool = false) async -> String? {
        if deviceToken != nil, !regen {
            return deviceToken
        }
        do {
            let deviceTokenData = try await generateDeviceToken(simulateError: simulateError)
            self.deviceToken = deviceTokenData.base64EncodedString()
            return self.deviceToken
        } catch {
            logError("Error generating device token", -9)
            return nil
        }
    }

    func record(_ record: ClientUsageLog) async {
        if Self.disableLog {
            return
        }
        guard let baseUrl = Self.baseUrl else {
            logError("Invalid base URL", -4)
            return
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: "\(baseUrl)/\(AppConfig.shared.getRelayMode() ?? "soft")/log") else {
            logError("Invalid Relay URL", -3)
            return
        }

        guard let token = await getDeviceToken() else {
            return
        }
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-DEVICE-TOKEN")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let body = try JSONEncoder().encode(record)
            request.httpBody = body
//            self.logger.log("[RelayAuth][log] sending \(String(data: body, encoding: .utf8)!)")
            let (data, _) = try await session.data(for: request)
            let res = JSON(data)
            let success = res["success"].bool
            logger.log("[RelayAuth][log] success: \(success ?? false)")
        } catch {
            logError(error, "error sending record")
            return
        }
    }
}
