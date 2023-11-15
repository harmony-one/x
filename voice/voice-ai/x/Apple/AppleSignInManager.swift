import AuthenticationServices
import SwiftUI

class AppleSignInManager: NSObject {
    static let shared = AppleSignInManager()
    private weak var currentWindow: UIWindow?


    private override init() {}

    func performAppleSignIn(using window: UIWindow) {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            self.currentWindow = window
            controller.performRequests()
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
            
            //TODO:
            
           // UserAPI().getUserBy(id: appleId + "1212121")

            UserAPI().getUserBy(appleId:  "dfdfaeee1212121")

            // Proceed with further user handling
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error
    }
}

extension AppleSignInManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = currentWindow else {
            fatalError("Window not set for Apple Sign In")
        }
        return window
    }
}
