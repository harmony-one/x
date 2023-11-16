
import Foundation
import UIKit
import Sentry

class DeviceInfo {
    static func getDeviceID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "Not available"
    }
}

struct CreateUserBody: Codable {
    var appleId: String
    var deviceId: String
}

struct TransactionBody: Codable {
    var transactionId: String
}

struct UserAPI {
    
    func register(appleId: String) {
        
        let commentData = CreateUserBody(appleId: appleId, deviceId: DeviceInfo.getDeviceID())
        guard let bodyData = try? JSONEncoder().encode(commentData) else {
            SentrySDK.capture(message: "[UserAPI][Register] failed to encode data")
            return
        }
        NetworkManager.shared.requestData(from: APIEnvironment.createUser, method: .post, body: bodyData) { (result: Result<NetworkResponse<User>, NetworkError>) in
            switch result {
            case .success(let response):
                if  response.statusCode == 400 {
                    print("User already created: \(response)")
                    print("Fetch User data")
                    self.getUserBy(appleId: appleId)
                    return
                }
                
                // Handle successful response
                guard let userID = response.data.id else {
                    SentrySDK.capture(message: "[UserAPI][Register] userID not created")
                    return
                }
                KeychainService.shared.storeUser(id: userID, balance: String(response.data.balance ?? 0), createdAt: response.data.createdAt, updatedAt: response.data.updatedAt, expirationDate: response.data.expirationDate)
                print("Success: \(response)")
                SentrySDK.capture(message: "[UserAPI][Register] Success")
               
            case .failure(let error):
                // Handle error
                print("Error: \(error)")
                SentrySDK.capture(message: "[UserAPI][Register] Error: \(error)")
            }
        }
    }
    
    func getUser(byType: String) {
        NetworkManager.shared.requestData(from:byType , method: .get) { (result: Result<NetworkResponse<User>, NetworkError>) in
            switch result {
            case .success(let response):
                print("Status Code: \(response.statusCode)")
                // Handle successful response
                guard let userID = response.data.id else {
                    SentrySDK.capture(message: "[UserAPI][Register] userID not created")
                    return
                }
                
                KeychainService.shared.storeUser(id: userID, balance: String(response.data.balance ?? 0), createdAt: response.data.createdAt, updatedAt: response.data.updatedAt, expirationDate: response.data.expirationDate)
                
                SentrySDK.capture(message: "[UserAPI][Register] Success")
            case .failure(let error):
                print("Error: \(error)")

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
            SentrySDK.capture(message: "[UserAPI][Register] failed to encode data")
            return
        }
        NetworkManager.shared.requestData(from: APIEnvironment.purchase(), method: .post, body: bodyData)  { (result: Result<NetworkResponse<User>, NetworkError>) in
            switch result {
            case .success(let response):
                // Handle successful response
                print("Success: \(response)")
                guard let userID = response.data.id else {
                    SentrySDK.capture(message: "[UserAPI][purchase] userID not created")
                    return
                }
                KeychainService.shared.storeUser(id: userID, balance: String(response.data.balance ?? 0), createdAt: response.data.createdAt, updatedAt: response.data.updatedAt, expirationDate: response.data.expirationDate)
                
                SentrySDK.capture(message: "[UserAPI][purchase] Success")
            case .failure(let error):
                // Handle error
                print("Error: \(error)")
                SentrySDK.capture(message: "[UserAPI][purchase] Error: \(error)")
            }
        }
    }
}
