//
//  ActionViewTests.swift
//  Voice AITests
//
//  Created by Francisco Egloff on 16/11/23.
//

import XCTest
import Foundation
import StoreKit
import SwiftUI
import AudioToolbox
import CoreHaptics
import UIKit
import Combine
import KeychainSwift

extension ActionsView {
    
}

struct MockActionsView: ActionsViewProtocol {
    // Define any properties or methods you want to mock
    
    func calculateGridProperties(colums: Int, buttons: [ButtonData]) -> (columns: [GridItem], height: CGFloat) {
        let gridItem = GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0)
        let columns = Array(repeating: gridItem, count: colums)
        let numOfRows: Int = .init(ceil(Double(buttons.count) / Double(colums)))
        let height = 10 / CGFloat(numOfRows)
        return (columns, height)
    }
    
    func baseView(colums: Int, buttons: [ButtonData]) -> AnyView {
        return  AnyView(EmptyView())// EmptyView() as AnyView
    }
    
}

class ActionViewTests: XCTestCase {
    var actionView: ActionsView = ActionsView()
    
    func testThemeChange() {
        XCTAssertTrue(actionView.currentTheme.name == "blackredTheme")
        actionView.changeTheme(name: "defaultTheme")
        XCTAssertTrue(actionView.currentTheme.name == "defaultTheme")
    }
    
    func testBaseView() {
        let mockView = MockActionsView()
        
        let column = 3
        let buttons = actionView.buttonsPortrait
        let gridProperties = mockView.calculateGridProperties(colums: column, buttons: buttons)
        XCTAssertTrue(gridProperties.height == 5.0, "baseView() should create a grid (height")
        XCTAssertTrue(gridProperties.columns.count == 3, "baseView() should create a grid (columns)")
    }

    func testCheckUserAuthentication_UserAvailable() {
        // Arrange
        let keychainService = KeychainService.shared
        keychainService.storeUserCredentials(appleId: "testAppleId", fullName: nil, email: nil)
        
        // Act
        let isUserAvailable = keychainService.isAppleIdAvailable()
        
        // Assert
        XCTAssertTrue(isUserAvailable, "User ID is available, should showPurchaseDialog()")
    }
    
    func testCheckUserAuthentication_UserUnavailable() {
        // Arrange
        let keychainService = KeychainService.shared
        keychainService.storeUserCredentials(appleId: "", fullName: nil, email: nil)
        
        // Act
        let isUserAvailable = keychainService.isAppleIdAvailable()
        
        // Assert
        XCTAssertFalse(isUserAvailable, "User ID not found, prompt user to log in or register")
    }
}

    
    
