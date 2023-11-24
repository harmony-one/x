import CryptoKit
import DeviceCheck
import Foundation
import Sentry
import SwiftyJSON

class RelayAuth {
    private static let baseUrl = AppConfig.shared.getRelayUrl()
    private static let keyIdPath = "AppAttestKeyId"
    private static let attestationPath = "AppAttestationResult"
    private static let attestationChallengePath = "AppAttestationChallenge"
    private static let attestationTimePath = "AppAttestationTime"
    static let shared = RelayAuth()

    private var keyId: String?
    private var token: String?
    private var autoRefreshTokenTimer: Timer?
    private var nextAvailableCallTime: Int64 = 0

    private func initializeKeyId() async throws {
        keyId = try await DCAppAttestService.shared.generateKey()
        UserDefaults.standard.setValue(keyId, forKey: Self.keyIdPath)
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
        print("[RelayAuth][autoRetryRefreshToken] setting nextAvailableCallTime=\(nextAvailableCallTime)")

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
                        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000))
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

    func getToken() -> String? {
        return token
    }

    func enableAutoRefreshToken() {
        guard autoRefreshTokenTimer == nil else {
            return
        }
        autoRefreshTokenTimer = Timer.scheduledTimer(withTimeInterval: 60 * 20, repeats: true) { _ in
            Task {
                await self.autoRetryRefreshToken()
            }
        }
    }

    func disableAutoRefreshToken() {
        autoRefreshTokenTimer?.invalidate()
        autoRefreshTokenTimer = nil
    }

    func tryInitializeKeyId() async {
        keyId = UserDefaults.standard.string(forKey: Self.keyIdPath)
        if keyId == nil {
            do {
                try await initializeKeyId()
            } catch {
                logError(error, "Cannot get key id")
            }
        }
    }

    func getChallenge() async -> String? {
        guard let baseUrl = Self.baseUrl else {
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

    func getAttestation() async throws -> (String?, String?) {
        guard let keyId = keyId else {
            logError("No key id set", -5)
            return (nil, nil)
        }
        // TODO: use keychain
        let attestation = UserDefaults.standard.string(forKey: Self.attestationPath)
        let attestationTime = UserDefaults.standard.double(forKey: Self.attestationTimePath)
        let storedChallenge = UserDefaults.standard.string(forKey: Self.attestationChallengePath)
        let now = Double(Date().timeIntervalSince1970)
        if attestationTime > now - 3600 * 24 * 8, attestation != nil, storedChallenge != nil {
            return (attestation, storedChallenge)
        }

        let challenge = await getChallenge()
        guard let challenge = challenge else {
            throw logError("Unable to get challenge from server", -2)
        }
        let hash = Data(SHA256.hash(data: Data(challenge.utf8)))
        let attestService = try await DCAppAttestService.shared.attestKey(keyId, clientDataHash: hash)
        let encodedString = attestService.base64EncodedString()
        UserDefaults.standard.setValue(encodedString, forKey: Self.attestationPath)
        UserDefaults.standard.setValue(now, forKey: Self.attestationTimePath)
        UserDefaults.standard.setValue(challenge, forKey: Self.attestationChallengePath)
        return (encodedString, challenge)
    }

    func log(_ message: String) {
        print("[RelayAuth]", message)
        SentrySDK.capture(message: "[RelayAuth] \(message)")
    }

    @discardableResult func logError(_ msg: String, _ code: Int) -> NSError {
        let error = NSError(domain: msg, code: code)
        print("[RelayAuth][ERROR]", code, msg)
        SentrySDK.capture(error: error) { scope in
            scope.setTag(value: "RelayAuth", key: "module")
        }
        return error
    }

    @discardableResult func logError(_ error: Error, _ detail: String = "") -> Error {
        print("[RelayAuth][ERROR]", detail)
        SentrySDK.capture(error: error) { scope in
            scope.setExtra(value: detail, key: "detail")
            scope.setTag(value: "RelayAuth", key: "module")
        }
        return error
    }

    @discardableResult private func refreshToken() async throws -> String? {
        let service = DCAppAttestService.shared
        guard service.isSupported else {
            throw logError("DCAppAttestService not supported", -1)
        }
        if keyId == nil {
            await tryInitializeKeyId()
        }

        do {
            let (attestation, challenge) = try await getAttestation()
            guard let attestation = attestation else {
                throw logError("attestation is deliberately set to nil", -2)
            }
            guard let challenge = challenge else {
                throw logError("challenge is deliberately set to nil", -8)
            }
            let token = await exchangeAttestationForToken(attestation: attestation, challenge: challenge)
            // throw NSError(domain:"testing", code: -6)
            self.token = token
            print("[RelayAuth] received token \(token ?? "N/A")")
            return token
        } catch {
            throw logError("temporary error for getting attestation", -6)
        }
    }

    func exchangeAttestationForToken(attestation: String, challenge: String) async -> String? {
        guard let baseUrl = Self.baseUrl else {
            logError("Invalid base URL", -4)
            return nil
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: "\(baseUrl)/hard/attestation") else {
            logError("Invalid Relay URL", -3)
            return nil
        }

        let body = ["inputKeyId": keyId, "challenge": challenge, "attestation": attestation]

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            req.httpBody = try JSON(body).rawData()
//            print("[RelayAuth][exchangeAttestationForToken] sending \(body)")
            let (data, _) = try await session.data(for: req)
            let res = JSON(data)
            let token = res["token"].string
            return token
        } catch {
            logError(error, "exchangeAttestationForToken error")
            return nil
        }
    }
}
