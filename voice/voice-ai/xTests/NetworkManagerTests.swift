import XCTest
@testable import Voice_AI

class APIEnvironmentTests: XCTestCase {

    var keychainService: KeychainService!

    override func setUp() {
        super.setUp()
        keychainService = KeychainService.shared
    }

    override func tearDown() {
        super.tearDown()
        keychainService.clearAll()
    }

    func testGetBaseURLDefault() {
        let basePath = APIEnvironment.getBaseURL()
        if AppConfig.shared.getPaymentMode() == "production" {
            XCTAssertEqual(basePath, "https://x-payments-api.fly.dev/")
        } else {
            XCTAssertEqual(basePath, "https://x-payments-api-sandbox.fly.dev/")
        }
    }
    
    func testGetBaseURLUnrecognized() {
        let basePath = APIEnvironment.getBaseURL(paymentMode: "unrecognized")
        XCTAssertEqual(basePath, "https://x-payments-api-sandbox.fly.dev/")
    }
    
    func testGetBaseURLSandbox() {
        let basePath = APIEnvironment.getBaseURL(paymentMode: "sandbox")
        XCTAssertEqual(basePath, "https://x-payments-api-sandbox.fly.dev/")
    }
    
    func testGetBaseURLProduction() {
        let basePath = APIEnvironment.getBaseURL(paymentMode: "production")
        XCTAssertEqual(basePath, "https://x-payments-api.fly.dev/")
    }
    
    func testGetUser() {
        let user = User(id: "123")
        keychainService.storeUser(user: user)

        let userPath = APIEnvironment.getUser()
        XCTAssertEqual(userPath, "users/123")
    }
    
    func testGetUserEmpty() {
        keychainService.deleteUserCredentials()

        let userPath = APIEnvironment.getUser()
        XCTAssertEqual(userPath, "")
    }

    func testPurchase() {
        let user = User(id: "456")
        keychainService.storeUser(user: user)

        let purchasePath = APIEnvironment.purchase()
        XCTAssertEqual(purchasePath, "users/456/purchase")
    }
    
    func testPurchaseEmpty() {
        keychainService.deleteUserCredentials()

        let purchasePath = APIEnvironment.purchase()
        XCTAssertEqual(purchasePath, "")
    }

    func testGetUserByAppleID() {
        let appleID = "testAppleID"
        let userPath = APIEnvironment.getUser(byAppleID: appleID)
        XCTAssertEqual(userPath, "users/appleId/\(appleID)")
    }
    
    func testUpdateUser() {
        let user = User(id: "456")
        keychainService.storeUser(user: user)

        let purchasePath = APIEnvironment.updateUser()
        XCTAssertEqual(purchasePath, "users/456/update")
    }
    
    func testUpdateUserEmpty() {
        keychainService.deleteUserCredentials()

        let purchasePath = APIEnvironment.updateUser()
        XCTAssertEqual(purchasePath, "")
    }
}

class NetworkManagerTests: XCTestCase {
    
    func testSetAuthorizationHeader() {
        let newtworkManager = NetworkManager.shared
        let url = URL(string: "https://x.country")!
        var request = URLRequest(url: url)
        
        newtworkManager.setAuthorizationHeader(token: "XTOKEN", request: &request)
        
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer XTOKEN")
    }
    
    func testSetCustomHeader() {
        let newtworkManager = NetworkManager.shared
        let url = URL(string: "https://x.country")!
        var request = URLRequest(url: url)
        
        newtworkManager.setCustomHeader(field: "X-Header", value: "x-header-value", request: &request)
        
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Header"), "x-header-value")
    }
    
    func testInvalidResponse() {
        let expectation = XCTestExpectation(description: "Completion handler should be called")
        
        NetworkManager.shared.requestData(from: "/some/random/endpoint", method: .get, customHeaders: ["x-header": "x-value"]) { (result: Result<NetworkResponse<User>, NetworkError>) in
            
            switch result {
            case .failure(let error):
                switch (error) {
                case .responseError(_):
                    expectation.fulfill()
                    break
                case (.requestFailed):
                    break
                case .badURL:
                    break
                case .dataParsingError(_):
                    break
                case .unknown:
                    break
                }
                
                break
            case .success(_):
                break
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
