import XCTest
@testable import Voice_AI
import Mixpanel

class AppSettingsTests: XCTestCase {
    var appSettings: AppSettings!
       
   override func setUp() {
       super.setUp()
//       appSettings = AppSettings()
   }

   override func tearDown() {
       appSettings = nil
       UserDefaults.standard.removeObject(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomMode)
       super.tearDown()
   }
    
    func testShowSettings() {
        let appSettings = AppSettings()
        appSettings.showSettings(isOpened: true)
        XCTAssertTrue(appSettings.isOpened)
    
        appSettings.showSettings(isOpened: false)
        XCTAssertFalse(appSettings.isOpened)
    }
    
    func testShowActionSheet() {
        let appSettings = AppSettings()
        appSettings.showActionSheet(type: .settings, deviceType: .pad)
        XCTAssertTrue(appSettings.isPopoverPresented)
        appSettings.showActionSheet(type: .settings, deviceType: .phone)
        XCTAssertTrue(appSettings.isOpened)
    }
    
//    func testLoadSettingsQuickFacts() {
//        UserDefaults.standard.set("mode_quick_facts", forKey: SettingsBundleHelper.SettingsBundleKeys.CustomMode)
//        let appSettings = AppSettings()
//        appSettings.premiumUseExpires = "quickFacts"
//        XCTAssertEqual(appSettings.customInstructions, String(localized: "customInstruction.quickFacts"))
//    }
//    
//    func testLoadSettingsInteractiveTutor() {
//        UserDefaults.standard.set("mode_interactive_tutor", forKey: SettingsBundleHelper.SettingsBundleKeys.CustomMode)
//        print("[testinteractive]: \(UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomMode))")
//        let appSettings = AppSettings()
//        appSettings.premiumUseExpires = "tutor"
//        XCTAssertEqual(appSettings.customInstructions, String(localized: "customInstruction.interactiveTutor"))
//    }
    
    func testLoadSettingsDefault() {
        UserDefaults.standard.set("custom_mode", forKey: SettingsBundleHelper.SettingsBundleKeys.CustomMode)
        print("[testCustom]: \(UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomMode))")
        let appSettings = AppSettings()
        appSettings.premiumUseExpires = "default"
        XCTAssertEqual(appSettings.customInstructions, String(localized: "customInstruction.default"))
    }
    
    func testUpdateUserDefaultsIfNeeded() {
        let appSettings = AppSettings()
        UserDefaults.standard.set("premiumBefore", forKey: "EXPIRE_AT")
        print("[testDefault]: \(UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.CustomMode))")
        appSettings.premiumUseExpires = "premiumAfter"
        XCTAssertEqual(UserDefaults.standard.string(forKey: "EXPIRE_AT"), "premiumAfter")
    }
    
    func testGetEpochWithValidDateString() {
        let dateString = "2023-12-14T22:15:00.000Z"
        let epoch = AppSettings.getEpoch(dateString: dateString)
        XCTAssertNotNil(epoch)
    }

    func testGetEpochWithInvalidDateString() {
        let dateString = "InvalidDate"
        let epoch = AppSettings.getEpoch(dateString: dateString)
        XCTAssertNil(epoch)
    }

    func testGetEpochWithNilDateString() {
        let epoch = AppSettings.getEpoch(dateString: nil)
        XCTAssertNil(epoch)
    }

    func testIsDateStringInFutureWithValidDateString() {
        let dateString = "2024-01-01T00:00:00.000Z"
        XCTAssertTrue(AppSettings.isDateStringInFuture(dateString))
    }

    func testIsDateStringInFutureWithPastDateString() {
        let dateString = "2022-01-01T00:00:00.000Z"
        XCTAssertFalse(AppSettings.isDateStringInFuture(dateString))
    }

    func testIsDateStringInFutureWithInvalidDateString() {
        let dateString = "InvalidDate"
        XCTAssertFalse(AppSettings.isDateStringInFuture(dateString))
    }
    
}

class MixpanelManagerTests: XCTestCase {
    var mixpanelManager: MixpanelManager!
        
    override func setUp() {
        super.setUp()
        mixpanelManager = MixpanelManager.shared
    }

    override func tearDown() {
        mixpanelManager = nil
        super.tearDown()
    }
    
    func testTrackEvent() {
        let eventName = "Test Event"
        let eventProperties: [String: MixpanelType] = ["Key1": "Value1", "Key2": 42]

        let expectation = XCTestExpectation(description: "Event tracking completed")
        mixpanelManager.trackEvent(name: eventName, properties: eventProperties)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        let lastTrackedEvent = mixpanelManager.getLastTrackedEvent()
        XCTAssertEqual(lastTrackedEvent, eventName)
    }
}

