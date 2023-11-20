//
//  UserApiTests.swift
//  Voice AITests
//
//  Created by Francisco Egloff on 20/11/23.
//

import XCTest
import SwiftUI
@testable import Voice_AI

class UserAPITests: XCTestCase {
    var keychainService: KeychainService!
    var api: UserAPI!
    
    override func setUp() {
        super.setUp()
        api = UserAPI()
        keychainService = KeychainService.shared
    }
    
    override func tearDown() {
        keychainService.clearAll()
        api = nil
        super.tearDown()
    }
    
    func testRegister() {

        let appleId = "testAppleId"
        let fullName = "John Doe"
        let email = "john@example.com"
        keychainService.storeUserCredentials(appleId: appleId, fullName: fullName, email: email)

        api.register(appleId: appleId)
        
        let isAvailable = self.keychainService.isAppleIdAvailable()
        XCTAssertTrue(isAvailable, "The correct data is stored in KeychainService")

    }
    
    func testGetUserBy() {
        // Given
        let api = UserAPI()
        let appleId = "testAppleId"
        
        // When
        api.getUserBy(appleId: appleId)
//        print(**************** \(user))
        // Then
        // Assert that the network request is made correctly
        // Assert that the correct data is stored in KeychainService
    }
    
    func testPurchase() {
        // Given
        let api = UserAPI()
        let transactionId = "testTransactionId"
        
        // When
        api.purchase(transactionId: transactionId)
        
        // Then
        // Assert that the network request is made correctly
        // Assert that the correct data is stored in KeychainService

    }
    
}
