import XCTest
import Combine
import OSLog
import DeviceCheck
@testable import Voice_AI

class MockRelayAuth: RelayAuthProtocol {
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
    var setupCalled = false
    var autoRetryRefreshTokenCalled = false
    
// Implement the required methods of the RelayAuth protocol
  
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

//  var autoRefreshTokenTimer: Timer? {
//      // Return a mock timer
//      return Timer.init(timeInterval: 10, repeats: false) { timer in
//          // Call the autoRetryRefreshToken method to simulate a token refresh
//          self.autoRetryRefreshToken()
//      }
//  }

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

class AppConfigTests: XCTestCase {
    
    var appConfig: AppConfig!
    
    override func setUp() {
        super.setUp()

        let initializationExpectation = expectation(description: "AppConfig initialization")

        appConfig = AppConfig.shared
        DispatchQueue.global().async {
            // This will ensure that the init() method has finished before proceeding with the tests.
            initializationExpectation.fulfill()
        }

        // Wait for the initialization to complete before running tests.
        waitForExpectations(timeout: 5) // Adjust the timeout as needed.
    }

    override func tearDown() {
        appConfig = nil
        super.tearDown()
    }
    
    func testInitRelayModeServer() {
        let bundleDic  = [
            "RELAY_MODE": "server",
        ] as [String : Any]
        let mockRelay = MockRelayAuth()
        let appConfig = AppConfig(dic: bundleDic, relay: mockRelay)
    }
    
    func testGetterMethods() {
//        XCTAssertNotNil(appConfig.getOpenAIKey(), "OpenAIKey should not be nil")
        XCTAssertNotNil(appConfig.getOpenAIBaseUrl(), "OpenAIBaseUrl should not be nil")
        XCTAssertNotNil(appConfig.getSentryDSN(), "Sentry DSN should not be nil")
        XCTAssertNotNil(appConfig.getMinimumSignificantEvents(), "MinimumSignificantEvents should not be nil")
        XCTAssertNotNil(appConfig.getDaysBetweenPrompts(), "DaysBetweenPrompts should not be nil")
        XCTAssertNotNil(appConfig.getThemeName(), "ThemeName should not be nil")
        XCTAssertNotNil(appConfig.getSharedEncryptionSecret(), "SharedEncryptionSecret should not be nil")
        XCTAssertNotNil(appConfig.getSharedEncryptionIV(), "SharedEncryptionIV should not be nil")
        XCTAssertNotNil(appConfig.getRelayUrl(), "RelayUrl should not be nil")
        XCTAssertNotNil(appConfig.getRelayMode(), "RelayMode should not be nil")
        XCTAssertNotNil(appConfig.getWhiteLabelListString(), "WhiteLabelListString should not be nil")
        XCTAssertNotNil(appConfig.getDisableRelayLog(), "DisableRelayLog should not be nil")
        XCTAssertNotNil(appConfig.getEnableTimeLoggerPrint(), "EnableTimeLoggerPrint should not be nil")
        XCTAssertNotNil(appConfig.getServerAPIKey(), "ServerAPIKey should not be nil")
        XCTAssertNotNil(appConfig.getPaymentMode(), "PaymentMode should not be nil")
        XCTAssertNotNil(appConfig.getMixpanelToken(), "MixpanelToken should not be nil")
    }
    
    func testInvalidConfigurationFile() {
        let bundleDic  = [:] as [String : Any]
        let  appConfig = AppConfig(dic: bundleDic)
        XCTAssertNil(appConfig.getSentryDSN())
        XCTAssertNil(appConfig.getSharedEncryptionSecret())
        XCTAssertNil(appConfig.getSharedEncryptionIV())
        XCTAssertNil(appConfig.getRelayUrl())
        XCTAssertNil(appConfig.getRelayMode())
        XCTAssertFalse(appConfig.getDisableRelayLog())
        XCTAssertFalse(appConfig.getEnableTimeLoggerPrint())
        XCTAssertEqual(appConfig.getThemeName(), AppThemeSettings.blackredTheme.settings.name)
        XCTAssertNil(appConfig.getServerAPIKey())
        XCTAssertEqual(appConfig.getPaymentMode(), "sandbox")
        XCTAssertNil(appConfig.getMixpanelToken())
    }
    
    func testConfigurationFileOpenAIKey() {
        let openAIKey = "12345"
        let bundleDic  = [
            "API_KEY": openAIKey
        ] as [String : Any]
        let  appConfig = AppConfig(dic: bundleDic)
        XCTAssertEqual(appConfig.getOpenAIKey(), openAIKey)
    }
    
    func testConfigurationFileRelay() {
        let bundleDic  = [
            "RELAY_MODE": "test",
        ] as [String : Any]
        let  appConfig = AppConfig(dic: bundleDic)
        XCTAssertEqual(appConfig.getRelayMode(), "test")
    }
    
    func testRequestOpenAIKey() {
        let bundleDic  = [
            "RELAY_MODE": "test",
            "RELAY_BASE_URL": "http://Invalid relay url ////// ()()()()"
        ] as [String : Any]
        let  appConfig = AppConfig(dic: bundleDic)
    }
    
    func testRequestOpenAIKeyGetDeviceToken() async {
        let mockRelay = MockRelayAuth()
        let appConfig = AppConfig(relay: mockRelay)
        await appConfig.requestOpenAIKeyTest()
    }
    
    func testCheckWhiteLabelListNoUserName() async {
        let result = await appConfig.checkWhiteLabelList(username: "")
        XCTAssertFalse(result, "No user")
    }
    
    func testCheckWhiteLabelListNoRelayURL() async {
        let bundleDic  = [
            "RELAY_MODE": "test",
        ] as [String : Any]
        let  appConfig = AppConfig(dic: bundleDic)
        let result = await appConfig.checkWhiteLabelList(username: "test")
        XCTAssertFalse(result, "No relay url")
    }
    
    func testCheckWhiteLabelListInvalidRelayURL() async {
        let bundleDic  = [
            "RELAY_MODE": "test",
            "RELAY_BASE_URL": "http://Invalid relay url ////// ()()()()"
        ] as [String : Any]
        let  appConfig = AppConfig(dic: bundleDic)
        let result = await appConfig.checkWhiteLabelList(username: "test")
        XCTAssertFalse(result, "Invalid Relay URL")
    }
    
    func testRenewRelayAuth() {
        let bundleDic  = [
            "RELAY_MODE": "test",
            "RELAY_BASE_URL": "http://Invalid relay url ////// ()()()()"
        ] as [String : Any]
        let  appConfig = AppConfig(dic: bundleDic)
        appConfig.renewRelayAuth()
    }
    
    func testRequestOpenAIKeyTest() async {
       await appConfig.requestOpenAIKeyTest()
    }
    
    func testDecrypted() {
         let bundleDic  = [
             "SHARED_ENCRYPTION_IV": appConfig.getSharedEncryptionIV() ?? "",
             "SHARED_ENCRYPTION_SECRET": appConfig.getSharedEncryptionSecret() ?? ""
         ] as [String : Any]

         let testAppConfig = AppConfig(dic: bundleDic)
         let base64EncodedEncryptedKey = "test key"
         do {
             let decryptedKey = try  testAppConfig.decryptTest(base64EncodedEncryptedKey: base64EncodedEncryptedKey)

             // Assert
             XCTAssertNotNil(testAppConfig.getOpenAIKey())
         } catch {
             XCTFail("Unexpected error: \(error)")
         }
     }
    
//    func testDecrypted() {
//
//        let bundleDic  = [
//            "SHARED_ENCRYPTION_IV": appConfig.getSharedEncryptionIV() ?? "",
//            "SHARED_ENCRYPTION_SECRET": appConfig.getSharedEncryptionSecret() ?? ""
//        ] as [String : Any]
//        let  testAppConfig = AppConfig(dic: bundleDic)
//        let dummyKey = "ThisIsADummyKeyForTesting"
//
//        // Convert the key to data
//        let keyData = dummyKey.data(using: .utf8)!
//
//        // Encrypt the key (in a real scenario, you would use a proper encryption algorithm)
//        let encryptedData = keyData.map { $0 ^ 42 } // XOR with a dummy value for simplicity
//
//        // Base64 encode the encrypted data
//        let base64EncodedEncryptedKey = encryptedData.toBase64()
//        
////        let base64EncodedEncryptedKey = base64.b64decode("eyJrZXkiOiAidmFsdWUiOlt7IlJlc29sdmFsImlzcyI6Imh0dHA6Ly9zdGF0aWMuY29tL3F1ZXN0aW9ucyIsInVzZXJfaWQiOiAidmFsdWUifQ==\")
//        do {
//            let decryptedKey = try  testAppConfig.decryptTest(base64EncodedEncryptedKey: base64EncodedEncryptedKey)
//            
//            // Assert
//            XCTAssertNotNil(testAppConfig.getOpenAIKey())
//        } catch {
//            XCTFail("Unexpected error: \(error)")
//        }
//    }
}

class TimerManagerTests: XCTestCase {
    var timerManager: TimerManager!
    
    override func setUp() {
        super.setUp()
        timerManager = TimerManager()
    }
    
    override func tearDown() {
        timerManager = nil
        super.tearDown()
    }
    
    func testStartTimer() {
        XCTAssertNil(timerManager.timerCancellable)
        timerManager.startTimer()
        sleep(2)
        XCTAssertNotNil(timerManager.timerCancellable)
    }
    
//    func testResetTimer() {
//        XCTAssertNil(timerManager.timerCancellable)
//        timerManager.resetTimer()
//        sleep(2)
//        XCTAssertNotNil(timerManager.timerCancellable)
//    }
    
//TODO: In TimerManager.swift, the timer is currently set to: TimeInterval = 10_000_000_000_000 for beta purpose and the duration for expectation should be much shorter. As that TODO is solved, modify this.
    func testResetTimer() {
        XCTAssertNil(timerManager.timerCancellable)
        
        var timerDidFireCalled = false
        let timerDidFireExpectation = expectation(description: "timerDidFire called")

        NotificationCenter.default.addObserver(forName: .timerDidFireNotification, object: nil, queue: nil) { _ in
            timerDidFireCalled = true
            timerDidFireExpectation.fulfill()
        }

        timerManager.resetTimer()

        waitForExpectations(timeout: 5.0, handler: nil)

        XCTAssertNotNil(timerManager.timerCancellable)
        XCTAssertTrue(timerDidFireCalled)
    }
    
    func testStopTimer() {
        XCTAssertNil(timerManager.timerCancellable)
        
        timerManager.startTimer()
        sleep(2)
        XCTAssertNotNil(timerManager.timerCancellable)
        
        timerManager.stopTimer()
        sleep(2)
        XCTAssertNil(timerManager.timerCancellable)
    }
    
    func testTimerDidFire() {
        let notificationExpectation = expectation(forNotification: .timerDidFireNotification, object: nil, handler: nil)
        
        timerManager.triggerTimerDidFire()
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(timerManager.timerCancellable)
    }
}

class SettingsBundleHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
        UserDefaults.standard.removeObject(forKey: SettingsBundleHelper.SettingsBundleKeys.Username)
    }
    
    override func tearDown() {
        super.tearDown()
        UserDefaults.standard.removeObject(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomInstruction)
        UserDefaults.standard.removeObject(forKey: SettingsBundleHelper.SettingsBundleKeys.Username)
    }
    
    func testSetDefaultValuesWithModeDefault() {
        SettingsBundleHelper.setDefaultValues()
        let customInstruction = UserDefaults.standard.string(forKey: "custom_instruction_preference")
        
        XCTAssertEqual(customInstruction, """
         We are having a face-to-face voice conversation. Be concise, direct and certain. Avoid apologies, interjections, disclaimers, pleasantries, confirmations, remarks, suggestions, chitchats, thankfulness, acknowledgements. Never end with questions. Never mention your being AI or knowledge cutoff. Your name is Sam.
         """)
    }
    
    func testSetDefaultValuesWithModeQuickFacts() {
        let customMode = "mode_quick_facts"
        SettingsBundleHelper.setDefaultValues(customMode: customMode)
        let customInstruction = UserDefaults.standard.string(forKey: "custom_instruction_preference")
        
        XCTAssertEqual(customInstruction, """
         Your name is Sam. Focus on providing rapid, straightforward answers to factual queries. Your responses should be brief, accurate, and to the point, covering a wide range of topics. Avoid elaboration or anecdotes unless specifically requested. Ideal for users seeking quick facts or direct answers you should answer in as few words as possible.

            Example Interaction Style:

            User: "What's the capital of Canada?"
            Sam: "Ottawa."
            User: "Who wrote '1984'?"
            Sam: "George Orwell."
         """
         )
    }
    
    func testSetDefaultValuesWithModeInteractiveTutor() {
        let customMode = "mode_interactive_tutor"
        SettingsBundleHelper.setDefaultValues(customMode: customMode)
        let customInstruction = UserDefaults.standard.string(forKey: "custom_instruction_preference")
        
        XCTAssertEqual(customInstruction, """
         Your name is Sam, an engaging and interactive tutor, skilled at simplifying complex topics adaptive to the learner’s needs. You are in the same room as the learner, conversing directly with them. Conduct interactive discussions, encouraging questions and participation from the user as much as possible. You have 10 minutes to teach something new, making the subject accessible and interesting. Use analogies, real-world examples, and interactive questioning to enhance understanding. Keep output short to ensure the learner is following. You foster a two-way learning environment, making the educational process more engaging and personalized, and ensuring the user plays an active role in their learning journey. NEVER repeat unless asked by the learner.
         """)
    }
    
    func testHasPremiumMode() {
        UserDefaults.standard.set("stse", forKey: SettingsBundleHelper.SettingsBundleKeys.Username)
        
        let hasPremium = SettingsBundleHelper.hasPremiumMode()
        XCTAssertTrue(hasPremium)
    }
    
    func testDoesntHavePremiumMode() {
        UserDefaults.standard.set("9xaQhaniaAzO10d4IrbEdiTvMvxZxwM9gBQwnrMBYgkU3EqGsaXBoxWpk575izlU",
              forKey: SettingsBundleHelper.SettingsBundleKeys.Username)
        
        let hasPremium = SettingsBundleHelper.hasPremiumMode()
        XCTAssertFalse(hasPremium)
    }
    
    func testGetUserName() {
        UserDefaults.standard.set("TestUser", forKey: SettingsBundleHelper.SettingsBundleKeys.Username)
        
        let username = SettingsBundleHelper.getUserName()
        
        XCTAssertEqual(username, "TestUser")
    }
}


class RelayAuthTests: XCTestCase {
    
    var relayAuth: RelayAuth!
    
    override func setUp() {
        super.setUp()
        relayAuth = RelayAuth.shared
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetToken() {
        let expectation = expectation(description: "Refresh completion")
        Task {
            do {
                await self.relayAuth.refresh()
                XCTAssertNotNil(self.relayAuth.getToken())
                expectation.fulfill()
            } catch {
                XCTFail("Error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testEnableAutoRefreshToken() {
        let expectation = expectation(description: "Auto-refresh completion")
        relayAuth.enableAutoRefreshToken(timeInterval: 1)
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 8)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    // tryInitializeKeyId tests
    func testTryInitializeKeyIdNil() {
        UserDefaults.standard.removeObject(forKey: "AppAttestKeyId")
        let expectation = expectation(description: "Initialize keyId")
        Task {
            await relayAuth.tryInitializeKeyId()
            XCTAssertNotNil(UserDefaults.standard.string(forKey: "AppAttestKeyId"))
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testTryInitializeKeyIdError() {
        UserDefaults.standard.removeObject(forKey: "AppAttestKeyId")
        let expectation = expectation(description: "tryInitializeKeyId")
        Task {
            await relayAuth.tryInitializeKeyId(simulateError: true)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    // getDeviceToken Tests
    func testGetDeviceTokenRegenFalse() {
        let expectation = expectation(description: "getDeviceToken")
        Task {
            // call twice to make sure deviceToken != nil
            await relayAuth.getDeviceToken()
            let result = await relayAuth.getDeviceToken()
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetDeviceTokenRegenTrue() {
        let expectation = expectation(description: "getDeviceToken")
        Task {
            let result = await relayAuth.getDeviceToken(true)
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetDeviceTokenError() {
        let expectation = expectation(description: "getDeviceToken")
        Task {
            let result = await relayAuth.getDeviceToken(simulateError: true)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    // exchangeAttestationForToken tests
//    func testExchangeAttestationForTokenInvalidBaseUrl() {
//        relayAuth.exchangeAttestationForToken(attestation: <#T##String#>, challenge: <#T##String#>)
//    }
    
    // getRelaySetting Tests
    func testGetRelaySettingInvalidBaseUrl() {
        let expectation = expectation(description: "getRelaySetting")
        Task {
            let result = await relayAuth.getRelaySetting(customBaseUrl: nil)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetRelaySettingInvalidRelayUrl() {
        let expectation = expectation(description: "getRelaySetting")
        Task {
            let result = await relayAuth.getRelaySetting(customBaseUrl: "テスト")
            XCTAssertNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetRelaySettingFailRelaySetting() {
        let expectation = expectation(description: "getRelaySetting")
        Task {
            let result = await relayAuth.getRelaySetting(customBaseUrl: "test")
            XCTAssertNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetRelaySettingValidRelaySetting() {
        let expectation = expectation(description: "getRelaySetting")
        Task {
            let result = await relayAuth.getRelaySetting()
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    // getChallenge Tests
    func testGetChallengeInvalidBaseUrl() {
        let expectation = expectation(description: "getChallenge")
        Task {
            let result = await relayAuth.getChallenge(customBaseUrl: nil)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetChallengeInvalidRelayUrl() {
        let expectation = expectation(description: "getChallenge")
        Task {
            let result = await relayAuth.getChallenge(customBaseUrl: "テスト")
            XCTAssertNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetChallengeFailChallenge() {
        let expectation = expectation(description: "getChallenge")
        Task {
            let result = await relayAuth.getChallenge(customBaseUrl: "test")
            XCTAssertNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetChallengeValidChallenge() {
        let expectation = expectation(description: "getChallenge")
        Task {
            let result = await relayAuth.getChallenge()
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetAttestationKeyIdNil() {
        let expectation = expectation(description: "getAttestation")
        Task {
            do {
                let (encodedString, challenge) = try await relayAuth.getAttestation(customKeyId: nil)
                XCTAssertNil(encodedString)
                XCTAssertNil(challenge)
            } catch {
                XCTFail("Error occurred: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetAttestationChallengeError() {
        let expectation = expectation(description: "getAttestation")
        Task {
            do {
                try await relayAuth.setup()
                _ = try await relayAuth.getAttestation(false, customBaseUrlInput: "test")
                
                // If no error is thrown, fail the test
                XCTFail("Expected error but got success")
            } catch let error as NSError {
                XCTAssertEqual(error.code, -2)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetAttestationAttestKeyError() {
        let expectation = expectation(description: "getAttestation")
        Task {
            do {
                try await relayAuth.setup()
                let result = try await relayAuth.getAttestation(false, attestationDataErrorCode: 1)
                XCTAssertNotNil(result)
            } catch {
                XCTFail("Unexpected error occurred: \(error.localizedDescription)")
            }
            expectation.fulfill()
            }
            waitForExpectations(timeout: 5.0) { error in
                if let error = error {
                    XCTFail("Expectation failed with error: \(error.localizedDescription)")
                }
            }
        }

}


