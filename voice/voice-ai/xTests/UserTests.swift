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
    
    
//    func test_register_user_with_valid_data() {
//        // Mock the necessary dependencies
//        let networkManagerMock = MockNetworkManager()
//        let keychainServiceMock = KeychainService.shared
//        let loggerMock = Logger(
//            subsystem: Bundle.main.bundleIdentifier!,
//            category: String(describing: "[UserTest]")
//        ) // Mock()
//        
//        // Create an instance of the code under test with the mocked dependencies
//        var userAPI = UserAPI(logger: loggerMock)
//        userAPI.networkManager =  networkManagerMock
//        userAPI.keychainService = keychainServiceMock
//        
//        // Set up the mock responses for the network manager
//        from;: <#Decoder#>, 
//        
//        // Call the method under test
//        userAPI.register(appleId: "testAppleId")
//        
//        // Assert that the necessary methods were called
//        XCTAssertTrue(networkManagerMock.requestDataCalled)
//        XCTAssertTrue(keychainServiceMock.storeUserCalled)
//        XCTAssertTrue(loggerMock.logCalled)
//    }
    
    func testRegisterSuccess() {
        // Create an instance of UserAPI with mock dependencies
        var userAPI = UserAPI()
//        userAPI.networkManager = MockNetworkManager()
//        userAPI.keychainService = MockKeychainService()
//        userAPI.sentrySDK = MockSentrySDK()

        // Call the register method with a mock appleId
        userAPI.register(appleId: "mockAppleId")

        // Add assertions to verify the expected behavior
    }

        func testRegisterFailure() {
            // Create an instance of UserAPI with mock dependencies
            var userAPI = UserAPI()
//            userAPI.networkManager = MockNetworkManager()
//            userAPI.keychainService = MockKeychainService()
//            userAPI.sentrySDK = MockSentrySDK()

            // Inject a mock that simulates failure during network request
//            userAPI.networkManager.shouldFailRequest = true

            // Call the register method with a mock appleId
            userAPI.register(appleId: "mockAppleId")

            // Add assertions to verify the expected behavior
        }
    
//    func testRegister_MakesPOSTRequest() {
//        let user = CreateUserBody(appleId: "1234567890", deviceId: "my-device-id")
//        let encoder = JSONEncoder()
//        let data = try? encoder.encode(user)
//        let request = NetworkRequest(url: APIEnvironment.createUser, method: .post, body: data)
//        XCTAssertEqual(request.httpMethod, "POST")
//        XCTAssertEqual(request.url, APIEnvironment.createUser)
//        XCTAssertEqual(request.body, data)
//    }
    
    
}

