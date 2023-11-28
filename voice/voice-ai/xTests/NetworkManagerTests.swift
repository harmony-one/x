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

    func testGetUser() {
        keychainService.storeUser(id: "123", balance: nil, createdAt: nil, updatedAt: nil, expirationDate: nil, isSubscriptionActive: nil)

        let userPath = APIEnvironment.getUser()
        XCTAssertEqual(userPath, "users/123")
    }

    func testPurchase() {
        keychainService.storeUser(id: "456", balance: nil, createdAt: nil, updatedAt: nil, expirationDate: nil, isSubscriptionActive: nil)

        let purchasePath = APIEnvironment.purchase()
        XCTAssertEqual(purchasePath, "users/456/purchase")
    }

    func testGetUserByAppleID() {
        let appleID = "testAppleID"
        let userPath = APIEnvironment.getUser(byAppleID: appleID)
        XCTAssertEqual(userPath, "users/appleId/\(appleID)")
    }

    func testGetUserEmpty() {
        keychainService.deleteUserCredentials()

        let userPath = APIEnvironment.getUser()
        XCTAssertEqual(userPath, "")
    }

    func testPurchaseEmpty() {
        keychainService.deleteUserCredentials()

        let purchasePath = APIEnvironment.purchase()
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
    
    func testInvalidResponse() {
        let expectation = XCTestExpectation(description: "Completion handler should be called")
        
        NetworkManager.shared.requestData(from: "/some/random/endpoint", method: .get) { (result: Result<NetworkResponse<User>, NetworkError>) in
            
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
