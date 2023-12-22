import Foundation
import Sentry
import UIKit
import OSLog

struct TwitterBody: Codable {
    var listId: String
    var name: String
}

struct TwitterUpdateListBody: Codable {
    var listId: String
    var isActive: Bool
}


enum TwitterAPIEnvironment {
    static let baseURL = "https://x-api-backend.fly.dev/"
    static let list = "twitter/list"
    
    static func updateList(listId: String) -> String {
        return "twitter/\(listId)/update"
    }
    
    static func deleteList(listId: String) -> String {
        return TwitterAPIEnvironment.getListByListID(listId: listId)
    }
    
    static func getListByListID(listId: String) -> String {
        return "twitter/\(listId)"
    }
}

struct TwitterAPI {
    
    var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: "[TwitterAPI]")
    )
    
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func addTwitterList(listId: String, name: String, completion: ((Result<Bool, Error>) -> Void)? = nil) {
        let commentData = TwitterBody(listId: listId, name: name)
        guard let bodyData = try? JSONEncoder().encode(commentData) else {
            SentrySDK.capture(message: "[TwitterAPI][AddTwiterList] failed to encode data")
            return
        }
        self.networkManager.requestData(apiType: .twitter, from: TwitterAPIEnvironment.list, method: .post, body: bodyData) { (result: Result<NetworkResponse<TwitterModel>, NetworkError>) in
            switch result {
            case let .success(response):
                if response.statusCode == 400 {
                    self.logger.log("List already created")
                    completion?(.failure(NSError(domain: "List already created", code: -4)))
                    return
                }

                // Handle successful response
                guard let userID = response.data.id else {
                    SentrySDK.capture(message: "[TwitterAPI][AddTwiterList] list not created")
                    completion?(.failure(NSError(domain: "list not created", code: -2)))
                    return
                }
                
                self.logger.log("Success")
                SentrySDK.capture(message: "[TwitterAPI][AddTwiterList] Success")
                completion?(.success(true))

            case let .failure(error):
                // Handle error
                self.logger.log("Error: \(error)")
                SentrySDK.capture(message: "[TwitterAPI][AddTwiterList] Error: \(error)")
                completion?(.failure(error))
            }
        }
    }
    
    func updateTwitterList(listId: String, isActive: Bool, completion: ((Result<Bool, Error>) -> Void)? = nil) {
        let commentData = TwitterUpdateListBody(listId: listId, isActive: isActive)
        guard let bodyData = try? JSONEncoder().encode(commentData) else {
            SentrySDK.capture(message: "[TwitterAPI][UpdateTwiterList] failed to encode data")
            return
        }
        self.networkManager.requestData(apiType: .twitter, from: TwitterAPIEnvironment.updateList(listId: listId), method: .post, parameters: ["listId": listId, "isActive": isActive.description ]) { (result: Result<NetworkResponse<TwitterModel>, NetworkError>) in
            switch result {
            case let .success(response):
                if response.statusCode == 400 {
                    self.logger.log("List already created")
                    completion?(.failure(NSError(domain: "List already created", code: -4)))
                    return
                }

                // Handle successful response
                guard let userID = response.data.id else {
                    SentrySDK.capture(message: "[TwitterAPI][UpdateTwiterList] list not created")
                    completion?(.failure(NSError(domain: "list not created", code: -2)))
                    return
                }
                
                self.logger.log("Success")
                SentrySDK.capture(message: "[TwitterAPI][UpdateTwiterList] Success")
                completion?(.success(true))

            case let .failure(error):
                // Handle error
                self.logger.log("Error: \(error)")
                SentrySDK.capture(message: "[TwitterAPI][UpdateTwiterList] Error: \(error)")
                completion?(.failure(error))
            }
        }
    }


    func deleteTwitter(listId: String, completion: @escaping (Bool) -> Void) {
        self.logger.log("[TwitterAPI][DeleteTwitter] Deleting \(APIEnvironment.getUser())")
        self.networkManager.requestData(apiType: .twitter, from: TwitterAPIEnvironment.deleteList(listId: listId), method: .delete) { (result: Result<NetworkResponse<User>, NetworkError>) in
            switch result {
            case let .success(response):
                // Handle successful response
                if response.statusCode == 200 {
                    // Call completion with true since the process is successful
                    SentrySDK.capture(message: "[TwitterAPI][DeleteTwitter] Success")
                    completion(true)
                } else {
                    completion(false)
                }
            case let .failure(error):
                // Handle error
                self.logger.log("Error: \(error)")
                SentrySDK.capture(message: "[TwitterAPI][DeleteTwitter] Error: \(error)")
                // Call completion with false since the process failed
                completion(false)
            }
        }
    }
}

