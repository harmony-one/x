import XCTest
import Combine
@testable import Voice_AI

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
    
    func testGetterMethods() {
        XCTAssertNotNil(appConfig.getOpenAIKey(), "OpenAIKey should not be nil")
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
            Thread.sleep(forTimeInterval: 4)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error.localizedDescription)")
            }
        }
    }
    
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

}


