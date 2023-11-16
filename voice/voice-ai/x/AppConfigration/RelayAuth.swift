import CryptoKit
import DeviceCheck
import Foundation
import SwiftyJSON

class RelayAuth {
    private static let baseUrl = AppConfig.shared.getRelayUrl()
    private static let keyIdPath = "AppAttestKeyId"
    static let shared = RelayAuth()

    private var keyId: String?
    private var token: String?
    private var autoRefreshTokenTimer: Timer?
    private var lastRefreshTime: Int64 = 0

    private func initializeKeyId() async throws {
        self.keyId = try await DCAppAttestService.shared.generateKey()
        UserDefaults.standard.setValue(self.keyId, forKey: Self.keyIdPath)
    }

    @discardableResult func setup() async -> String? {
        defer { self.enableAutoRefreshToken() }
        return await self.refreshToken()
    }

    @discardableResult func refresh() async -> String? {
        let token = await refreshToken()
        self.disableAutoRefreshToken()
        self.enableAutoRefreshToken()
        return token
    }

    func getToken() -> String? {
        return self.token
    }

    init() {
        Task {
            await self.setup()
        }
    }

    func enableAutoRefreshToken() {
        guard self.autoRefreshTokenTimer == nil else {
            return
        }
        self.autoRefreshTokenTimer = Timer.scheduledTimer(withTimeInterval: 60 * 20, repeats: true) { _ in
            Task {
                await self.refreshToken()
            }
        }
    }

    func disableAutoRefreshToken() {
        self.autoRefreshTokenTimer?.invalidate()
        self.autoRefreshTokenTimer = nil
    }

    func tryInitializeKeyId() async {
        self.keyId = UserDefaults.standard.string(forKey: Self.keyIdPath)
        if self.keyId == nil {
            do {
                try await self.initializeKeyId()
            } catch {
                print("[RelayAuth][tryInitializeKeyId]", error)
            }
        }
    }

    func getChallenge() async -> String? {
        guard let baseUrl = Self.baseUrl else {
            return nil
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: "\(baseUrl)/hard/challenge") else {
            print("[RelayAuth] Invalid Relay URL")
            return nil
        }

        let req = URLRequest(url: url)
        do {
            let (data, _) = try await session.data(for: req)
            let res = JSON(data)
            let challenge = res["challenge"].string
            return challenge
        } catch {
            print("[RelayAuth] error", error)
            return nil
        }
    }

    func getAttestation(hash: Data) async throws -> String? {
        guard let keyId = self.keyId else {
            return nil
        }
        let s = try await DCAppAttestService.shared.attestKey(self.keyId!, clientDataHash: hash)
        return s.base64EncodedString()
    }

    @discardableResult func refreshToken() async -> String? {
        let now = Int64(Date().timeIntervalSince1970)
        if self.lastRefreshTime > now - 5 {
            print("[RelayAuth][refreshToken] token refresh rate limited; ignored")
            return nil
        }
        self.lastRefreshTime = now

        let service = DCAppAttestService.shared
        guard service.isSupported else {
            print("[RelayAuth][CRITICAL] DCAppAttestService not supported. Exiting")
            exit(1)
        }
        if self.keyId == nil {
            await self.tryInitializeKeyId()
        }
        let challenge = await self.getChallenge()
        guard let challenge = challenge else {
            print("[RelayAuth] Unable to get challenge from server")
            // TODO: retry or give some UI feedback / fallback
            return nil
        }
        let hash = Data(SHA256.hash(data: Data(challenge.utf8)))
        do {
            let attestation = try await self.getAttestation(hash: hash)
            guard let attestation = attestation else {
                print("[RelayAuth] attestation is nil")
                return nil
            }
            let token = await self.exchangeAttestationForToken(attestation: attestation, challenge: challenge)
            self.token = token
            return token
            // TODO: send attestation to relay, get token
        } catch {
            print("[RelayAuth] can't get attestation", error)
            return nil
        }
    }

    func exchangeAttestationForToken(attestation: String, challenge: String) async -> String? {
        guard let baseUrl = Self.baseUrl else {
            return nil
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: "\(baseUrl)/hard/attestation") else {
            print("Invalid Relay URL")
            return nil
        }

        let body = ["inputKeyId": self.keyId, "challenge": challenge, "attestation": attestation]

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
            print("[RelayAuth][exchangeAttestationForToken] error", error)
            return nil
        }
    }
}
