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
    
    func testPresentationAnchor() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])

        // AppleSignInManager.shared.presentationAnchor(for: controller)
    }
    
    func testPerformAppleSignIn() {
        appleSignInManager.performAppleSignIn(using: mockWindow)
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
