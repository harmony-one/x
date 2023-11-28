import XCTest
import SwiftUI
@testable import Voice_AI
import ViewInspector

class AppSettingsTests: XCTestCase {
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

class SettingsViewTests: XCTestCase {
    var settingsView: SettingsView!
    var appSettings: AppSettings!
    var store: Store!
    
    override func setUp() {
        super.setUp()
        store = Store()
        appSettings = AppSettings.shared
        settingsView = SettingsView()
    }
    
    override func tearDown() {
        settingsView = nil
        super.tearDown()
    }
    
    func testExists() {
        XCTAssertNotNil(settingsView)
    }
    
    func testShare() {
        let view = SettingsView().environmentObject(self.appSettings).environmentObject(store)
        ViewHosting.host(view: view)
        
        do {
            let actualView = try view.inspect()
                .find(SettingsView.self)
                .actualView()
            let button = try view.inspect().find(button: "Share")
            XCTAssertNotNil(button)
        } catch {
            print("Error: \(error)")
        }
    }
}
