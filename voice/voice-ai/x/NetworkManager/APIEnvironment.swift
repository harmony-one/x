enum APIEnvironment {
    
    private static let sandboxBaseURL = "https://x-payments-api-sandbox.fly.dev/"
    private static let productionBaseURL = "https://x-payments-api.fly.dev/"

    static var baseURL: String {
        switch AppConfig.shared.getPaymentMode() {
        case "sandbox":
            return sandboxBaseURL
        case "production":
            return productionBaseURL
        default:
            return sandboxBaseURL // Default to sandbox if paymentMode is not set or unrecognized
        }
    }
    
//    static let baseURL = "https://x-payments-api-sandbox.fly.dev/" // Sandbox
    //  static let baseURL = "https://x-payments-api.fly.dev/" // Production
    
    static let createUser = "users/create"
    
    static func getUser() -> String {
        guard let userid = KeychainService.shared.retrieveUserid() else {
            return ""
        }
        return "users/\(userid)"
    }
    
    static func purchase() -> String {
        guard let userid = KeychainService.shared.retrieveUserid() else {
            return ""
        }
        return "users/\(userid)/purchase"
    }
    
    static func getUser(byAppleID id: String) -> String {
        return "users/appleId/\(id)"
    }
    
    static func updateUser() -> String {
        guard let userid = KeychainService.shared.retrieveUserid() else {
            return ""
        }
        return "users/\(userid)/update"
    }
}
