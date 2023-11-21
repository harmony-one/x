import AuthenticationServices
import SwiftUI

class AppleSignInManager: NSObject {
    static let shared = AppleSignInManager()
    private weak var currentWindow: UIWindow?
    internal var isShowIAPFromSignIn = false
    @EnvironmentObject var store: Store

    private override init() {}

    func performAppleSignIn(using window: UIWindow) {
        DispatchQueue.main.async {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            self.currentWindow = window
            controller.performRequests()
        }
    }
}

extension AppleSignInManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Handle successful authorization
            
            // Process user details and authentication token
            let appleId = appleIDCredential.user
            let fullName = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName].compactMap { $0 }.joined(separator: " ")
            let email = appleIDCredential.email
            
            KeychainService.shared.storeUserCredentials(appleId: appleId, fullName: fullName, email: email)
            UserAPI().register(appleId: appleId)
            isShowIAPFromSignIn = true
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            if let error = error as? ASAuthorizationError {
                switch error.code {
                case .canceled:
                    // Handle the cancellation here
                    print("[AppleSignInManager] User cancelled the Apple Sign-In")
                    isShowIAPFromSignIn = true
                default:
                    // Handle other errors
                    print("Apple Sign-In error: \(error.localizedDescription)")
                }
            }
        }
}

extension AppleSignInManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = currentWindow else {
            isShowIAPFromSignIn = false
            fatalError("Window not set for Apple Sign In")
        }
        return window
    }
}
