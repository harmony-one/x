
struct APIEnvironment {
    static let baseURL = "https://x-payments-api.fly.dev/"
    static let createUser = "users/create"
    
    
    static func getUser() -> String {
        guard let userid =  KeychainService.shared.retrieveUserid() else {
            return ""
        }
        return "users/\(userid)"
    }
    
    static func purchase() -> String {
        guard let userid =  KeychainService.shared.retrieveUserid() else {
            return ""
        }
        return "users/\(userid)/purchase"
    }
    
    static func getUser(byAppleID id: String) -> String {
        return "users/appleId/\(id)"
    }
}
