# x.country

# Voice-AI Testing Guide
Getting Started
To test your Voice-AI project, follow these steps:

#1. Organize Test Files
Organize your test files in a folder named "xTests" within your project directory. This is where your test-related files will be located.

YourAppName/
|-- YourAppName.xcodeproj
|-- YourAppName/
|   |-- ... (source code files)
|-- xTests/
|   |-- ActionHandlerTests.swift
|   |-- ...
|-- ...


#2. Import Necessary Modules
In your test files, ensure you import the required modules:

import XCTest
@testable import YourAppName // Replace with your app's module name

#3. Write Tests
Create unit tests for your ActionHandler class. Here's an example:

import XCTest
@testable import Voice_AI

final class ActionHandlerTests: XCTestCase {
    var actionHandler: ActionHandler!
    var mockSpeechRecognition: MockSpeechRecognition!
    
    override func setUpWithError() throws {
        mockSpeechRecognition = MockSpeechRecognition()
        actionHandler = ActionHandler(speechRecognition: mockSpeechRecognition)
    }
    
    override func tearDownWithError() throws {
        actionHandler = nil
    }
    
    // Test if random fact action calls the randomFacts() method in our mock
    func testHandleRandomFact() {
        actionHandler.handle(actionType: .randomFact)
        XCTAssertTrue(mockSpeechRecognition.randomFactsCalled)
    }
    
    // Test if repeatLast action calls the repeat() method in our mock
    func testHandleRepeatLast() {
        actionHandler.handle(actionType: .repeatLast)
        XCTAssertTrue(mockSpeechRecognition.repeatCalled)
    }
}
#4. Run Tests
To run your tests, select "Product" from the Xcode menu, then choose "Test" (or use Cmd+U). This will execute your tests.

#5. View Test Results
The Test Navigator will display test results. Green checkmarks indicate passing tests, while red "X" marks indicate failures. Click on a test case for details.

#6. Refine and Iterate
Review and update your code if tests fail. Re-run tests to ensure everything passes.

#Note: Run tests on a physical device for faster performance compared to the simulator.

--- 

#Sandbox Testing Guide for In-App Purchases
#Introduction
Sandbox testing allows you to simulate in-app purchases in your iOS app without making actual charges. This guide will help you test the purchase flow using a Store class, which handles product requests, transactions, and restoration of purchases.

#Prerequisites
- Access to App Store Connect.
- An iOS device for testing (sandbox testing can't be done on simulators).
- The Store class implemented for handling in-app purchases.

#Step 1: Set Up Sandbox Tester Accounts
- Log in to App Store Connect.
- Navigate to Users and Access > Sandbox Testers.
- Create new tester accounts with unique email addresses.

#Step 2: Configure In-App Purchases in App Store Connect
- Go to the Features tab and select In-App Purchases.
- Set up your in-app purchase items with unique identifiers.

#Step 3: Run the App on a Real Device: 
- Build and run your app from Xcode on a real iOS device.

#Step 4: Sign Out of Regular Apple ID: 
- On your device, sign out of the regular Apple ID (in the App Store and iTunes Store).

#Step 5: Sign In with a Sandbox Tester Account:
- When prompted for a sign-in within your app (e.g., when initiating a purchase), use a sandbox tester account. 
