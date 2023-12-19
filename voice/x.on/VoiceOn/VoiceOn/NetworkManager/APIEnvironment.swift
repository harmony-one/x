enum APIEnvironment {
    
    private static let sandboxBaseURL = "https://x-payments-api-sandbox.fly.dev/"
    private static let productionBaseURL = "https://x-payments-api.fly.dev/"

    static func getBaseURL(paymentMode: String? = nil) -> String {
        let selectedPaymentMode = paymentMode
        switch selectedPaymentMode {
        case "sandbox":
            return sandboxBaseURL
        case "production":
            return productionBaseURL
        default:
            return sandboxBaseURL // Default to sandbox if paymentMode is not set or unrecognized
        }
    }
}
