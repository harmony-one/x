//import XCTest
//@testable import Voice_AI
//
//class CustomInstructionsHandlerTests: XCTestCase {
//
//    var customInstructionsHandler: CustomInstructionsHandler!
//    let userDefaults = UserDefaults.standard
//
//    override func setUp() {
//        super.setUp()
//        customInstructionsHandler = CustomInstructionsHandler()
//        userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//    }
//
//    override func tearDown() {
//        customInstructionsHandler = nil
//        userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//        super.tearDown()
//    }
//
//    func testStoreActiveContextWithDefaultText() {
//        customInstructionsHandler.storeActiveContext("Default")
//        let activeContext = userDefaults.string(forKey: CustomInstructionsHandler.Constants.activeContextKey)
//        let activeText = userDefaults.string(forKey: CustomInstructionsHandler.Constants.activeTextKey)
//
//        XCTAssertEqual(activeContext, "Default")
//        XCTAssertEqual(activeText, CustomInstructionsHandler.Constants.contextTexts["Default"])
//    }
//
//    func testStoreActiveContextWithCustomText() {
//        customInstructionsHandler.storeActiveContext("Custom", withText: "Custom Text")
//        let activeContext = userDefaults.string(forKey: CustomInstructionsHandler.Constants.activeContextKey)
//        let activeText = userDefaults.string(forKey: CustomInstructionsHandler.Constants.activeTextKey)
//
//        XCTAssertEqual(activeContext, "Custom")
//        XCTAssertEqual(activeText, "Custom Text")
//    }
//
//    func testRetrieveActiveContext() {
//        userDefaults.set("Quick Facts", forKey: CustomInstructionsHandler.Constants.activeContextKey)
//        let retrievedContext = customInstructionsHandler.retrieveActiveContext()
//
//        XCTAssertEqual(retrievedContext, "Quick Facts")
//    }
//
//    func testRetrieveActiveTextWithCustomText() {
//        userDefaults.set("Custom", forKey: CustomInstructionsHandler.Constants.activeContextKey)
//        userDefaults.set("Custom Text", forKey: CustomInstructionsHandler.Constants.activeTextKey)
//        let retrievedText = customInstructionsHandler.retrieveActiveText()
//
//        XCTAssertEqual(retrievedText, "Custom Text")
//    }
//
//    func testRetrieveActiveTextWithDefaultText() {
//        userDefaults.set("Default", forKey: CustomInstructionsHandler.Constants.activeContextKey)
//        let retrievedText = customInstructionsHandler.retrieveActiveText()
//
//        XCTAssertEqual(retrievedText, CustomInstructionsHandler.Constants.contextTexts["Default"])
//    }
//
//    func testGetOptions() {
//        let options = customInstructionsHandler.getOptions()
//        XCTAssertEqual(options, CustomInstructionsHandler.Constants.options)
//    }
//
//    func testSaveCustomText() {
//        customInstructionsHandler.saveCustomText("Test Custom Text")
//        let savedText = userDefaults.string(forKey: "customText")
//
//        XCTAssertEqual(savedText, "Test Custom Text")
//    }
//}
