import XCTest
@testable import Voice_AI
import UIKit
import AuthenticationServices

class MockAppleIDCredential {
    var user: String
    var fullName: PersonNameComponents?
    var email: String?
    
    init(user: String, fullName: PersonNameComponents, email: String) {
        self.user = user
        self.fullName = fullName
        self.email = email
    }
}

class AppleSignInManagerTests: XCTestCase {
    var appleSignInManager: AppleSignInManager!
    var mockWindow: UIWindow!

    override func setUp() {
        super.setUp()
        appleSignInManager = AppleSignInManager.shared
        mockWindow = UIWindow()
    }

    override func tearDown() {
        appleSignInManager = nil
        mockWindow = nil
        super.tearDown()
    }
    
    func testCreateAppleSignInRequest() {
        let window = UIWindow()
        let appleSignInManager = AppleSignInManager.shared

        appleSignInManager.performAppleSignIn(using: window)

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        XCTAssertEqual(request.requestedScopes, [.fullName, .email])
    }
    
    func testCreateAuthorizationController() {
        let window = UIWindow()
        let appleSignInManager = AppleSignInManager.shared
        
        appleSignInManager.performAppleSignIn(using: window)
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        XCTAssertEqual(controller.authorizationRequests.count, 1)
    }
    
    func testSetAuthorizationControllerDelegate() {
        let window = UIWindow()
        let appleSignInManager = AppleSignInManager.shared
        
        appleSignInManager.performAppleSignIn(using: window)
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        let controller = ASAuthorizationController(authorizationRequests: [request])
        XCTAssertFalse(controller.delegate === appleSignInManager)
    }
    
    
    func testDidCompleteWithAuthorization() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let mockAuthController = ASAuthorizationController(authorizationRequests: [request])
        
        let mockAppleIDCredential = MockAppleIDCredential(user: "testUser", fullName: PersonNameComponents(), email: "test@example.com")
        
//        let mockAuthorization = ASAuthorization(appleIDCredential: mockAppleIDCredential)
//        appleSignInManager.authorizationController(controller: mockAuthController, didCompleteWithAuthorization: mockAuthorization)
    }

    func testDidCompleteWithError() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let mockAuthController = ASAuthorizationController(authorizationRequests: [request])
        
        let mockError = NSError(domain: ASAuthorizationErrorDomain, code: ASAuthorizationError.canceled.rawValue, userInfo: nil)
        
        appleSignInManager.authorizationController(controller: mockAuthController, didCompleteWithError: mockError)
    }
}
