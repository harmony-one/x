import Foundation
import OSLog
import DeviceCheck

class MockRelayAuth: RelayAuthProtocol {
    var setupCalled = false
    var autoRetryRefreshTokenCalled = false
    
    func refresh() async -> String? {
        return nil
    }
    
    func enableAutoRefreshToken(timeInterval: TimeInterval?) {
        print("enableAutoRefreshToken")
    }
    
    func disableAutoRefreshToken() {
        print("disableAutoRefreshToken")
    }
    
    func tryInitializeKeyId(simulateError: Bool) async throws { }
    
    func getToken() -> String? {
        return nil
    }
    
    func getBaseUrl(_ customBaseUrl: String?) -> String? {
        return nil
    }
    
    func getKeyId(_ customKeyId: String?) -> String? {
        return nil
    }
    
    func getAttestationData(attestationDataErrorCode: Int?, keyId: String, clientDataHash: Data) async throws -> Data {
        if let errorCode = attestationDataErrorCode {
            throw NSError(domain: "RelayAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "RelayAuth getAttestationData error simulated"])
        } else {
            return try await DCAppAttestService.shared.attestKey(keyId, clientDataHash: clientDataHash)
        }
    }
    
    func getRelaySetting(customBaseUrl: String?) async -> RelaySetting? {
        return nil
    }
    
    func getChallenge(customBaseUrl: String?) async -> String? {
        return nil
    }
    
    func getAttestation(_ tryUseCached: Bool, customKeyId: String?, customBaseUrlInput: String?, attestationDataErrorCode: Int?) async throws -> (String?, String?) {
        return (nil, nil)
    }
    
    func log(_ message: String) {
        print("log")
    }
    
    func setup() async -> String? {
        return ""
    }
    
    func getDeviceToken(_ regen: Bool = false, simulateError: Bool = false) async -> String? {
        return nil
    }
    
    func generateKeyId(simulateError: Bool) async throws -> String {
        return "key"
    }
    
    var logger: Logger {
        // Return a mock logger
        return Logger(subsystem: "MockRelayAuth", category: "MockRelayAuth")
    }
      
    var deviceToken: String? {
        // Return a mock device token
        return "mock-device-token"
    }

    var keyId: String? {
        // Return a mock key ID
        return "mock-key-id"
    }

    var token: String? {
        // Return a mock token
        return "mock-token"
    }

    var nextAvailableCallTime: Int64 {
        // Return a mock next available call time
        return 1000
    }

    func delayedRetry(on queue: DispatchQueue, retry: Int = 0, closure: @escaping () -> Void) {
        // Implement the delayedRetry method to simulate a delay
        queue.asyncAfter(deadline: .now() + .milliseconds(100), execute: closure)
    }

    func autoRetryRefreshToken() async -> String? {
        // Implement the autoRetryRefreshToken method to return a mock token
        return "mock-token"
    }
}
