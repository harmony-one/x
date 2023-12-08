import Foundation
import Sentry
import UIKit
import OSLog

enum DeviceInfo {
    static func getDeviceID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "Not available"
    }
}

struct CreateUserBody: Codable {
    var appleId: String
    var deviceId: String
}

struct CreateUserUpdateBody: Codable {
    var appVersion: String
}

struct TransactionBody: Codable {
    var transactionId: String
}

struct UserAPI {
    var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: "[UserAPI]")
    )
    func register(appleId: String) {
        let commentData = CreateUserBody(appleId: appleId, deviceId: DeviceInfo.getDeviceID())
        guard let bodyData = try? JSONEncoder().encode(commentData) else {
            SentrySDK.capture(message: "[UserAPI][Register] failed to encode data")
            return
        }
        NetworkManager.shared.requestData(from: APIEnvironment.createUser, method: .post, body: bodyData) { (result: Result<NetworkResponse<User>, NetworkError>) in
            switch result {
            case let .success(response):
                if response.statusCode == 400 {
                    self.logger.log("User already created")
                    self.getUserBy(appleId: appleId)
                    return
                }

                // Handle successful response
                guard let userID = response.data.id else {
                    SentrySDK.capture(message: "[UserAPI][Register] userID not created")
                    return
                }
                KeychainService.shared.storeUser(user: response.data)
                
                self.logger.log("Success")
                SentrySDK.capture(message: "[UserAPI][Register] Success")

            case let .failure(error):
                // Handle error
                self.logger.log("Error: \(error)")
                SentrySDK.capture(message: "[UserAPI][Register] Error: \(error)")
            }
        }
    }

    func getUser(byType: String) {
        NetworkManager.shared.requestData(from: byType, method: .get) { (result: Result<NetworkResponse<User>, NetworkError>) in
            switch result {
            case let .success(response):
                self.logger.log("[UserAPI][GetUser] Status Code: \(response.statusCode)")
                // Handle successful response
                guard let userID = response.data.id else {
                    SentrySDK.capture(message: "[UserAPI][Register] userID not created")
                    return
                }
                KeychainService.shared.storeUser(user: response.data)
                SentrySDK.capture(message: "[UserAPI][GetUser] Success")
            case let .failure(error):
                self.logger.log("[UserAPI][GetUser] byType: \(byType) Error: \(error)")
            }
        }
    }

    func getUserByID() {
        getUser(byType: APIEnvironment.getUser())
    }

    func getUserBy(appleId: String) {
        getUser(byType: APIEnvironment.getUser(byAppleID: appleId))
    }

    func purchase(transactionId: String) {
        let commentData = TransactionBody(transactionId: transactionId)
        guard let bodyData = try? JSONEncoder().encode(commentData) else {
            SentrySDK.capture(message: "[UserAPI][Purchase] failed to encode data")
            return
        }
        NetworkManager.shared.requestData(from: APIEnvironment.purchase(), method: .post, body: bodyData) { (result: Result<NetworkResponse<User>, NetworkError>) in
            switch result {
            case let .success(response):
                // Handle successful response
                self.logger.log("[UserAPI][Purchase] Success")
                guard let userID = response.data.id else {
                    SentrySDK.capture(message: "[UserAPI][Purchase] userID not created")
                    return
                }
                KeychainService.shared.storeUser(user: response.data)
                SentrySDK.capture(message: "[UserAPI][Purchase] Success")
            case let .failure(error):
                // Handle error
                self.logger.log("[UserAPI][Purchase] Error: \(error)")
                SentrySDK.capture(message: "[UserAPI][Purchase] Error: \(error)")
            }
        }
    }
    
    func deleteUserAccount(apiKey: String, completion: @escaping (Bool) -> Void) {
        self.logger.log("[UserAPI][deleteUserAccount] Deleting \(APIEnvironment.getUser())")
        NetworkManager.shared.requestData(from: APIEnvironment.getUser(), method: .delete, customHeaders: ["X-API-KEY": apiKey]) { (result: Result<NetworkResponse<User>, NetworkError>) in
            switch result {
            case let .success(response):
                // Handle successful response
                if response.statusCode == 200 {
                    // Call completion with true since the process is successful
                    SentrySDK.capture(message: "[UserAPI][DeleteAccount] Success")
                    completion(true)
                } else {
                    completion(false)
                }
            case let .failure(error):
                // Handle error
                self.logger.log("Error: \(error)")
                SentrySDK.capture(message: "[UserAPI][DeleteAccount] Error: \(error)")
                // Call completion with false since the process failed
                completion(false)
            }
        }
    }

    func updateUser(apiKey: String, appVersion: String) {
        var methodName = "[UserAPI][updateUser]"
        self.logger.log("\(methodName) appVersion: \(appVersion)")
        
        let updateData = CreateUserUpdateBody(appVersion: appVersion)
        guard let bodyData = try? JSONEncoder().encode(updateData) else {
            SentrySDK.capture(message: "[UserAPI][Register] failed to encode data")
            return
        }

        NetworkManager.shared.requestData(from: APIEnvironment.updateUser(), method: .post, body: bodyData, customHeaders: ["X-API-KEY": apiKey]) { (result: Result<NetworkResponse<User>, NetworkError>) in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    SentrySDK.capture(message: "\(methodName) Success")
                }
            case let .failure(error):
                self.logger.log("Error: \(error)")
                SentrySDK.capture(message: "\(methodName) Error: \(error)")
            }
        }
    }
}
