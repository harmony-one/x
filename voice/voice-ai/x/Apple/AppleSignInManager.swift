import AuthenticationServices
import SwiftUI

class AppleSignInManager: NSObject {
    static let shared = AppleSignInManager()
    private weak var currentWindow: UIWindow?

    @EnvironmentObject var store: Store

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
            UserAPI().register(appleId: appleId)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            if let error = error as? ASAuthorizationError {
                switch error.code {
                case .canceled:
                    // Handle the cancellation here
                    print("[AppleSignInManager] User cancelled the Apple Sign-In")
                    
                    Task {
                        if store.products.isEmpty {
                            print("[AppleSignInManager] No products available")
                        } else {
                            let product = store.products[0]
                            do {
                                try await self.store.purchase(product)
                            } catch {
                                print("[AppleSignInManager] Error during purchase")
                            }
                        }
                    }
                    
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
            fatalError("Window not set for Apple Sign In")
        }
        return window
    }
}
