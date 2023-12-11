import XCTest
import SwiftUI
import OSLog

@testable import Voice_AI

class CreateUserTests: XCTestCase {

    func testUserDecoding() throws {
        let json = """
        {
            "id": "123",
            "deviceId": "device123",
            "appleId": "apple123",
            "balance": 100,
            "createdAt": "2023-11-20T12:00:00Z",
            "updatedAt": "2023-11-20T13:00:00Z",
            "expirationDate": "2023-11-30T23:59:59Z",
            "isSubscriptionActive": false,
            "appVersion": "1.0.0"
        }
        """.data(using: .utf8)!

        let user = try JSONDecoder().decode(User.self, from: json)

        XCTAssertEqual(user.id, "123")
        XCTAssertEqual(user.deviceId, "device123")
        XCTAssertEqual(user.appleId, "apple123")
        XCTAssertEqual(user.balance, 100)
        XCTAssertEqual(user.createdAt, "2023-11-20T12:00:00Z")
        XCTAssertEqual(user.updatedAt, "2023-11-20T13:00:00Z")
        XCTAssertEqual(user.expirationDate, "2023-11-30T23:59:59Z")
        XCTAssertEqual(user.isSubscriptionActive, false)
        XCTAssertEqual(user.appVersion, "1.0.0")
    }

    func testUserDecodingWithMissingFields() throws {
        let json = """
        {
            "id": "123",
            "deviceId": "device123"
        }
        """.data(using: .utf8)!
   
        let user = try JSONDecoder().decode(User.self, from: json)
 
        XCTAssertEqual(user.id, "123")
        XCTAssertEqual(user.deviceId, "device123")
        XCTAssertNil(user.appleId)
        XCTAssertNil(user.balance)
        XCTAssertNil(user.createdAt)
        XCTAssertNil(user.updatedAt)
        XCTAssertNil(user.expirationDate)
        XCTAssertNil(user.appVersion)
    }
    
    func testUserDecodingWithInvalidData() {
        let json = """
        {
            "id": "123",
            "balance": "invalid"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(User.self, from: json)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
}


class MockNetworkManager: NetworkManagerProtocol {
    var statusCode: Int = 200
    var responseData: Data?
    var error: Error?

    func setStatusCode(code: Int) {
        self.statusCode = code;
    }

    func setResponseData(responseData: String) {
        self.responseData = responseData.data(using: .utf8)
    }

    func createURL(endpoint: String, parameters: [String : String]?) -> URL? {
        return URLComponents(string: endpoint)?.url
    }

    func setAuthorizationHeader(token: String, request: inout URLRequest) {

    }

    func setCustomHeader(field: String, value: String, request: inout URLRequest) {

    }

    func requestData<T: Codable>(from endpoint: String, method: HTTPMethod, parameters: [String : String]?, body: Data?, token: String?, customHeaders: [String : String]?, completion: @escaping (Result<NetworkResponse<T>, NetworkError>) -> Void) where T : Decodable, T : Encodable {
        if let data = self.responseData {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                let response = NetworkResponse(statusCode: self.statusCode, data: decodedData)
                completion(.success(response))
                return
            } catch {
                completion(.failure(.dataParsingError(error)))
                return
            }
        }

        if let error = self.error {
            completion(.failure(.responseError(404)))
        }
    }
}

enum JsonSerializeError: Error {
    case invalidInput
    case emptyInput
}

func jsonSerialize(dictionary: Any) throws -> String {
    let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    guard let jsonString = String(data: jsonData, encoding: .utf8) else {
        throw JsonSerializeError.invalidInput
    }

    return jsonString
}


class UserAPITests: XCTestCase {
    var keychainService: KeychainService!
    var api: UserAPI!
 
    override func setUp() {
        super.setUp()
        api = UserAPI()
        keychainService = KeychainService.shared
    }
    
    override func tearDown() {
        keychainService.clearAll()
        api = nil
        super.tearDown()
    }
    
    func testRegister() {
        let appleId = "testAppleId"
        let fullName = "John Doe"
        let email = "john@example.com"
        keychainService.storeUserCredentials(appleId: appleId, fullName: fullName, email: email)

        api.register(appleId: appleId)
        
        let isAvailable = self.keychainService.isAppleIdAvailable()
        XCTAssertTrue(isAvailable, "The correct data is stored in KeychainService")
    }
    
    func testGetUserBy() {
        // Given
        let appleId = "testAppleId"
        let fullName = "John Doe"
        let email = "john@example.com"
        keychainService.storeUserCredentials(appleId: appleId, fullName: fullName, email: email)
        api.register(appleId: appleId)
        
        // When
        api.getUserBy(appleId: appleId)
        let storedUserID = KeychainService.shared.retrieveAppleID()
        
        // Then
        XCTAssertEqual(storedUserID, "testAppleId", "Stored user ID should match the mock user ID")
    }
    
    func testGetUserByID() {
        // Given
        let appleId = "testAppleId"
        let fullName = "John Doe"
        let email = "john@example.com"
        keychainService.storeUserCredentials(appleId: appleId, fullName: fullName, email: email)
        api.register(appleId: appleId)
        
        // When
        api.getUserByID()
        let storedUserID = KeychainService.shared.retrieveAppleID()
        
        // Then
        XCTAssertEqual(storedUserID, "testAppleId", "Stored user ID should match the mock user ID")
    }
    

    func getMockUser(completion: @escaping (Result<User, Error>) -> Void) {
        let json = """
        {
            "id": "123",
            "deviceId": "device123",
            "appleId": "apple123",
            "balance": 100,
            "createdAt": "2023-11-20T12:00:00Z",
            "updatedAt": "2023-11-20T13:00:00Z",
            "expirationDate": "2023-11-30T23:59:59Z",
            "isSubscriptionActive": false,
            "appVersion": "1.0.0"
        }
        """.data(using: .utf8)!

        do {
            let user = try JSONDecoder().decode(User.self, from: json)
            completion(.success(user))
        } catch {
            completion(.failure(error))
        }
    }

    func testIsSubscriptionActive() {
        // Given
        let appleId = "testId"
        let user = User(
            id: "123",
            deviceId: "device123",
            appleId: "apple123",
            balance: 100,
            createdAt: "2023-01-01",
            updatedAt: "2023-01-02",
            expirationDate: "2023-02-01",
            isSubscriptionActive: true,
            appVersion: "1.0.0",
            address: "123 Main Street"
        )
        
        self.keychainService.storeUser(user: user)
        self.api.register(appleId: appleId)

        // When
        self.api.getUserByID()
        let storedIsSubscriptionActive = KeychainService.shared.retrieveIsSubscriptionActive()

        // Then
        XCTAssertEqual(storedIsSubscriptionActive, false, "Should be inactive by default")
    }
    
    func testRegister_EncodesCreateUserBody() {
        let user = CreateUserBody(appleId: "1234567890", deviceId: "my-device-id")
        let encodedData = try? JSONEncoder().encode(user)
        XCTAssertNotNil(encodedData)
//        XCTAssertEqual(encodedData, "{\"appleId\":\"1234567890\",\"deviceId\":\"my-device-id\"}")
    }

    func testPurchase() {
        // Given
        let api = UserAPI()
        let transactionId = "testTransactionId"
        
        // When
        api.purchase(transactionId: transactionId)
        
        // Then
        // Assert that the network request is made correctly
        // Assert that the correct data is stored in KeychainService

    }
    
    func testGetDeviceID() {
        let deviceID = DeviceInfo.getDeviceID()
        print("****** \(deviceID)")
        XCTAssertNotNil(deviceID)
        XCTAssertNotEqual(deviceID, "Not available", "Device Info found")
        XCTAssertTrue(deviceID.count > 0)
    }
    
    func testGetUser() {
        let networkManager = MockNetworkManager()

        let dictionary: [String: Any] = [
            "id": "",
            "deviceId": "123",
            "appleId": "New York",
            "balance": 0,
            "createdAt": "Date",
            "updatedAt": "Date",
            "expirationDate": "date",
            "isSubscriptionActive": false,
            "appVersion": "1"
        ]

        do {
            let jsonString = try jsonSerialize(dictionary: dictionary)

            networkManager.setResponseData(responseData: jsonString)
            networkManager.setStatusCode(code: 200)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            
            let api = UserAPI(networkManager: networkManager)
            api.getUser(byType: "some") { result in
                switch result {
                case .success(_):
                    expectation.fulfill()
                    XCTAssert(true, "user has been loaded")
                case .failure(_):
                    XCTAssert(false)
                }
            }
            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false, "unexpected error")
        }

        do {
            let userWithoutID: [String: Any] = [
                "deviceId": "123",
                "appleId": "New York",
                "balance": 0,
                "createdAt": "Date",
                "updatedAt": "Date",
                "expirationDate": "date",
                "isSubscriptionActive": false,
                "appVersion": "1"
            ]
            let jsonString = try jsonSerialize(dictionary: userWithoutID)

            networkManager.setResponseData(responseData: jsonString)
            networkManager.setStatusCode(code: 200)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.getUser(byType: "some") { result in
                switch result {
                case .success(_):
                    XCTAssert(false)
                case .failure(_):
                    expectation.fulfill()
                    XCTAssert(true, "response has no user id")
                }
            }
            
            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false)
        }

        do {
            networkManager.setResponseData(responseData: "")
            networkManager.setStatusCode(code: 200)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            
            let api = UserAPI(networkManager: networkManager)
            api.getUser(byType: "some") { result in
                switch result {
                case .success(_):
                    
                    XCTAssert(false)
                case .failure(_):
                    expectation.fulfill()
                    XCTAssert(true, "parse data error")
                }
            }
            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false, "unexpected error")
        }

    }

    func testUpdateUser() {
        let networkManager = MockNetworkManager()

        let user: [String: Any] = [
            "id": "123",
            "deviceId": "123",
            "appleId": "New York",
            "balance": 0,
            "createdAt": "Date",
            "updatedAt": "Date",
            "expirationDate": "date",
            "isSubscriptionActive": false,
            "appVersion": "1"
        ]

        do {
            let jsonString = try jsonSerialize(dictionary: user)
            networkManager.setResponseData(responseData: jsonString)
            networkManager.setStatusCode(code: 200)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.updateUser(apiKey: "123", appVersion: "123") { result in
                switch result {
                case .success(_):
                    expectation.fulfill()
                    XCTAssert(true)
                case .failure(_):
                    XCTAssert(false)
                }
            }

            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false)
        }


        do {
            networkManager.setResponseData(responseData: "")
            networkManager.setStatusCode(code: 200)
            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.updateUser(apiKey: "123", appVersion: "123") { result in
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    XCTAssert(true, "parse error")
                    expectation.fulfill()
                }
            }
            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false)
        }
    }

    func testApiRegister() {
        do {
            let networkManager = MockNetworkManager()
            let user: [String: Any] = [
                "id": "x123",
                "deviceId": "123",
                "appleId": "someAppleId",
                "balance": 0,
                "createdAt": "Date",
                "updatedAt": "Date",
                "expirationDate": "date",
                "isSubscriptionActive": false,
                "appVersion": "1"
            ]
            let jsonString = try jsonSerialize(dictionary: user)

            networkManager.setResponseData(responseData: jsonString)
            networkManager.setStatusCode(code: 200)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.register(appleId: "someAppleId"){ result in
                switch result {
                case .success(_):
                    expectation.fulfill()
                    XCTAssertEqual(KeychainService.shared.retrieveUserid(), "x123")
                case .failure(_):
                    XCTAssert(false)
                }
            }
            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false)
        }
        
        do {
            let networkManager = MockNetworkManager()
            
            let user: [String: Any] = [
                "id": "x123",
                "deviceId": "123",
                "appleId": "someAppleId",
                "balance": 0,
                "createdAt": "Date",
                "updatedAt": "Date",
                "expirationDate": "date",
                "isSubscriptionActive": false,
                "appVersion": "1"
            ]
            let jsonString = try jsonSerialize(dictionary: user)
            networkManager.setResponseData(responseData: jsonString)
            networkManager.setStatusCode(code: 400)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.register(appleId: "someAppleId"){ result in
                switch result {
                case .success(_):
                    XCTAssert(false)
                case .failure(_):
                    expectation.fulfill()
                    XCTAssert(true, "User already created")
                }
            }
            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false)
        }
        
        do {
            let networkManager = MockNetworkManager()
            
            let user: [String: Any] = [
                "deviceId": "123",
                "appleId": "someAppleId",
                "balance": 0,
                "createdAt": "Date",
                "updatedAt": "Date",
                "expirationDate": "date",
                "isSubscriptionActive": false,
                "appVersion": "1"
            ]
            let jsonString = try jsonSerialize(dictionary: user)
            networkManager.setResponseData(responseData: jsonString)
            networkManager.setStatusCode(code: 200)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.register(appleId: "someAppleId"){ result in
                switch result {
                case .success(_):
                    XCTAssert(false)
                case .failure(_):
                    expectation.fulfill()
                    XCTAssert(true, "user has no id")
                }
            }
            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false)
        }
        
        do {
            let networkManager = MockNetworkManager()
            
            networkManager.setResponseData(responseData: "")
            networkManager.setStatusCode(code: 200)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.register(appleId: "someAppleId"){ result in
                switch result {
                case .success(_):
                    XCTAssert(false)
                case .failure(_):
                    expectation.fulfill()
                    XCTAssert(true, "parse data error")
                }
            }
            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testDeleteUserAccount() {
        do {
            let networkManager = MockNetworkManager()

            let user: [String: Any] = [
                "id": "123",
            ]
            let jsonString = try jsonSerialize(dictionary: user)
            networkManager.setResponseData(responseData: jsonString)
            networkManager.setStatusCode(code: 200)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.deleteUserAccount(apiKey: "123") { result in
                expectation.fulfill()
                XCTAssert(result, "user has been deleted")
            }

            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false, "unexpected error")
        }
        
        do {
            let networkManager = MockNetworkManager()

            let user: [String: Any] = [
                "id": "123",
            ]
            let jsonString = try jsonSerialize(dictionary: user)
            networkManager.setResponseData(responseData: jsonString)
            networkManager.setStatusCode(code: 404)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.deleteUserAccount(apiKey: "123") { result in
                expectation.fulfill()
                XCTAssertFalse(result, "user not found")
            }

            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false, "unexpected error")
        }
        
        do {
            let networkManager = MockNetworkManager()
            networkManager.setResponseData(responseData: "")
            networkManager.setStatusCode(code: 404)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.deleteUserAccount(apiKey: "123") { result in
                expectation.fulfill()
                XCTAssertFalse(result, "parse data error")
            }

            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false, "unexpected error")
        }
    }
    
    func testApiPurchase() {
        do {
            let networkManager = MockNetworkManager()
            let user: [String: Any] = [
                "id": "x123",
                "deviceId": "123",
                "appleId": "someAppleId",
                "balance": 0,
                "createdAt": "Date",
                "updatedAt": "Date",
                "expirationDate": "date",
                "isSubscriptionActive": false,
                "appVersion": "1"
            ]
            let jsonString = try jsonSerialize(dictionary: user)

            networkManager.setResponseData(responseData: jsonString)
            networkManager.setStatusCode(code: 200)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.purchase(transactionId: "0x01"){ result in
                switch result {
                case .success(_):
                    expectation.fulfill()
                    XCTAssert(true, "successful purchase")
                case .failure(_):
                    XCTAssert(false)
                }
            }
            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false, "unexpected error")
        }
        
        do {
            let networkManager = MockNetworkManager()
            networkManager.setResponseData(responseData: "")
            networkManager.setStatusCode(code: 200)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.purchase(transactionId: "0x01") { result in
                switch result {
                case .success(_):
                    XCTAssert(false)
                case .failure(_):
                    expectation.fulfill()
                    XCTAssert(true, "parse data error")
                }
            }
            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false)
        }
        
        do {
            let networkManager = MockNetworkManager()
            
            let user: [String: Any] = [
                "deviceId": "123",
                "appleId": "someAppleId",
                "balance": 0,
                "createdAt": "Date",
                "updatedAt": "Date",
                "expirationDate": "date",
                "isSubscriptionActive": false,
                "appVersion": "1"
            ]
            let jsonString = try jsonSerialize(dictionary: user)
            networkManager.setResponseData(responseData: jsonString)
            networkManager.setStatusCode(code: 200)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.purchase(transactionId: "0x01"){ result in
                switch result {
                case .success(_):
                    XCTAssert(false)
                case .failure(_):
                    expectation.fulfill()
                    XCTAssert(true, "purchase not created")
                }
            }
            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false)
        }
        
        do {
            let networkManager = MockNetworkManager()
            
            networkManager.setResponseData(responseData: "")
            networkManager.setStatusCode(code: 200)

            let expectation = XCTestExpectation(description: "Completion handler should be called")
            let api = UserAPI(networkManager: networkManager)
            api.register(appleId: "someAppleId"){ result in
                switch result {
                case .success(_):
                    XCTAssert(false)
                case .failure(_):
                    expectation.fulfill()
                    XCTAssert(true, "parse data error")
                }
            }
            wait(for: [expectation], timeout: 1)
        } catch {
            XCTAssert(false)
        }
    }
    
}

